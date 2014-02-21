require 'aws/decider'
require_relative 'utils.rb'
require_relative 'deployment_workflow.rb'

include AWS::Flow

deployment_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "DeploymentWorkflow"} }

puts "starting an execution..."
configuration_file = "application_stack.yml"
workflow_execution = deployment_workflow_client.start_execution(configuration_file)


