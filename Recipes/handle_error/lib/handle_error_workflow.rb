require_relative 'handle_error_activities'

# These are custom exceptions used in this recipe that demonstrate how to handle
# different exceptions differently.
class ResourceNoResponseException < Exception; end
class ResourceNotAvailableException < Exception; end

# HandleErrorWorkflow class defines a workflow for the handle_error 
# recipe. This recipe shows how to handle errors encountered during workflow
# execution.
class HandleErrorWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :handle_error_workflow do
    {
      version: "1.0",
      task_list: "handle_error_workflow",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client){ {from_class: "RecipeActivity"} }

  # This is the entry point for the workflow
  def handle_error_workflow

    resource_id = client.allocate_resource

    # If your activities or workflows are asynchronous, (using send_async), you
    # must use error_handler, which is modeled after the begin / rescue / ensure
    # pattern, for error handling.
    error_handler do |t|
      t.begin do
        # Use the activity client to schedule the activity asynchronously.
        client.send_async(:use_resource, resource_id)
      end
      t.rescue ActivityTaskFailedException do |e|
        if e.cause.instance_of? ResourceNoResponseException
          # If the exception is of type ResourceNoResponseException, run the
          # activity to report this as a bad resource.
          client.report_resource(resource_id) 
        elsif e.cause.instance_of? ResourceNotAvailableException
          # If the exception is of type ResourceNotAvailableException, run the
          # activity to refresh the resource catalog
          client.refresh_catalogue(resource_id)
        else
          # If the exception is not one of the handled types, then throw it
          # again to be handled up the chain.
          throw e
        end
      end
    end
  end
end
