require_relative 'utils.rb'
require_relative "hello_world_activity.rb"

class HelloWorldWorkflow
  extend AWS::Flow::Workflows

  workflow :hello_workflow do
    {
      :version => "1.0",
      :execution_start_to_close_timeout => 3600,
      :task_list => $task_list
    }
  end

  activity_client(:activity) { {:from_class => "HelloWorldActivity"} }

  def hello_workflow(name)
    activity.hello_activity(name)
  end
end

worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $task_list, HelloWorldWorkflow)
# Start the worker if this file is called directly from the command line.
worker.start if __FILE__ == $0
