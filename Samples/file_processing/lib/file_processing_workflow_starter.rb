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
