require_relative 'handle_error_activities'

# CleanUpWorkflow class defines a workflow for the handle_error 
# recipe. This recipe shows how to cleanup in case of failures encountered 
# during a workflow execution.
class CleanUpWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :cleanup_workflow do
    {
      version: "1.0",
      task_list: "cleanup_resource_workflow",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "HandleErrorActivities" } }

  # This is the entry point for the workflow
  def cleanup_workflow

    # Create a new future that will be set if an exception occurs. This will 
    # tell us whether a rollback is needed or not.
    should_rollback = Future.new
    resource_id = client.allocate_resource

    # If your activities or workflows are asynchronous, (using send_async), you
    # must use error_handler, which is modeled after the begin / rescue / ensure
    # pattern, for error handling.
    error_handler do |t|
      t.begin do
        # Use the activity client to schedule the activity asynchronously.
        client.send_async(:use_resource, resource_id)
      end
      t.rescue Exception do |ex|
        # If an exception occurs, set the future's value to true. This way in 
        # the ensure step we will know if a rollback is needed or not.
        should_rollback.set(true)
      end
      t.ensure do
        # If rollback was set, then call the activity to rollback the changes.
        client.rollback(resource_id) if should_rollback.set?
        # Call the cleanup actvity to clean the resources once everything is
        # done.
        client.cleanup(resource_id) 
      end
    end
  end
end
