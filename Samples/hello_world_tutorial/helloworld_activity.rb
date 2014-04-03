require_relative 'helloworld_utils'

# Defines a set of activities for the HelloWorld sample.
class HelloWorldActivity
  extend AWS::Flow::Activities

  # define an activity with the #activity method.
  activity :say_hello do
    {
      version: HelloWorldUtils::ACTIVITY_VERSION,
      default_task_list: HelloWorldUtils::ACTIVITY_TASKLIST,
      # timeout values are in seconds.
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30
    }
  end

  # This activity will say hello when invoked by the workflow
  def say_hello(name)
    puts "Hello, #{name}!"
  end
end

# Start an ActivityWorker to work on the HelloWorldActivity tasks
HelloWorldUtils.new.activity_worker(HelloWorldActivity).start if $0 == __FILE__
