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
    ex = Future.new
    resource_id = client.allocate_resource

    # error_handler (modeled after begin/rescue/ensure) is used to handle errors
    # from asynchronous activities or workflows.
    error_handler do |t|
      t.begin do
        # schedule the use_resource activity asynchronously.
        client.send_async(:use_resource, resource_id)
      end
      t.rescue Exception do |e|
        # Set the future for handle_exception
        ex.set(e)
      end
      t.ensure do
        # call handle_exception if the future was set
        handle_exception(ex.get, resource_id) if ex.set?
      end
    end
  end

  # handle an exception (or re-throw it)
  def handle_exception(e, resource_id)
    if e.cause.instance_of? ResourceNoResponseException
      # no response? report this as a bad resource.
      client.report_resource(resource_id)
    elsif e.cause.instance_of? ResourceNotAvailableException
      # not available? refresh the resource catalog
      client.refresh_catalogue(resource_id)
    else
      # unhandled exception: re-throw it.
      throw e
    end
  end
end
