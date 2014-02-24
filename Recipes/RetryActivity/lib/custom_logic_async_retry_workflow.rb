require_relative 'utils'
require_relative 'retry_activities'

class CustomLogicAsyncRetryWorkflow
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
    failure = Future.new

    error_handler do |t|
      t.begin do
        client.send_async(:unreliable_activity_without_retry_options)
      end
      t.rescue Exception do |e|
        failure.set(e)
      end
      t.ensure do
        failure.set unless failure.set?
      end
    end

    wait_for_all(failure)
    retry_on_failure(failure)

  end

  def retry_on_failure(failure)
    ex = failure.get
    handle_unreliable_activity if ! ex.nil? && should_retry(ex)
  end

  def should_retry(ex)
    # custom logic to decide to retry the activity or not according to 'ex'
    return true
  end
end
