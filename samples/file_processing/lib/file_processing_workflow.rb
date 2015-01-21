require_relative '../file_processing_utils'
require_relative 's3_activity'
require_relative 'file_processing_activity'

# FileProcessingWorkflow class defines the workflows for the FileProcessing
# sample
class FileProcessingWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :process_file do
    {
      version: FileProcessingUtils::WF_VERSION,
      default_task_list: FileProcessingUtils::WF_TASKLIST,
      default_execution_start_to_close_timeout: 120
    }
  end

  def initialize
    @state = "Started"
  end

  attr_reader :state

  # This aws-flow method can be used to set the state method on the workflow.
  # The method that the get_state_method annotates can be used to fetch the
  # state of the workflow at any time during the execution. This 'state' is a
  # user defined state of the workflow.
  get_state_method(:state)

  # Create activity clients using the activity_client method to schedule
  # activities
  activity_client(:s3activity_client) { { from_class: "S3Activity" } }
  activity_client(:file_client) { { from_class: "FileProcessingActivity" } }

  # This is the entry point for the workflow
  def process_file(options)
    puts "Workflow has started" unless is_replaying?
    # Unique run id to name files (remove '/' so that naming works)
    workflow_run_id = run_id.delete('/')

    local_source = "#{workflow_run_id}_#{options[:source_filename]}"
    local_target = "#{workflow_run_id}_#{options[:target_filename]}"
    hostname = nil

    begin
      # Use the s3_activity_client to invoke the download activity to download
      # the file from S3. Use can specify a runtime option for this activity to
      # set the activity heartbeat timeout to the desired number of seconds. In
      # this example, we are setting it to 5 seconds for this invocation of the
      # download activity. If the activity doesn't heartbeat to the service
      # regularly, it will timeout indicating that there might be something
      # wrong with that activity worker.
      puts "Downloading file from S3" unless is_replaying?
      hostname = s3activity_client.download(
        options[:source_bucket], options[:source_filename], local_source) {
          { heartbeat_timeout: 5 }
      }

      # The download activity returns a hostname, i.e., the host where the
      # activity worker was running and hence downloaded the file to. This
      # hostname can be used as a tasklist for the process_file activity so
      # that only the workers that are running on that host will pick up that
      # task and hence be able to process the local file. This is a common
      # flow pattern to route host specific work

      @state = "Downloaded to #{hostname}"

      # Use the file_client to invoke the process_file activity to process the
      # file that was downloaded previously. This activity will zip the file.
      # Here we assign this activity to a specific tasklist, so that only the
      # workers polling on this tasklist will be able to pick up the task
      puts "Processing file" unless is_replaying?
      file_client.process_file(local_source, local_target) do
        { :task_list => hostname }
      end

      @state = "Processed at #{hostname}"

      # Use the s3activity_client to call the upload activity to upload the
      # zipped file to S3. As mentioned previously, the file was downloaded and
      # processed on a particular host. Now, we need to upload the processed
      # file from that host to S3. Once again, we assign this task to the
      # hostname tasklist so that only the workers working on that host will be
      # able to pick up the task
      puts "Uploading file to S3" unless is_replaying?
      s3activity_client.upload(options[:target_bucket], options[:target_filename],
                              local_target) { { task_list: hostname } }
    rescue Exception => e
      @state = "Failed:#{e.message}"
      raise e
    ensure
      # Use the s3activity_client to invoke the delete_local activity to cleanup
      # after ourselves. Once again, the task will be routed to a host specific
      # tasklist
      if ! hostname.nil?
        [local_source, local_target].each do |file|
          s3activity_client.delete_local(file) { { task_list: hostname } }
        end
      end

      if !@state.start_with?("Failed")
        @state = "Completed"
      end
    end
    puts "Workflow has completed" unless is_replaying?
  end

  # Helper method to check if Flow is replaying the workflow. This is used to
  # avoid duplicate log messages
  def is_replaying?
    decision_context.workflow_clock.replaying
  end

end

# Start a WorkflowWorker to work on the FileProcessingWorkflow tasks
FileProcessingUtils.new.workflow_worker.start if $0 == __FILE__
