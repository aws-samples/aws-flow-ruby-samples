require_relative '../../../utils'
require_relative 'retry_activities'

# Shows how to turn jitter off in the retry policy. Turning jitter off can be
# useful during testing.
class NoJitterRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Set the should_jitter option to false in the passed-in options.
  activity_client(:client) do
    {
      from_class: "RetryActivities",
      exponential_retry: {
        should_jitter: false,
        maximum_attempts: 5,
        exceptions_to_retry: [StandardError],
      }
    }
  end

  def process
    client.unreliable_activity_with_retry_options
  end
end

