require 'parse-cron'
require_relative 'cron_with_retry_activity'
require_relative '../cron_with_retry_utils'

# CronWithRetryWorkflow class defines the workflows for the CronWithRetry sample
class CronWithRetryWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point. In this case
  # make_booking is the entry point
  workflow :run do
    {
      version: CronWithRetryUtils::WF_VERSION,
      default_task_list: CronWithRetryUtils::WF_TASKLIST,
      default_execution_start_to_close_timeout: 600,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:activity) { { from_class: "CronWithRetryActivity" } }

  # This is the workflow entry point. It determines the times at which to run
  # the job and then schedules them.
  # interval_length is defaulted to a prime number (601) to avoid overlapping
  # with periodicity of the job. 601 is the closest prime to 600 (which equals
  # 10 minutes)
  # @param (see #get_schedule_times)
  def run(job, base_time = Time.now, interval_length = 601)
    puts "Workflow has started" unless is_replaying?
    # Get a list of times at which the job needs to be scheduled
    times_to_schedule = get_schedule_times(job, base_time, interval_length)

    # Schedule all invocations of the job asynchronously. Pass in runtime
    # exponential retry options so that the activity gets retried in case of
    # failure.
    puts "Scheduling activity invocations" unless is_replaying?
    times_to_schedule.each do |time|
      async_create_timer(time) do
        activity.run_job(job[:func], *job[:args]) do
          {
            exponential_retry: {
              maximum_attempts: 2,
              exceptions_to_retry: [ArgumentError],
            }
          }
        end
      end
    end

    # Update base_time to move to the next interval of time
    base_time += times_to_schedule.last
    create_timer(times_to_schedule.last)

    # Call the continue_as_new method that is available to all Workflow classes
    # that extend AWS::Flow::Workflows so that this workflow will be called
    # again once complete (after the interval is over)
    puts "Workflow is continuing as new" unless is_replaying?
    continue_as_new(job, base_time, interval_length)
  end

  # This is a utility function that determines the schedule times for a cron job
  # that lie within the current interval and creates a list of those schedule
  # times
  #
  # @param job [Hash] information about the job that needs to be run. It
  #   contains a cron string, the function to call (in activity.rb), and the
  #   function call's arguments
  # @param base_time [Time] time to start the cron workflow
  # @param interval_length [Integer] how often to reset history (seconds)
  # @return [Array] list of times at which to invoke the job
  def get_schedule_times(job, base_time, interval_length)

    return [] if job.empty?
    # Generate a cron_parser for each job
    cron_parser = CronParser.new(job[:cron])

    # Store the times at which this job will be called within the given interval
    times_to_schedule = []
    next_time = cron_parser.next(base_time)
    while(base_time <= next_time and next_time < base_time + interval_length) do
      times_to_schedule.push((next_time - base_time).to_i)
      next_time = cron_parser.next(next_time)
    end

    # Checks if the interval_length is less than the periodicity of the task
    if times_to_schedule.empty?
      raise ArgumentError, "interval length should be longer than periodicity"
    end

    # Return the list of times at which the job needs to be scheduled
    times_to_schedule
  end

  # Helper method to check if Flow is replaying the workflow. This is used to
  # avoid duplicate log messages
  def is_replaying?
    decision_context.workflow_clock.replaying
  end

end

# Start a WorkflowWorker to work on the CronWithRetryWorkflow tasks
CronWithRetryUtils.new.workflow_worker.start if $0 == __FILE__
