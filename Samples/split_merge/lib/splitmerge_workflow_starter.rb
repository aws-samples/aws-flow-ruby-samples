require_relative '../splitmerge_utils'
require_relative 'splitmerge_workflow'
require_relative 'splitmerge_activity'

# Get a workflow client for SplitMergeWorkflow and start a workflow execution
# with the required options
SplitMergeUtils.new.workflow_client.start_execution(
  bucket: SplitMergeUtils::BUCKET,
  filename: SplitMergeUtils::FILENAME,
  fleet_size: SplitMergeUtils::FLEET_SIZE
)
