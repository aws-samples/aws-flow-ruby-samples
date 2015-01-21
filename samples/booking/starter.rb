require 'aws/decider'

input = {
  request_id: "1234567890",
  customer_id: "1234567890",
  reserve_car: true,
  reserve_air: true
}

opts = {
  domain: "Booking",
  version: "1.0"
}

AWS::Flow::start_workflow("BookingWorkflow.make_booking", input, opts)
