require_relative 'utils'

class WaitForSignalActivities
  extend AWS::Flow::Activities

  activity :process_order do
    {
      :version => "1.0",
      :default_task_list => $ACTIVITY_TASK_LIST,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end

  def process_order(amount)
    $logger << "process an order with amount:#{amount}\n"
    amount
  end
end
