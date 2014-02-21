require 'socket'
require 'aws/decider'

require_relative 'utils'
require_relative 'file_processing_config'
require_relative 'simple_store_s3_activities'
require_relative 'file_processing_activity'

hostname = Socket.gethostname
config = FileProcessingConfig.new(File.join(File.dirname(__FILE__), "file_processing_config.yml"))

#activity worker to poll the common task list
worker_for_common_task_list = AWS::Flow::ActivityWorker.new($swf.client, $domain, $activity_task_list)
store_activity = SimpleStoreS3Activities.new($s3, config.local_folder, hostname)
worker_for_common_task_list.add_implementation(store_activity)

#activity worker to poll the specific task list
worker_for_host_specific_task_list = AWS::Flow::ActivityWorker.new($swf.client, $domain, hostname)
file_processing_activity = FileProcessingActivity.new(config.local_folder)
worker_for_host_specific_task_list.add_implementation(store_activity)
worker_for_host_specific_task_list.add_implementation(file_processing_activity)

forking_executor = AWS::Flow::ForkingExecutor.new(:max_workers => 1)
forking_executor.execute { worker_for_common_task_list.start }
worker_for_host_specific_task_list.start
