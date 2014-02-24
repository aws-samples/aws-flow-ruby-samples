require_relative 'spec_helper'

describe HumanTaskWorkflow do
  before(:all) do
    activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $ACTIVITY_TASK_LIST, HumanTaskActivities)
    workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $WORKFLOW_TASK_LIST, HumanTaskWorkflow)
    activity_worker.register
    workflow_worker.register

    puts "Starting an execution..."
    my_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "HumanTaskWorkflow"} }
    @workflow_execution = my_workflow_client.start_execution
    workflow_worker.run_once
    # automate activity
    activity_worker.run_once
    workflow_worker.run_once
    # human activity
    activity_worker.run_once
    # wait for the task token to be printed before prompting the user
    sleep 5 until "ActivityTaskStarted" == @workflow_execution.events.to_a.last.event_type
    HumanTaskConsole.new.run
    workflow_worker.run_once
    # send notification
    activity_worker.run_once
    workflow_worker.run_once

    sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @workflow_execution.events.to_a.last.event_type

  end


  it "completed successfully" do
    @workflow_execution.events.to_a.last.event_type.should == "WorkflowExecutionCompleted"
  end
end
