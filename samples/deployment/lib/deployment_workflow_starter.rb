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

require_relative '../deployment_utils'
require_relative 'deployment_workflow'
require_relative 'deployment_activity'

file = File.join(File.dirname(__FILE__), "application_stack.yml")
# Get the workflow client from BookingUtils and start a workflow execution with
# the required options
DeploymentUtils.new.workflow_client.start_execution(file)
