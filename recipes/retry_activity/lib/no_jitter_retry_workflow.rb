require_relative '../../../utils'
require_relative 'retry_activities'

# NoJitterRetryWorkflow class defines a workflow for the retry_activity
# recipes. This recipe shows how to turn jitter off in the retry policy. Turning
# jitter off can be useful during testing.
class NoJitterRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities. Set the activity runtime options by passing in activity options
  # as a has to the activity client. Here we set the should_jitter option to
  # false.
  activity_client(:client) do
    {
      from_class: "RetryActivities",
      exponential_retry: {
        # the default value for should_jitter is true
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

