require_relative 'handle_error_activities'

# custom exceptions used in this recipe
class ResourceNoResponseException < Exception; end
class ResourceNotAvailableException < Exception; end

# shows how to handle errors encountered during workflow execution.
class HandleErrorWorkflow
  extend AWS::Flow::Workflows

  # define the workflow entry point.
  workflow :handle_error_workflow do
    {
      version: "1.0",
      task_list: "handle_error_workflow",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client used to schedule the activities
  activity_client(:client){ {from_class: "RecipeActivity"} }

  def handle_error_workflow

    # schedule the allocate_resource activity synchronously. Its output is
    # needed for use_resource.
    resource_id = client.allocate_resource

    # error_handler (modeled after begin/rescue/ensure) is used to handle errors
    # from asynchronous activities or workflows.
    error_handler do |t|
      t.begin do
        # schedule the use_resource activity asynchronously. It could throw an
        # exception if the resource is bad or unavailable.
        client.send_async(:use_resource, resource_id)
      end
      t.rescue ActivityTaskFailedException do |e|
        if e.cause.instance_of? ResourceNoResponseException
          # bad resource: report it by running the report_resource activity.
          client.report_resource(resource_id)
        elsif e.cause.instance_of? ResourceNotAvailableException
          # resource isn't available: refresh the resource catalog by running
          # the refresh_catalog activity.
          client.refresh_catalogue(resource_id)
        else
          # Not one of the handled types; throw the exception again to be
          # handled higher in the execution chain.
          throw e
        end
      end
    end
  end
end
