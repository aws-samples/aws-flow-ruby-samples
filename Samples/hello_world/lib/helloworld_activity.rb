require_relative '../helloworld_utils.rb'

# HelloWorldActivity class defines a set of activities for the HelloWorld sample.
class HelloWorldActivity
  extend AWS::Flow::Activities

  # The activity method is used to define activities. It accepts a list of names
  # of activities and a block specifying registration options for those
  # activities
  activity :say_hello do
    {
      version: HelloWorldUtils::ACTIVITY_VERSION,
      default_task_list: HelloWorldUtils::ACTIVITY_TASKLIST,
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
HelloWorldUtils.new.activity_worker.start if $0 == __FILE__
