require_relative 'utils'
require_relative 'payment_activities'

class PaymentProcessWorkflow
  extend AWS::Flow::Workflows

  workflow :pay do
    {
      :version => "1.0",
      :task_list => $PAYMENT_WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client){ {:from_class => "PaymentActivities"} }

  def pay(amount, card)
    client.process_payment(amount, card)
  end
end
