require_relative 'utils'
require_relative 'retry_activities'

class CustomLogicSyncRetryWorkflow
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
    handle_unreliable_activity
  end

  def handle_unreliable_activity
    begin
      client.unreliable_activity_without_retry_options
    rescue Exception => e
      retry_on_failure(e)
    end
  end

  def retry_on_failure(ex)
    handle_unreliable_activity if should_retry(ex)
  end

  def should_retry(ex)
    # custom logic to decide to retry the activity or not according to 'ex'
    return true
  end
end
