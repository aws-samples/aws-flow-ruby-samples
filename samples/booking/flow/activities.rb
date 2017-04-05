# Copyright 2014-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

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
  # This activity is used to echo
  def echo(input)
    puts "Echoing #{input}\n"
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
