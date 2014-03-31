require_relative '../helloworld_utils'
require_relative 'helloworld_workflow'
require_relative 'helloworld_activity'

# Get a workflow client for HelloWorldWorkflow and start a workflow execution
# with the required options
HelloWorldUtils.new.workflow_client.start_execution("AWS Flow Framework")
