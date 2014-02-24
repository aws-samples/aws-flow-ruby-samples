require_relative 'utils'
require_relative 'order_activities'

class ExclusiveChoiceWorkflow
  extend AWS::Flow::Workflows

  workflow :process_order do
    {
      :version => "1.0",
      :task_list => $EXCLUSIVE_CHOICE_WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client){ {:from_class => "OrderActivities"} }

  def process_order
    process_item_order(client.get_item_order)
    client.finish_order
  end

  def process_item_order(item_choice)
    case item_choice
    when :apple
      client.order_apple
    when :orange
      client.order_orange
    end

    # The above can also be written as -
    # client.send("order_#{item_choice}")
  end
end
