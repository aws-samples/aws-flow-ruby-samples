# BookingActivity class defines a set of activities for the Booking sample.
class BookingActivity
  extend AWS::Flow::Activities

  # The activity method is used to define activities. It accepts a list of names
  # of activities and a block specifying registration options for those
  # activities
  activity :reserve_car, :reserve_air, :send_confirmation do
    {
      version: "1.0",
    }
  end

  # This activity can be used to reserve a car for a given request_id
  def reserve_car(request_id)
    puts "Reserving car for Request ID: #{request_id}\n"
  end

  # This activity can be used to reserve a flight for a given request_id
  def reserve_air(request_id)
    puts "Reserving airline for Request ID: #{request_id}\n"
  end

  # This activity can be used to send a booking confirmation to the customer
  def send_confirmation(customer_id)
    puts "Sending notification to customer: #{customer_id}\n"
  end
end
