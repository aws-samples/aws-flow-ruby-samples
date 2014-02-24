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

require_relative 'utils.rb'
require_relative 'simple_store_s3_activities.rb'
require_relative 'file_processing_activity.rb'

class FileProcessingWorkflow
  extend AWS::Flow::Workflows

  workflow :process_file do 
    {
      :version => "1.0",
      :task_list => $workflow_task_list,
      :execution_start_to_close_timeout => 120
    }
  end

  def initialize
    @state = "started"
  end

  attr_reader :state
  get_state_method(:state)

  # Create client for each activity we plan to use in workflow
  activity_client(:store) { {:from_class => "SimpleStoreS3Activities"} }
  activity_client(:file_processing_activity) { {:from_class => "FileProcessingActivity"} }

  def process_file(
    source_bucket_name, source_filename, target_bucket_name, target_filename)
    # Unique run id to name files (remove '/' so that naming works)
    workflow_run_id = run_id.delete('/')

    local_source_filename = "#{workflow_run_id}_#{source_filename}"
    local_target_filename = "#{workflow_run_id}_#{target_filename}"
    activity_worker_task_list = nil

    begin
      # Download File from S3
      activity_worker_task_list = store.download(
        source_bucket_name, source_filename, local_source_filename)
      @state = "Downloaded to #{activity_worker_task_list}"
      # Zip the File
      file_processing_activity.process_file(local_source_filename, local_target_filename){
        { :task_list => activity_worker_task_list } }

      @state = "Processed at #{activity_worker_task_list}"

      # Upload zipped file to S3
      store.upload(target_bucket_name, local_target_filename, target_filename) {
        { :task_list => activity_worker_task_list } }
    rescue Exception => e
      @state = "Failed:#{e.message}"
      raise e
    ensure
      # Delete local files
      if ! activity_worker_task_list.nil?
        [local_source_filename, local_target_filename].each do |file|
          store.delete_local_file(file) { { :task_list => activity_worker_task_list } }
        end
      end

      if !@state.start_with?("Failed")
        @state = "Completed"
      end
    end
  end
end

workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, FileProcessingWorkflow)
workflow_worker.start if __FILE__ == $0
