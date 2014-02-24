require_relative 'utils'
require_relative 'wait_for_signal_activities'

class WaitForSignalWorkflow
  extend AWS::Flow::Workflows

  workflow :place_order do
    {
      :version => "1.0",
      :task_list => $WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 60,
      :task_start_to_close_timeout => 20,
    }
  end

  activity_client(:client){ {:from_class => "WaitForSignalActivities"} }
  signal :change_order
  def initialize
    @change_order_period = 30
    @signal_received = Future.new
  end

  def place_order(original_amount)
    timer = create_timer_async(@change_order_period)
    wait_for_any(timer, @signal_received)
    process_order(original_amount)
  end

  def process_order(original_amount)
    amount = original_amount
    amount = @signal_received.get if @signal_received.set?
    client.process_order(amount)
  end

  def change_order(amount)
    @signal_received.set(amount) unless @signal_received.set?
  end
end
