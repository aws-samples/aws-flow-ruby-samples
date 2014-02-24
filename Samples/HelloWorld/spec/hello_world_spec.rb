require_relative 'spec_helper'

describe HelloWorldWorkflow do
  activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $task_list, HelloWorldActivity)
  worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $task_list, HelloWorldWorkflow)
  activity_worker.register
  worker.register

  my_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "HelloWorldWorkflow"} }

  $forking_executor = ForkingExecutor.new(:max_workers => 3)
  $forking_executor.execute { worker.start }
  $forking_executor.execute { activity_worker.start }

  puts "Starting an execution..."
  $workflow_execution = my_workflow_client.start_execution("User")

  sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? $workflow_execution.events.to_a.last.event_type

  after(:all) do
    $forking_executor.shutdown(1)
  end


  describe "Workflow History" do
    let (:events) {$workflow_execution.events}
    describe "#event" do
      context "when workflow starts" do
        let(:event) { events.to_a.first }
        
        subject { event }
        its(:event_type) { should == "WorkflowExecutionStarted" }

        describe "workflow_type" do
          subject { event.attributes.workflow_type }
          its(:name) { should == "HelloWorldWorkflow.hello_workflow" }
          its(:domain) { should == $domain }
        end

      end

      context "when workflow completes" do
        subject { events.to_a.last }
        its(:event_type) { should == "WorkflowExecutionCompleted" }
      end
    end

    describe "activities" do
      
      # list of all the activities that should have been scheduled in the test
      let(:activity_list) { ["HelloWorldActivity.hello_activity"] }
      # creates a list of all activity names that were scheduled during the workflow execution
      let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }
      describe "that were never scheduled" do
        subject { activity_list - scheduled_activities }
        its(:empty?) { should be_true, "following activities were never scheduled: #{activity_list - scheduled_activities}" }
      end
      describe "that should not have been scheduled" do
        subject { scheduled_activities -  activity_list }
        its(:empty?) {should be_true, "following activities should not have been scheduled: #{scheduled_activities - activity_list}" }
      end
    end
  end
end
