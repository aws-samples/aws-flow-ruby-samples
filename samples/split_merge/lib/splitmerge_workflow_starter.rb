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

require_relative '../splitmerge_utils'
require_relative 'splitmerge_workflow'
require_relative 'splitmerge_activity'

# Get a workflow client for SplitMergeWorkflow and start a workflow execution
# with the required options
SplitMergeUtils.new.workflow_client.start_execution(
  bucket: SplitMergeUtils::BUCKET,
  filename: SplitMergeUtils::FILENAME,
  fleet_size: SplitMergeUtils::FLEET_SIZE
)
