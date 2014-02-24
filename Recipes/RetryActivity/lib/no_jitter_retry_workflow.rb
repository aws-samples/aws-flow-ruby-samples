require_relative 'utils'
require_relative 'retry_activities'

class NoJitterRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      :version => "1.0",
      :task_list => $WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client) do
    {
      :from_class => "RetryActivities",
      :exponential_retry => {
        # the default value for should_jitter is true
        :should_jitter => false,
        :maximum_attempts => 5,
        :exceptions_to_retry => [StandardError],
      }
    }
  end

  def process
    handle_unreliable_activity
  end

  def handle_unreliable_activity
    client.unreliable_activity_with_retry_options
  end
end

