require_relative 'spec_helper'

describe BookingWorkflow do

  @activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $activity_task_list, BookingActivity)
  @workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, BookingWorkflow)
  @activity_worker.register
  @workflow_worker.register
  $my_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "BookingWorkflow"} }
  $requestId = "100"
  $customerId = "1"
  $forking_executor = ForkingExecutor.new(:max_workers => 3)
  $forking_executor.execute { @workflow_worker.start }
  $forking_executor.execute { @activity_worker.start }

  after(:all) do
    $forking_executor.shutdown(1)
  end

  describe "Workflow History" do

    context "when booking both air and car" do
      before(:all) do
        @reserve_both_workflow_execution = $my_workflow_client.start_execution(@requestId, @customerId, true, true)
        sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @reserve_both_workflow_execution.events.to_a.last.event_type
      end
      let(:events) { @reserve_both_workflow_execution.events }
      let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }

      it "should complete successfully" do
        events.to_a.last.event_type.should == "WorkflowExecutionCompleted" 
      end

      it "should schedule 3 activities" do
        scheduled_activities.count.should == 3
      end

      it "should schedule activities in right order" do
        expected_trace = [["BookingActivity.reserve_car", "BookingActivity.reserve_airline", "BookingActivity.send_confirmation"], ["BookingActivity.reserve_airline", "BookingActivity.reserve_car", "BookingActivity.send_confirmation"]]
        expected_trace.should include scheduled_activities    
      end
    end
   context "when booking only air" do
      before(:all) do
        @reserve_air_workflow_execution = $my_workflow_client.start_execution(@requestId, @customerId, true, false)
        sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @reserve_air_workflow_execution.events.to_a.last.event_type
      end
      let(:events) { @reserve_air_workflow_execution.events }
      let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }

      it "should complete successfully" do
        events.to_a.last.event_type.should == "WorkflowExecutionCompleted" 
      end

      it "should schedule 2 activities" do
        scheduled_activities.count.should == 2
      end

      it "should schedule activities in right order" do
        expected_trace = [["BookingActivity.reserve_airline", "BookingActivity.send_confirmation"]]
        expected_trace.should include scheduled_activities    
      end
    end
   context "when booking only car" do
      before(:all) do
        @reserve_car_workflow_execution = $my_workflow_client.start_execution(@requestId, @customerId, false, true)
        sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @reserve_car_workflow_execution.events.to_a.last.event_type
      end
      let(:events) { @reserve_car_workflow_execution.events }
      let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }

      it "should complete successfully" do
        events.to_a.last.event_type.should == "WorkflowExecutionCompleted" 
      end

      it "should schedule 2 activities" do
        scheduled_activities.count.should == 2
      end

      it "should schedule activities in right order" do
        expected_trace = [["BookingActivity.reserve_car", "BookingActivity.send_confirmation"]]
        expected_trace.should include scheduled_activities    
      end
    end

   context "when booking none" do
      before(:all) do
        @reserve_none_execution = $my_workflow_client.start_execution(@requestId, @customerId, false, false)
        sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @reserve_none_execution.events.to_a.last.event_type
      end
      let(:events) { @reserve_none_execution.events }
      let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }

      it "should complete successfully" do
        events.to_a.last.event_type.should == "WorkflowExecutionCompleted" 
      end

      it "should schedule only 1 activity" do
        scheduled_activities.count.should == 1
      end

      it "should schedule activities in right order" do
        expected_trace = [["BookingActivity.send_confirmation"]]
        expected_trace.should include scheduled_activities    
      end
    end


  end

end
