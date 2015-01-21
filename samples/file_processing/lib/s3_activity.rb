require 'aws/s3'
require 'fileutils'
require_relative '../file_processing_utils'

# S3Activity class defines a set of activities for the
# FileProcessing sample.
class S3Activity
  extend AWS::Flow::Activities

  # The activity method is used to define activities. It accepts a list of names
  # of activities and a block specifying registration options for those
  # activities
  activity :upload, :download, :delete_local do
    {
      version: FileProcessingUtils::S3_ACTIVITY_VERSION,
      default_task_list: FileProcessingUtils::ACTIVITY_TASKLIST,
      default_task_schedule_to_start_timeout: 60,
      default_task_start_to_close_timeout: 120
    }
  end

  HEARTBEAT_INTERVAL = 30.0

  def initialize(local_dir, tasklist)
    @s3 = AWS::S3.new
    @local_dir = local_dir
    @tasklist = tasklist
    Dir.mkdir(@local_dir) unless File.exists?(@local_dir)
  end

  # This activity is used to upload a file to s3.
  def upload(bucket, remote_name, local_name)
    puts "Upload activity"
    obj = @s3.buckets[bucket].objects[remote_name]
    obj.write(Pathname.new(@local_dir + local_name))
  end

  # This activity is used to download a file from s3. It also showcases how
  # activities can hearbeat to indicate that they are still alive
  def download(bucket, remote_name, local_name)
    puts "Download activity"

    # Get the file object from the S3 bucket
    object = @s3.buckets[bucket].objects[remote_name]
    total_size = object.content_length

    total_read = 0
    last_heartbeat_time = Time.now
    # This following section is purposely complex. It is done to show how long
    # running activities can heartebeat to the workflow to show that they are
    # still alive. Note the heartbeat method.
    File.open(@local_dir + local_name, 'wb') do |file|
      object.read do |chunk|
        file.write chunk
        total_read += chunk.bytesize
        progress = ((total_read.to_f / total_size.to_f)*100).to_i
        last_heartbeat_time = heartbeat(last_heartbeat_time, progress)
      end
    end

    @tasklist
  end

  # This activity is used to delete a local file
  def delete_local(filename)
    puts "Deleting localfile: #{@local_dir + filename}"
    File.delete(@local_dir + filename)
  end

  # This method shows how to heartbeat to SimpleWorkflow to indicate that the
  # activity worker is still alive and working on the task
  def heartbeat(last_heartbeat_time, progress)
    if(Time.now - last_heartbeat_time > HEARTBEAT_INTERVAL)
      # Use the record_activity_heartbeat method in the
      # activity_execution_context to record a heartbeat.
      # activity_execution_context is available to Activity classes that extend
      # AWS::Flow::Activities
      activity_execution_context.record_activity_heartbeat(progress.to_s)
    end
    Time.now
  end
end
