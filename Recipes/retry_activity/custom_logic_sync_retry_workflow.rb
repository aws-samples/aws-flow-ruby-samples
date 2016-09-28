require_relative 'retry_activities'

# Shows how to set up custom retry logic for activities
class CustomLogicSyncRetryWorkflow
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

  # the entry point for the workflow
  def process
    handle_unreliable_activity
  end

  # Standard ruby begin / rescue / ensure blocks can be used for error handling
  # on synchronous methods.
  def handle_unreliable_activity
    begin
      client.unreliable_activity_without_retry_options
    rescue Exception => e
      # pass the exception to retry on failure.
      retry_on_failure(e)
    end
  end

  def retry_on_failure(ex)
    # retry only if should_retry says so.
    handle_unreliable_activity if should_retry(ex)
  end

  def should_retry(ex)
    # This could contain custom logic that determines whether to retry the
    # activity or not according to 'ex'
    return true
  end
end
