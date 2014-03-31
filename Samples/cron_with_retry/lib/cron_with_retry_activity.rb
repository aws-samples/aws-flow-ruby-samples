require_relative '../cron_with_retry_utils'

# CronWithRetryActivity class defines a set of activities for the CronWithRetry
# sample.
class CronWithRetryActivity
  extend AWS::Flow::Activities

  # The activity method is used to define activities. It accepts a list of names
  # of activities and a block specifying registration options for those
  # activities
  activity :run_job, :unreliable_add do
    {
      default_task_list: CronWithRetryUtils::ACTIVITY_TASKLIST,
      version: CronWithRetryUtils::ACTIVITY_VERSION,
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
    }
  end

  # This activity takes in a function to call and executes it
  # @param func [lambda] function that will get called by the activity
  # @return [void] returns whatever the function call returns
  def run_job(func, *args)
    puts "Running a job"
      if self.method(func).arity > 1
      self.send(func, *args)
    else
      self.send(func, args)
    end
  end

  # This activity adds 2 numbers but fails 20 percent of the times to add
  # unreliability
  def unreliable_add(a,b)
    puts "Unreliable add"
    # this is to let the activity fail 20 percent of the times
    raise ArgumentError, "simulating failure for retry" if Random.rand(5) == 1
    a + b
  end

end

# Start an ActivityWorker to work on the CronActivity tasks
CronWithRetryUtils.new.activity_worker.start if __FILE__ == $0
