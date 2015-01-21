require_relative '../cron_utils'

# CronActivity class defines a set of activities for the Cron sample.
class CronActivity
  extend AWS::Flow::Activities

  # The activity method is used to define activities. It accepts a list of names
  # of activities and a block specifying registration options for those
  # activities
  activity :run_job, :add, :sum do
    {
      default_task_list: CronUtils::ACTIVITY_TASKLIST,
      version: CronUtils::ACTIVITY_VERSION,
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

  # This activity adds two numbers
  def add(a,b)
    puts "Adding two numbers"
    a + b
  end

end

# Start an ActivityWorker to work on the CronActivity tasks
CronUtils.new.activity_worker.start if __FILE__ == $0
