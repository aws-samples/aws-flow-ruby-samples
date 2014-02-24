require_relative 'utils'
require_relative 'retry_activities'

class ActivityOptionsRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      :version => "1.0",
      :task_list => $WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client) { {:from_class => "RetryActivities"}}

  def process
    client.unreliable_activity_with_retry_options
  end
end
