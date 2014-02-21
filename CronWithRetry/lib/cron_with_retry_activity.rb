require_relative 'utils.rb'

class CronWithRetryActivity
  extend AWS::Flow::Activities

  # activity options
  activity :run_job, :unreliable_add, :sum do
    {
      :default_task_list => $activity_task_list,
      :version => "1.0",
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end
  
  # Takes in a function to call and executes it
  # @param func [lambda] function that will get called by the activity
  # @return [void] returns whatever the function call returns
  def run_job(func, *args)
      if self.method(func).arity > 1
      self.send(func, *args)
    else
      self.send(func, args)
    end
  end

  # add your functions here
  
  # Adds 2 numbers but fails 20 percent of the times to add unreliability
  def unreliable_add(a,b)
    # this is to let the activity fail 20 percent of the times
    raise ArgumentError, "simulating failure to get cron to retry" if Random.rand(5) == 1
    a + b
  end

end

activity_worker = AWS::Flow::ActivityWorker.new(@swf.client, @domain, $activity_task_list, CronWithRetryActivity)

# Start the worker if this file is called directly from the command
# line, to prevent it from being run if it's required in
activity_worker.start if __FILE__ == $0
