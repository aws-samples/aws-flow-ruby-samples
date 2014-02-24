require 'aws/decider'

require_relative 'utils'
require_relative 'file_processing_config'
require_relative 'file_processing_workflow'

include AWS::Flow

config = FileProcessingConfig.new(File.join(File.dirname(__FILE__), "file_processing_config.yml"))

my_workflow_client = workflow_client( $swf.client, $domain) { {:from_class => "FileProcessingWorkflow"} }
workflow_execution = my_workflow_client.start_execution(config.source_bucket_name, config.source_filename, config.target_bucket_name, config.target_filename)
