require_relative 'spec_helper'

describe CronWithRetryWorkflow do

  describe "#get_schedule_times" do
    describe CronWithRetryWorkflow, '#get_schedule_times' do  
      it 'returns all times at which the job will be run within a given interval' do
        job = { :cron => '* * * * *' }
        base_time = Time.new(2012, 10, 31, 2, 0, 0)
        interval_length = 601
        times = CronWithRetryWorkflow.new.get_schedule_times(job, base_time, interval_length)
        times.size.should == 10
        times.each_cons(2) { |a| a.reduce(:-).should == -60 }
      end

      it 'returns an empty list when no job is given' do
        job = {}
        base_time = Time.new(2012, 10, 31, 2, 0, 0)
        interval_length = 601
        times = CronWithRetryWorkflow.new.get_schedule_times(job, base_time, interval_length)
        times.empty?.should == true
      end

      it 'raises an exception when interval length is smaller than the periodicity' do
        job = { :cron => '*/5 * * * *'}
        base_time = Time.new(2012, 10, 31, 2, 0, 0)
        interval_length = 1
        expect { CronWithRetryWorkflow.new.get_schedule_times(job, base_time, interval_length) }.to raise_error(ArgumentError, "interval length needs to be longer than the periodicity")
      end

    end

  end
  describe "Workflow Execution" do

    before(:all) do
      $speed_up_factor = 10
      @job = { :cron => "* * * * *",  :func => :unreliable_add, :args => [3,4]}
      @base_time = Time.now
      @interval_length = 130

      class CronWithRetryWorkflow
        alias_method :original_continue_as_new, :continue_as_new
        def continue_as_new(*args)
          # NOOP
        end

        alias_method :original_get_schedule_times, :get_schedule_times
        def get_schedule_times(job, base_time, interval_length)
          times_to_schedule = original_get_schedule_times(job, base_time, interval_length)
          times_to_schedule.collect { |x| x/$speed_up_factor }
        end
      end

    end

    after(:all) do
      class CronWithRetryWorkflow
        alias_method :continue_as_new, :original_continue_as_new
        alias_method :get_schedule_times, :original_get_schedule_times
      end
    end

    context "when activity is unreliable" do

      before(:all) do

        class CronWithRetryActivity
          # the activity always fails
          def unreliable_add(a,b)
            raise ArgumentError, "simulating failure to get cron to retry"
          end
        end

        activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $activity_task_list, CronWithRetryActivity)
        workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, CronWithRetryWorkflow)
        activity_worker.register
        workflow_worker.register
        @my_workflow_client = workflow_client($swf.client, $domain) { { :from_class => "CronWithRetryWorkflow" }}

        @forking_executor = ForkingExecutor.new(:max_workers => 3)
        @forking_executor.execute { workflow_worker.start }
        @forking_executor.execute { activity_worker.start }

        @workflow_execution = @my_workflow_client.run(@job, @base_time, @interval_length)

        sleep 5 until ["WorkflowExecutionContinuedAsNew", "WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @workflow_execution.events.to_a.last.event_type
      end

      let(:events) { @workflow_execution.events }
      let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }

      it "should fail" do
        events.to_a.last.event_type.should == "WorkflowExecutionFailed"
      end

      it "should have more than 2 scheduled activities" do
        scheduled_activities.count.should > 2
      end

      after(:all) do
        @forking_executor.shutdown(1)
      end
    end

    context "when activity is reliable" do

      before(:all) do

        class CronWithRetryActivity
          # the activity never fails
          def unreliable_add(a,b)
            a + b
          end
        end

        activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $activity_task_list, CronWithRetryActivity)
        workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, CronWithRetryWorkflow)
        activity_worker.register
        workflow_worker.register
        @my_workflow_client = workflow_client($swf.client, $domain) { { :from_class => "CronWithRetryWorkflow" }}

        @forking_executor = ForkingExecutor.new(:max_workers => 3)
        @forking_executor.execute { workflow_worker.start }
        @forking_executor.execute { activity_worker.start }

        @workflow_execution = @my_workflow_client.run(@job, @base_time, @interval_length)

        sleep 5 until ["WorkflowExecutionContinuedAsNew", "WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @workflow_execution.events.to_a.last.event_type
      end

      let(:events) { @workflow_execution.events }

      it "should complete without starting a new worklfow" do
        events.to_a.last.event_type.should == "WorkflowExecutionCompleted"
      end

      after(:all) do
        @forking_executor.shutdown(1) 
      end
    end
  end
end
