require 'aws/decider'
require_relative 'utils.rb'
require_relative 'booking_workflow.rb'

include AWS::Flow

my_workflow_client = workflow_client( $swf.client, $domain) { {:from_class => "BookingWorkflow"} }

requestId = "111222333"
customerId = "123456789"
$workflow_execution = my_workflow_client.start_execution(requestId, customerId, true, true)


