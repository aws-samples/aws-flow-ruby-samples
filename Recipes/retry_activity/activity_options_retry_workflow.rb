require_relative '../../../utils'
require_relative 'retry_activities'

# Shows how to set up retry for activities using options during activity
# registration.
class ActivityOptionsRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      version: "1.0",
      task_list: "retry_workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client used to schedule activities.
  activity_client(:client) { { from_class: "RetryActivities" } }

  def process
    # This workflow just runs the unreliable activity.
    client.unreliable_activity_with_retry_options
  end
end
