require_relative 'helloworld_utils'
require_relative 'helloworld_workflow'
require_relative 'helloworld_activity'

HelloWorldUtils.new.workflow_client(HelloWorldWorkflow).start_execution("AWS Flow Framework")
