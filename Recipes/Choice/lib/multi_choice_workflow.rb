require_relative 'utils'
require_relative 'order_activities'

class MultiChoiceWorkflow
    extend AWS::Flow::Workflows

  workflow :process_order do
    {
      :version => "1.0",
      :task_list => $MULTI_CHOICE_WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client){ {:from_class => "OrderActivities"} }

  def process_order
    results = process_basket_order(client.get_basket_order)
    wait_for_all(*results)
    client.finish_order
  end

  def process_basket_order(basket_choice)
    basket_choice.map { |item_choice| process_single_choice(item_choice) }
  end

  def process_single_choice(item_choice)

    case item_choice
    when :apple
      client.send_async(:order_apple)
    when :orange
      client.send_async(:order_orange)
    end

    # The above can also be written as -
    # client.send_async("order_#{item_choice}")
  end
end
