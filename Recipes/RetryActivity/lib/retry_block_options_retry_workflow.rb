require_relative 'utils'
require_relative 'retry_activities'

class RetryBlockOptionsRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :handle_unreliable_activity do
    {
      :version => "1.0",
      :task_list => $WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client) { {:from_class => "RetryActivities"}}

  def handle_unreliable_activity
    retry_options = {
      :exponential_retry => {
        :maximum_attempts => 5,
        :exceptions_to_retry => [ArgumentError],
      }
    }

    # the code in block will be retried if an exception is thrown
    # with options specified in 'retry_options'
    with_retry(retry_options) do
      client.unreliable_activity_without_retry_options
    end
  end    

end
