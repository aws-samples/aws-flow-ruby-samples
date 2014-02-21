require_relative 'utils.rb'
require_relative 'cron_activity.rb'
require_relative 'parser.rb'

class CronWorkflow
  extend AWS::Flow::Workflows

  # workflow options
  workflow :run do
    {
      :version => "1.0",
      :execution_start_to_close_timeout => 3600,
      :task_list => $workflow_task_list
    }
  end

  # activity client declaration
  activity_client(:activity) { { :from_class => "CronActivity" } }

  # Determines the schedule times for the job that lie within the current interval and creates a list of
  #   those for scheduling by the worker_client
  #
  # @param job [Hash] information about the job that needs to be run. It
  #   contains a cron string, the function to call (in activity.rb), and the function
  #   call's arguments
  # @param base_time [Time] time to start the cron workflow
  # @param interval_length [Integer] how often to reset history (seconds)
  # @return [Array] list of times at which to invoke the job
  def get_schedule_times(job, base_time, interval_length)

    return [] if job.empty?
    # generate a cron_parser for each job
    cron_parser = CronParser.new(job[:cron])

    # store the times at which this job will be called within the given interval
    times_to_schedule = []
    next_time = cron_parser.next(base_time)
    while(base_time <= next_time and next_time < base_time + interval_length) do
      times_to_schedule.push((next_time - base_time).to_i)
      next_time = cron_parser.next(next_time)
    end

    # checks if the interval_length is less than the periodicity of the task
    raise ArgumentError, "interval length needs to be longer than the periodicity" if times_to_schedule.empty? 
    
    # return the list of times at which the job needs to be scheduled
    times_to_schedule
  end

  # Main method in the workflow, determines the times at which to run the job and then schedules them.
  # interval_length is defaulted to a prime number (601) to avoid overlapping with periodicity of the job
  # 601 is the closest prime to 600 (which equals 10 minutes)
  # @param (see #get_schedule_times)
  def run(job, base_time = Time.now, interval_length = 601)

    # get a list of times at which the job needs to be scheduled
    times_to_schedule = get_schedule_times(job, base_time, interval_length)

    # schedule all invocations of the job asynchronously
    times_to_schedule.each do |time|
      async_create_timer(time) do
        activity.run_job(job[:func], *job[:args])
      end
    end

    # update base_time to move to the next interval of time
    base_time += times_to_schedule.last
    create_timer(times_to_schedule.last)

    # sets flag so that this workflow will be called again once complete (after
    #   the interval is over)
    #
    # @param (see #get_schedule_times)
    continue_as_new(job, base_time, interval_length) do |options|
      options.execution_start_to_close_timeout = 3600
      options.task_list = $task_list
      options.tag_list = []
      options.version = "1"
    end
  end

end

worker = AWS::Flow::WorkflowWorker.new(@swf.client, @domain, $workflow_task_list, CronWorkflow)
# Start the worker if this file is called directly from the command
# line, to prevent it from being run if it's required in
worker.start if __FILE__ == $0
