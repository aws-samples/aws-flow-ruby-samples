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

require_relative '../periodic_utils'
require_relative 'periodic_workflow'
require_relative 'periodic_activity'
require_relative 'error_reporting_activity'

# Get a workflow client for PeriodicWorkflow and start a workflow execution with
# the required options
PeriodicUtils.new.workflow_client.start_execution(
  activity_name: :do_some_work,
  activity_prefix: "PeriodicActivity",
  execution_period_secs: 10,
  wait_for_completion: false,
  continue_as_new_secs: 20,
  completion_secs: 40
)
