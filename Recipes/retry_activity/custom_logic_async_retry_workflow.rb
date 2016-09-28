require_relative '../../../utils'
require_relative 'retry_activities'

# Shows how to set up custom retry logic for activities.
class CustomLogicAsyncRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client used to schedule activities.
  activity_client(:client) { { from_class: "RetryActivities" } }

  # This is the entry point for the workflow
  def process
    handle_unreliable_activity
  end

  # use the error_handler construct for handling errors in asynchronous
  # activities. When an exception is caught, retry the activity based on custom
  # retry logic.
  def handle_unreliable_activity

    # This future will be set when an exception is set with the details of the
    # exception
    failure = Future.new

    error_handler do |t|
      t.begin do
        # Schedule the activity asynchronously
        client.send_async(:unreliable_activity_without_retry_options)
      end
      t.rescue Exception do |e|
        # Set the future with the details of the exception
        failure.set(e)
      end
      t.ensure do
        failure.set unless failure.set?
      end
    end

    # Blocks until the failure Future is ready.
    wait_for_all(failure)

    # Once the future has been set, retry the activity if a failure was
    # encountered
    retry_on_failure(failure)
  end

  def retry_on_failure(failure)
    ex = failure.get
    handle_unreliable_activity if !ex.nil? && should_retry(ex)
  end

  def should_retry(ex)
    # custom logic to decide to retry the activity or not according to 'ex'
    return true
  end
end
