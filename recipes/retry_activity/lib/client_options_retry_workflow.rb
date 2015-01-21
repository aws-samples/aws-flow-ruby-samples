require_relative 'retry_activities'

# ClientOptionsRetryWorkflow class defines a workflow for the retry_activity
# recipes. This recipe shows how to set up retry for activities using the
# activity_client. Options set at the client level override the options set
# during registration. 
class ClientOptionsRetryWorkflow
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
  # as a has to the activity client.
  activity_client(:client) do
    {
      from_class: "RetryActivities",
      exponential_retry: {
        maximum_attempts: 5,
        exceptions_to_retry: [ArgumentError],
      }
    }
  end

  # This is the workflow entry point
  def process
    client.unreliable_activity_without_retry_options
  end
end
