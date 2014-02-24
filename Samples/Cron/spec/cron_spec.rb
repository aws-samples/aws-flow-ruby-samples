require_relative 'spec_helper'
### Testing get_schedule_times ###

describe CronWorkflow, '#get_schedule_times' do  
  it 'returns all times at which the job will be run within a given interval' do
    job = { :cron => '* * * * *' }
    base_time = Time.new(2012, 10, 31, 2, 0, 0)
    interval_length = 601
    times = CronWorkflow.new.get_schedule_times(job, base_time, interval_length)
    times.size.should == 10
    times.each_cons(2) { |a| a.reduce(:-).should == -60 }
  end
  
  it 'returns an empty list when no job is given' do
    job = {}
    base_time = Time.new(2012, 10, 31, 2, 0, 0)
    interval_length = 601
    times = CronWorkflow.new.get_schedule_times(job, base_time, interval_length)
    times.empty?.should == true
  end
  
  it 'raises an exception when interval length is smaller than the periodicity' do
    job = { :cron => '*/5 * * * *'}
    base_time = Time.new(2012, 10, 31, 2, 0, 0)
    interval_length = 1
    expect { CronWorkflow.new.get_schedule_times(job, base_time, interval_length) }.to raise_error(ArgumentError, "interval length needs to be longer than the periodicity")
  end
 
end

### Done testing get_schedule_times ###

### Testing CronWorkflow class ###

# Function to execute workflows for each test
#
# @param (see #get_schedule_times in lib/workflow.rb)
def run_workflow(job, base_time, interval_length)
  $results = []
  $order = []
  my_workflow_client = CronWorkflow.new
  async_scope =
    AsyncScope.new() { my_workflow_client.run(job, base_time, interval_length) }
  async_scope.eventLoop
end

# Saves results of activity calls to check against expected behavior
#
# @param method_name [Symbol] name of method called
# @param *args [Array] list of args called with that method
# @param &func [function] method called
def log_results(method_name, args)
  raise "Not supported" if method_name != :run_job
  method, *func_parameters = args
  return_val = if self.method(method).arity > 1
                 self.send(method, *func_parameters)
               else
                 self.send(method, func_parameters)
               end
  $order << method_name
  $results << return_val
end

# @note factor by which delays will be reduced (to speed up testing)
$speed_up_factor = 60

describe CronWorkflow, '#run' do
  before(:all) do
    
    # Activity client that will be used solely to log behavior for testing
    class FakeActivityClient
      
      # Called if method called with an instance of this class does not exist
      #
      # @param (see #log_results)
      def method_missing(method_name, *args, &func)
        log_results(method_name, args)
      end

      # Adds two variables, used for testing
      def add(a,b)
        a + b
      end
    end
    
    class CronWorkflow
      
      # Redefining async_create_timer (removing library dependency)
      
      alias_method :orig_async_create_timer, :async_create_timer
      
      # Runs a function asynchronously after a certain amount of time
      #
      # @param timer [Integer] number of seconds to wait before call
      # @param block [function] function to be called after wait
      def async_create_timer(timer, &block)
        task do
          sleep (timer / $speed_up_factor)
          block.call if block
        end
      end
      
      # Redefining create_timer (removing library dependency)
      
      alias_method :orig_create_timer, :create_timer
      
      # Waits a certain amount of time before continuing the program
      #
      # @param timer [Integer] number of seconds to wait
      def create_timer(timer)
        sleep (timer / $speed_up_factor)
      end
      
      alias :orig_activity :activity
      
      # Initalize a new FakeActivityClient and returns that so the workflow
      #   call logs results instead of running them like a normal activity
      #
      # @return [FakeActivityClient] instance of client for use in testing
      def activity
        FakeActivityClient.new
      end
      
      # Not setting the continue_as_new flag, for sake of testing
      #
      # @param *args [Array] parameters ignored
      def continue_as_new(*args)
        # NOOP
      end
      
    end
  end
  
  after(:all) do
    # Reset methods back to original definitions
    class CronWorkflow
      alias_method :async_create_timer, :orig_async_create_timer
      alias_method :create_timer, :orig_create_timer
      alias :activity :orig_activity
    end
  end
  
   it 'schedules a single repeating job properly' do
     job = { :cron => "*/1 * * * *", :func => :add, :args => [401,-1] }
     base_time = Time.new(2012, 10, 31, 2, 0, 0)
     interval_length = 601
     run_workflow(job,base_time,interval_length)
     
     $order.should == [:run_job] * 10 and
       $results.count { |x| x == 400 }.should == 10
   end
 
   it 'checks that the interval is exclusive with regards to the upper bound' do
     job = { :cron => "0-30 * * * *", :func => :add, :args => ["This is ", "a test."] }
     base_time = Time.new(2012, 10, 30, 2, 0, 0)
     interval_length = 120
     run_workflow(job, base_time, interval_length)
     
     $order.should == [:run_job] and
       $results.count { |x| x == "This is a test." }.should == 1
   end
  
end


describe CronWorkflow, '#run' do
  before(:all) do
   
    class CronWorkflow
      def continue_as_new(*args)
        # NOOP
      end
    end

  end   
  
  it 'checks that a workflow is executed and terminates' do
    job = { :cron => "*/1 * * * *", :func => :add, :args => [1,2] }
    expected_result = 3
    base_time = Time.new(2010,10,31,1,59,55)
    interval_length = 7

    # make workflow client
    my_workflow_client = workflow_client($swf.client, $domain) { { :from_class => "CronWorkflow" } }

    # make workflow and activity workers
    worker = WorkflowWorker.new($swf.client, $domain, $workflow_task_list, CronWorkflow)
    worker.register

    activity_worker = ActivityWorker.new($swf.client, $domain, $activity_task_list, CronActivity)
    activity_worker.register
      
    # start the actual process
    puts "Starting an execution..."
    workflow_execution = my_workflow_client.run(job, base_time, interval_length)

    # have workers pick up tasks
    worker.run_once
    worker.run_once
    activity_worker.run_once
    worker.run_once
    worker.run_once
    
    # make sure that the results returned by the completed activities match the
    # expected results
    results = workflow_execution.events.to_a.select {
      |e| e.event_type == "ActivityTaskCompleted" }.map {
        |e| e.attributes.result }
    check_result = results.select {|x| x =~ /#{expected_result}/}.empty?
  
    workflow_execution.events.map(&:event_type).last.should ==
      "WorkflowExecutionCompleted" and check_result.should == false
  end
end 
