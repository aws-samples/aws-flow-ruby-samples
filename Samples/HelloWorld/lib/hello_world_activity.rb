require_relative 'utils.rb'

class HelloWorldActivity
  extend AWS::Flow::Activities

  activity :hello_activity do
    {
      :version => "1.0",
      :default_task_list => $task_list,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30
    }
  end

  def hello_activity(name)
    puts "Hello, #{name}!"
  end
end

activity_worker = AWS::Flow::ActivityWorker.new(
  $swf.client, $domain, $task_list, HelloWorldActivity)

# Start the worker if this file is called directly from the command line.
activity_worker.start if __FILE__ == $0
