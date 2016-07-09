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

require 'flow/activities'

# BookingWorkflow class defines the workflows for the Booking sample
class BookingWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :make_booking do
    {
      version: "1.0",
      default_execution_start_to_close_timeout: 120
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "BookingActivity" } }

  # This is the entry point for the workflow
  def make_booking options

    puts "Workflow has started\n" unless is_replaying?
    
    puts "Waiting 1 seconds\n" unless is_replaying?
    create_timer(1)
    puts "Done waiting 1 seconds.\n" unless is_replaying?
    
    # This array will hold all futures that are created when asynchronous
    # activities are scheduled
    futures = []

    if options[:reserve_car]
      puts "Reserving a car for customer\n" unless is_replaying?
      # The activity client can be used to schedule activities
      # asynchronously by using the send_async method
      futures << client.send_async(:reserve_car, options[:request_id])
    end
    if options[:reserve_air]
      puts "Reserving air ticket\n" unless is_replaying?
      futures << client.send_async(:reserve_air, options[:customer_id])
    end

    puts "Waiting for reservation to complete\n" unless is_replaying?
    # wait_for_all is a flow construct that will wait on the array of
    # futures passed to it
    wait_for_all(futures)

    # After waiting on the reservation activities to complete, the workflow
    # will call the send_confirmation activity.
    client.send_confirmation(options[:customer_id])

    method_with_create_timer_and_activity_calls(options[:customer_id])

    puts "Workflow has completed\n" unless is_replaying?
  end
  
  def method_with_create_timer_and_activity_calls echo_me
    puts "Inside of method with a create_timer call and an activity call." unless is_replaying?
    puts "Waiting 3 seconds.\n" unless is_replaying?
    create_timer(3)
    client.echo(echo_me)
  end

  # Helper method to check if Flow is replaying the workflow. This is used to
  # avoid duplicate log messages
  def is_replaying?
    decision_context.workflow_clock.replaying
  end
end
