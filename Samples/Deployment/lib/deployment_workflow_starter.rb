require_relative '../deployment_utils'
require_relative 'deployment_workflow'
require_relative 'deployment_activity'

file = File.join(File.dirname(__FILE__), "application_stack.yml")
# Get the workflow client from BookingUtils and start a workflow execution with
# the required options
DeploymentUtils.new.workflow_client.start_execution(file)
