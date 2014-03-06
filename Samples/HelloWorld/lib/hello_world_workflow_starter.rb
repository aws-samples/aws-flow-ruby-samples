#
# Hello World, for the AWS Flow Framework for Ruby
#
require_relative 'utils.rb'
require_relative 'hello_world_workflow.rb'

# Get a workflow client to start the workflow
my_workflow_client = AWS::Flow.workflow_client(
  $swf.client, $domain) { {:from_class => "HelloWorldWorkflow"} }

puts "Starting an execution..."
workflow_execution = my_workflow_client.start_execution(
  "AWS Flow Framework for Ruby")
