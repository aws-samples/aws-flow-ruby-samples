require_relative 'retry_activities'

# Shows how to set retry options on activities using the activity_client.
class ClientOptionsRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client used to schedule activities. Set the activity
  # runtime options by passing activity options to the activity client. Options
  # set at the client level override the options set during registration.
  activity_client(:client) do
    {
      from_class: "RetryActivities",
      exponential_retry: {
        maximum_attempts: 5,
        exceptions_to_retry: [ArgumentError],
      }
    }
  end

  # Run the unreliable activity that was registered without retry options. Retry
  # options are set on the client.
  def process
    client.unreliable_activity_without_retry_options
  end
end
