require_relative 'retry_activities'

# OnCallOptionsRetryWorkflow class defines a workflow for the retry_activity
# recipes. This recipe shows how to set up retry for activities during
# invocation. It is done by passing in a block of retry options to the activity
# client when invoking the activity.
class OnCallOptionsRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities. 
  activity_client(:client) { { from_class: "RetryActivities" } }

  def process

    # Pass in retry options to the activity client when invoking the activity.
    # Options set during invocation will override all other options set for 
    # this activity until this point.
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
