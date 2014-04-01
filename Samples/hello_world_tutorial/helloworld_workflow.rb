require_relative 'helloworld_utils'
require_relative 'helloworld_activity'

class HelloWorldWorkflow
  extend AWS::Flow::Workflows

  workflow :hello do
    {
      version: HelloWorldUtils::WF_VERSION,
      task_list: HelloWorldUtils::WF_TASKLIST,
      execution_start_to_close_timeout: 3600,
    }
  end

  activity_client(:client) { {:from_class => "HelloWorldActivity"} }

  def hello(name)
    client.say_hello(name)
  end
end

HelloWorldUtils.new.workflow_worker.start if $0 == __FILE__
