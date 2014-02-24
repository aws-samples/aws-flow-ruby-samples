require 'aws/decider'
require_relative 'utils.rb'
require_relative 'periodic_workflow.rb'

include AWS::Flow

my_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "PeriodicWorkflow"} }

puts "starting an execution..."
running_options = PeriodicWorkflowOptions.new({
  :execution_period_seconds => 10,
  :wait_for_activity_completion => false,
  :continue_as_new_after_seconds => 20,
  :complete_after_seconds => 40,
})
activity_name ="do_some_work"
prefix_name ="PeriodicActivity"
activity_args=["parameter1"]

$workflow_execution = my_workflow_client.start_execution(
  running_options, prefix_name, activity_name, *activity_args)
