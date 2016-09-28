require_relative 'retry_activities'

# Shows how to set up retry for activities using with_retry
class RetryBlockOptionsRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :handle_unreliable_activity do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client used to schedule activities.
  activity_client(:client) { { from_class: "RetryActivities" } }

  # pass options in a block to the activity method.
  def handle_unreliable_activity
    retry_options = {
      exponential_retry: {
        maximum_attempts: 5,
        exceptions_to_retry: [ArgumentError],
      }
    }

    # schedule the activity with the required retry options. The code in the
    # block will be retried if an exception is thrown with options specified in
    # 'retry_options'
    with_retry(retry_options) do
      client.unreliable_activity_without_retry_options
    end
  end
end
