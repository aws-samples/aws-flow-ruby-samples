require_relative 'utils'

class OrderActivities
  extend AWS::Flow::Activities

  activity :order_apple, :order_orange, :get_item_order, :get_basket_order, :finish_order do
    {
      :version => "1.0",
      :default_task_list => $ACTIVITY_TASK_LIST,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end

  def order_apple
    $logger << "ordering apples for customers...\n"
  end

  def order_orange
    $logger << "ordering oranges for customers...\n"
  end

  def get_item_order
    $logger << "generating item order for customers...\n"
    :apple
  end

  def get_basket_order
    $logger << "generating basket order for customers...\n"
    [:apple, :orange]
  end

  def finish_order
    $logger << "completing the order for customers...\n"
  end
end
