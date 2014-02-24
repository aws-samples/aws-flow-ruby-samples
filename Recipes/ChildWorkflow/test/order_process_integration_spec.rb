require_relative 'spec_helper'

describe OrderProcessWorkflow do

  before(:all) do 
    order_process_activities_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $ORDER_PROCESS_ACTIVITY_TASK_LIST, OrderProcessActivities)
    payment_activities_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $PAYMENT_ACTIVITY_TASK_LIST, PaymentActivities)
    order_process_workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $ORDER_PROCESS_WORKFLOW_TASK_LIST, OrderProcessWorkflow)
    payment_process_workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $PAYMENT_WORKFLOW_TASK_LIST, PaymentProcessWorkflow)
    order_process_activities_worker.register
    payment_activities_worker.register
    order_process_workflow_worker.register
    payment_process_workflow_worker.register

    puts "Starting an execution..."
    my_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "OrderProcessWorkflow"} }
    @workflow_execution = my_workflow_client.start_execution

    forking_executor = ForkingExecutor.new(:max_workers => 4)
    forking_executor.execute { order_process_workflow_worker.start }
    forking_executor.execute { payment_process_workflow_worker.start }
    forking_executor.execute { order_process_activities_worker.start }
    forking_executor.execute { payment_activities_worker.start }

    sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @workflow_execution.events.to_a.last.event_type

    forking_executor.shutdown(1)

  end

  it "completed successfully" do
    @workflow_execution.events.to_a.last.event_type.should == "WorkflowExecutionCompleted" 
  end

end



