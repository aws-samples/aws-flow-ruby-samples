require_relative 'utils'

class OrderProcessActivities
  extend AWS::Flow::Activities

  activity :get_amount, :get_card do
    {
      :version => "1.0",
      :default_task_list => $ORDER_PROCESS_ACTIVITY_TASK_LIST,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end

  def get_amount
    amount = 10
    $logger << "amount:#{amount}\n"
    amount
  end

  def get_card
    card = "major_card_company$foo"
    $logger << "card:#{card}\n"
    card
  end
end
