require_relative 'spec_helper'

describe PickFirstBranchWorkflow do

  before(:all) do
    activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $ACTIVITY_TASK_LIST, SearchActivities)
    workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $WORKFLOW_TASK_LIST, PickFirstBranchWorkflow)
    activity_worker.register
    workflow_worker.register

    puts "Starting an execution..."
    my_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "PickFirstBranchWorkflow"} }

    forking_executor = ForkingExecutor.new(:max_workers => 2)
    forking_executor.execute { workflow_worker.start }
    forking_executor.execute { activity_worker.start }

    @workflow_execution = my_workflow_client.start_execution("keyword")

    sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @workflow_execution.events.to_a.last.event_type
    forking_executor.shutdown(1)
  end

  it "completed successfully" do
    @workflow_execution.events.to_a.last.event_type.should == "WorkflowExecutionCompleted"
  end
end
