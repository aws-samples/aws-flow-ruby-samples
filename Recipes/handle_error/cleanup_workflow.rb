require_relative 'handle_error_activities'

# Shows how to clean up when failures are encountered during a workflow execution.
class CleanUpWorkflow
  extend AWS::Flow::Workflows

  # Define workflow entry point.
  workflow :cleaup_workflow do
    {
      version: "1.0",
      task_list: "cleanup_resource_workflow",
      execution_start_to_close_timeout: 120,
    }
  end

  # Get an activity_client used to schedule activities
  activity_client(:client) { { from_class: "HandleErrorActivities" } }

  # clean up in case of failure
  def cleanup_workflow
    # Create a new future to set if an exception occurs. This is used to
    # determine whether a rollback is needed or not.
    should_rollback = Future.new

    # allocate a resource synchronously.
    resource_id = client.allocate_resource

    # error_handler (modeled after begin/rescue/ensure) is used to handle errors
    # from asynchronous activities or workflows.
    error_handler do |t|
      t.begin do
        # schedule the use_resource activity asynchronously.
        client.send_async(:use_resource, resource_id)
      end
      t.rescue Exception do |ex|
        # If an exception occurs, set the future to true.
        should_rollback.set(true)
      end
      t.ensure do
        # If the future (should_rollback) was set, call the rollback activity.
        client.rollback(resource_id) if should_rollback.set?
        # Call the cleanup activity to clean the resources once everything is
        # done (whether or not an error occurred).
        client.cleanup(resource_id)
      end
    end
  end
end
