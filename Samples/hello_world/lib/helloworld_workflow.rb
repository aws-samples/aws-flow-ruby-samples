require_relative '../helloworld_utils'
require_relative "helloworld_activity"

# HelloWorldWorkflow class defines the workflows for the HelloWorld sample
class HelloWorldWorkflow
  extend AWS::Flow::Workflows

  workflow :hello do
    {
      version: HelloWorldUtils::WF_VERSION,
      default_task_list: HelloWorldUtils::WF_TASKLIST,
      default_execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "HelloWorldActivity" } }

  # This is the entry point for the workflow
  def hello(name)
    # Use the activity client 'client' to invoke the say_hello activity
    client.say_hello(name)
  end
end

# Start a WorkflowWorker to work on the HelloWorldWorkflow tasks
HelloWorldUtils.new.workflow_worker.start if $0 == __FILE__
