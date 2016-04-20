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
