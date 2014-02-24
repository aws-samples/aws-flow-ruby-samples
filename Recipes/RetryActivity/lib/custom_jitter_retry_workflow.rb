require_relative 'utils'
require_relative 'retry_activities'

class CustomJitterRetryWorkflow
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
        :should_jitter => true,
        :jitter_function => lambda do |seed, max_value|
          Random.new(seed.to_i).rand(max_value)
        end,
        :maximum_attempts => 5,
        :exceptions_to_retry => [StandardError],
      }
    }
  end

  def process
    client.unreliable_activity_with_retry_options
  end
end
