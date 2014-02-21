require 'yaml'
require 'socket'
require_relative 'spec_helper'

describe FileProcessingWorkflow do

  before(:all) do
    #load config

    config = FileProcessingConfig.new(File.join(File.dirname(__FILE__), "file_processing_spec_config.yml"))

    #overwrite the s3 file before downloading it in the workflow execution
    source_obj = $s3.buckets[config.source_bucket_name].objects[config.source_filename]
    $message="Hello world\n"
    source_obj.write($message);

    #activity worker to poll the common task list
    hostname = Socket.gethostname
    activity_worker_common_task_list = ActivityWorker.new($swf.client, $domain, $activity_task_list)
    store_activity = SimpleStoreS3Activities.new($s3, config.local_folder, hostname) 
    activity_worker_common_task_list.add_implementation(store_activity)
    activity_worker_common_task_list.register

    #activity worker to poll the specific task list
    activity_worker_specific_task_list = ActivityWorker.new($swf.client, $domain, hostname)
    file_processing_activity = FileProcessingActivity.new(config.local_folder)
    activity_worker_specific_task_list.add_implementation(store_activity) 
    activity_worker_specific_task_list.add_implementation(file_processing_activity)
    activity_worker_specific_task_list.register

    workflow_worker = WorkflowWorker.new($swf.client, $domain, $workflow_task_list, FileProcessingWorkflow)
    workflow_worker.register

    my_workflow_client = workflow_client($swf.client, $domain){ {:from_class => "FileProcessingWorkflow"} } 

    $forking_executor = ForkingExecutor.new(:max_workers => 4)
    $forking_executor.execute { workflow_worker.start }
    $forking_executor.execute { activity_worker_common_task_list.start }
    $forking_executor.execute { activity_worker_specific_task_list.start }

    $workflow_execution = my_workflow_client.start_execution(config.source_bucket_name, config.source_filename, config.target_bucket_name, config.target_filename)

    sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? $workflow_execution.events.to_a.last.event_type

    workflow_run_id = $workflow_execution.run_id.delete('/')
    #download the zip that we uploaded in the workflow execution file from s3
    target_obj = $s3.buckets[config.target_bucket_name].objects[config.target_filename]
    @zip_file_path = config.local_folder + workflow_run_id +  ".zip"
    File.open(@zip_file_path, 'wb') do |file|
      target_obj.read do |chunk|
        file.write(chunk)
      end
    end

    #the zip file contains only one entry
    #retrieve the content in the zip entry
    zip_entry = "#{workflow_run_id}_#{config.source_filename}"
    Zip::ZipFile.open(@zip_file_path, Zip::ZipFile::CREATE) do |zipfile|
      $content = zipfile.read(zip_entry)
    end

  end

  describe "Workflow History" do

    let(:events) { $workflow_execution.events }
    let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }

    it "should complete successfully" do
      events.to_a.last.event_type.should == "WorkflowExecutionCompleted" 
    end

    it "should have 5 completed activities" do
      scheduled_activities.count.should == 5
    end


    it "should schedule activities in right order" do
      expected_trace = [["SimpleStoreS3Activities.download","FileProcessingActivity.process_file", 
                         "SimpleStoreS3Activities.upload", "SimpleStoreS3Activities.delete_local_file", 
                         "SimpleStoreS3Activities.delete_local_file"]]
      expected_trace.should include scheduled_activities
    end
  end

  describe "Zip file" do
    it "should contain the correct content" do
      $content.should == $message
    end
  end

  after(:all) do
    #delete zip file
    File.delete(@zip_file_path)
    $forking_executor.shutdown(1)
  end

end
