require_relative 'utils'
require_relative 'order_process_activities'
require_relative 'payment_process_workflow'

class OrderProcessWorkflow
  extend AWS::Flow::Workflows

  workflow :process_order do
    {
      :version => "1.0",
      :task_list => $ORDER_PROCESS_WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client){ {:from_class => "OrderProcessActivities"} }

  def process_order
    amount = client.get_amount
    card = client.get_card
    
    # start a child workflow to process payment inside this workflow
    payment_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "PaymentProcessWorkflow"} }
    payment_workflow_client.start_execution(amount, card)
  end
end
