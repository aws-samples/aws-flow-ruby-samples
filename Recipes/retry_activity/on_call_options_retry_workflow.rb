require_relative 'retry_activities'

# Shows how to set up retry for activities during invocation.
class OnCallOptionsRetryWorkflow
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

  def process
    # Pass retry options to the activity client when scheduling the activity.
    client.send(:unreliable_activity_without_retry_options) do
      {
        exponential_retry: {
          maximum_attempts: 5,
          exceptions_to_retry: [ArgumentError],
        }
      }
    end
  end
end
