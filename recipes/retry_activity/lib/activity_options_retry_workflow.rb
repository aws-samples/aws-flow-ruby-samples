require_relative '../../../utils'
require_relative 'retry_activities'

# ActivityOptionsRetryWorkflow class defines a workflow for the retry_activity
# recipes. This recipe shows how to set up retry for activities using options
# during activity registration. Note that the activity registration options are
# in the recipe_activities.rb file.
class ActivityOptionsRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      version: "1.0",
      task_list: "retry_workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities. 
  activity_client(:client) { { from_class: "RetryActivities" } }

  def process
    # This workflow just runs the unreliable activity. The actual retry options
    # are set up in the recipe_activities.rb file.
    client.unreliable_activity_with_retry_options
  end
end
