##
# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#  http://aws.amazon.com/apache2.0
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.
##

require 'aws/decider'

$RUBYFLOW_DECIDER_DOMAIN = "FileProcessing"
config_file = File.open('credentials.cfg') {|f| f.read}
AWS.config(YAML.load(config_file))

@s3 = AWS::S3.new
@swf = AWS::SimpleWorkflow.new

begin
  @domain = @swf.domains.create($RUBYFLOW_DECIDER_DOMAIN, "10")
rescue AWS::SimpleWorkflow::Errors::DomainAlreadyExistsFault => e
  @domain = @swf.domains[$RUBYFLOW_DECIDER_DOMAIN]
end

$swf, $domain, $s3 = @swf, @domain, @s3 #globalize them for use in tests

$workflow_task_list = "file_processing_workflow_task_list"
$activity_task_list = "file_processing_activity_task_list"

