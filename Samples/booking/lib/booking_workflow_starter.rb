require_relative '../booking_utils'
require_relative 'booking_activity'
require_relative 'booking_workflow'

# Get a workflow client for BookingWorkflow and start a workflow execution with
# the required options
BookingUtils.new.workflow_client.start_execution(
  request_id: "1234567890",
  customer_id: "1234567890",
  reserve_car: true,
  reserve_air: true
)
