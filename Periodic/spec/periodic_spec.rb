require_relative 'spec_helper'

describe PeriodicWorkflow do

  before(:all) do
    periodic_activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $periodic_activity_task_list, PeriodicActivity)
    error_reporting_activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $error_reporting_activity_task_list, ErrorReportingActivity)
    workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, PeriodicWorkflow)
    periodic_activity_worker.register
    error_reporting_activity_worker.register
    workflow_worker.register

    @activity_name ="do_some_work"
    @prefix_name ="PeriodicActivity"
    @activity_args=["parameter1"]
    @my_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "PeriodicWorkflow"} }

    $forking_executor = ForkingExecutor.new(:max_workers => 10)
    $forking_executor.execute { workflow_worker.start }
    $forking_executor.execute { periodic_activity_worker.start }
    $forking_executor.execute { error_reporting_activity_worker.start }

  end

  context "when workflow continues as new" do

    before(:all) do
      running_options = PeriodicWorkflowOptions.new({
        :execution_period_seconds => 10,
        :wait_for_activity_completion => false,
        :continue_as_new_after_seconds => 20,
        :complete_after_seconds => 40,
      })

      @continue_as_new_workflow_execution = @my_workflow_client.start_execution(running_options, @prefix_name, @activity_name, *@activity_args )

      sleep 5 until ["WorkflowExecutionContinuedAsNew", "WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @continue_as_new_workflow_execution.events.to_a.last.event_type
    end

      let(:events) { @continue_as_new_workflow_execution.events }
      let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }

    it "should continue as new" do
      events.to_a.last.event_type.should == "WorkflowExecutionContinuedAsNew"
    end

    it "should have 2 scheduled activities" do
      scheduled_activities.count.should == 2
    end

  end

  context "when workflow completes without starting a new workflow" do

    before(:all) do
      running_options = PeriodicWorkflowOptions.new({
        :execution_period_seconds => 10,
        :wait_for_activity_completion => false,
        :continue_as_new_after_seconds => 60,
        :complete_after_seconds => 60,
      })

      @completed_workflow_execution = @my_workflow_client.start_execution(running_options, @prefix_name, @activity_name, *@activity_args )

      sleep 5 until ["WorkflowExecutionContinuedAsNew", "WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @completed_workflow_execution.events.to_a.last.event_type
    end

      let(:events) { @completed_workflow_execution.events }
      let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }

    it "should complete without starting a new worklfow" do
      events.to_a.last.event_type.should == "WorkflowExecutionCompleted"
    end

    it "should have 6 scheduled activities" do
      scheduled_activities.count.should == 6
    end

  end

  context "when activity do_some_work throws an exception" do

    before(:all) do
      #redefine the activity to throw out an exception to test error reporting activity
      class PeriodicActivity
        alias_method :origin_do_some_work, :do_some_work
        def do_some_work(parameter)
          puts "raise an exception intentionally"
          raise RuntimeError, "an intentional exception"
        end
      end
      $forking_executor.shutdown(1) unless $forking_executor.is_shutdown
      sleep 15

      local_periodic_activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $periodic_activity_task_list, PeriodicActivity)
      local_error_reporting_activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $error_reporting_activity_task_list, ErrorReportingActivity)
      local_workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, PeriodicWorkflow)

      local_activity_name ="do_some_work"
      local_prefix_name ="PeriodicActivity"
      local_activity_args=["parameter1"]
      local_my_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "PeriodicWorkflow"} }

      @local_forking_executor = ForkingExecutor.new(:max_workers => 10)
      @local_forking_executor.execute { local_workflow_worker.start }
      @local_forking_executor.execute { local_periodic_activity_worker.start }
      @local_forking_executor.execute { local_error_reporting_activity_worker.start }

      # setting execution_period_seconds greater than complete_after_seconds on
      # purpose to stop execution after the first run itself
      running_options = PeriodicWorkflowOptions.new({
        :execution_period_seconds => 31,
        :wait_for_activity_completion => false,
        :continue_as_new_after_seconds => 30,
        :complete_after_seconds => 30,
      })


      @bre_workflow_execution = local_my_workflow_client.start_execution(running_options, local_prefix_name, local_activity_name, *local_activity_args)

      sleep 5 until ["WorkflowExecutionContinuedAsNew", "WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @bre_workflow_execution.events.to_a.last.event_type
    end

    let(:events) { @bre_workflow_execution.events }
    let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }
    let(:failed_activity_count) { events.map(&:event_type).count("ActivityTaskFailed") }

    it "should complete successfully or continue as new" do
      expected_states =["WorkflowExecutionCompleted", "WorkflowExecutionContinuedAsNew"]
      expected_states.should include events.to_a.last.event_type
    end

    it "should schedule report_failure activity after do_some_work activity" do
      expected_trace = [["PeriodicActivity.do_some_work", "ErrorReportingActivity.report_failure"]]
      expected_trace.should include scheduled_activities
    end

    it "should have one failed activity" do
      failed_activity_count.should == 1
    end

    after(:all) do
      class PeriodicActivity
        alias_method :do_some_work, :origin_do_some_work
      end
      @local_forking_executor.shutdown(1) unless @local_forking_executor.is_shutdown
    end

  end

  after(:all) do
    $forking_executor.shutdown(1) unless $forking_executor.is_shutdown
  end


end
