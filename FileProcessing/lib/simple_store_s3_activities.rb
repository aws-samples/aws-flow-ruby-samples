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

require 'aws/s3'
require 'fileutils'
require_relative 'utils.rb'

class SimpleStoreS3Activities
  extend AWS::Flow::Activities

  activity :upload, :download, :delete_local_file do
    {
      :version => "1.0",
      :default_task_list => $activity_task_list,
      :default_task_schedule_to_start_timeout => 60,
      :default_task_start_to_close_timeout => 120
    }
  end

  HEARTBEAT_INTERVAL = 30.0

  def initialize(s3_client, local_dir, task_list)
    @s3_client = s3_client
    @local_dir = local_dir
    @task_list = task_list
    Dir.mkdir(@local_dir) unless File.exists?(@local_dir)
  end

  def upload(bucket_name, local_name, target_name)
    upload_file_to_s3(bucket_name, @local_dir  + local_name, target_name)
  end

  def download(bucket_name, remote_name, local_name)
    download_file_from_s3(bucket_name, remote_name, @local_dir + local_name)
    @task_list
  end

  def delete_local_file(filename)
    delete_local_files(@local_dir  + filename)
  end

  private
  def upload_file_to_s3(bucket_name, local_name, remote_name)
    puts "upload file to s3 begin remote_name=#{remote_name}, local_name=#{local_name}"
    obj = @s3_client.buckets[bucket_name].objects[remote_name]
    obj.write(Pathname.new(local_name))
    puts "upload file to s3 done"
  end

  def download_file_from_s3(bucket_name, remote_name, local_name)
    puts "download file from s3 starting remote_name=#{remote_name}, localName=#{local_name}"
    object = @s3_client.buckets[bucket_name].objects[remote_name]
    total_size = object.content_length

    total_read = 0
    last_heartbeat_time = Time.now
    File.open(local_name, 'wb') do |file|
      object.read do |chunk|
        file.write chunk
        total_read += chunk.bytesize
        progress = ((total_read.to_f / total_size.to_f)*100).to_i
        last_heartbeat_time = heartbeat(last_heartbeat_time, progress)
      end
    end
    puts "download file from S3 done"
  end

  def delete_local_files(filename)
    puts "delete local file activity starting filename=#{filename}"
    File.delete(filename)
    puts "delete local activity done"
  end

  def heartbeat(last_heartbeat_time, progress)
    if(Time.now - last_heartbeat_time > HEARTBEAT_INTERVAL)
      activity_execution_context.record_activity_heartbeat(progress.to_s)
    end
    Time.now
  end
end
