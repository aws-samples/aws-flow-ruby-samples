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

require_relative '../file_processing_utils'
require_relative 'file_processing_workflow'

# Get a workflow client for FileProcessingWorkflow and start a workflow
# execution with the required options
FileProcessingUtils.new.workflow_client.start_execution(
  source_bucket: FileProcessingUtils::SOURCE_BUCKET,
  source_filename: FileProcessingUtils::SOURCE_FILENAME,
  target_bucket: FileProcessingUtils::TARGET_BUCKET,
  target_filename: FileProcessingUtils::TARGET_FILENAME
)
