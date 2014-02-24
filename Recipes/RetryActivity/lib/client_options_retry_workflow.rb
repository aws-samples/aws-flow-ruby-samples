require_relative 'utils'
require_relative 'retry_activities'

class ClientOptionsRetryWorkflow
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
        :maximum_attempts => 5,
        :exceptions_to_retry => [ArgumentError],
      }
    }
  end

  def process
    client.unreliable_activity_without_retry_options
  end
end
