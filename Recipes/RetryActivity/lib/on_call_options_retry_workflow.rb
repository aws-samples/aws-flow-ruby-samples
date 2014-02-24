require_relative 'utils'
require_relative 'retry_activities'


class OnCallOptionsRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      :version => "1.0",
      :task_list => $WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client) { {:from_class => "RetryActivities"} }

  def process
    client.send(:unreliable_activity_without_retry_options) do
      {
        :exponential_retry => {
          :maximum_attempts => 5,
          :exceptions_to_retry => [ArgumentError],
        }
      }
    end
  end
end
