require_relative '../../utils'

class SplitMergeUtils
  include SharedUtils

  WF_VERSION = "1.0"
  ACTIVITY_VERSION = "1.0"

  WF_TASKLIST = "splitmerge_workflow_tasklist"
  ACTIVITY_TASKLIST = "splitmerge_activity_tasklist"

  DOMAIN = "SplitMerge"

  BUCKET = "swf-private-beta-samples"
  FILENAME = "split-merge-sample/input.txt"
  FLEET_SIZE = 5

  def initialize
    @domain = setup_domain(DOMAIN)
  end

  def activity_worker
    build_activity_worker(@domain, SplitMergeActivity, ACTIVITY_TASKLIST)
  end

  def workflow_worker
    build_workflow_worker(@domain, SplitMergeWorkflow, WF_TASKLIST)
  end

  def workflow_client
    build_workflow_client(@domain, from_class: "SplitMergeWorkflow")
  end
end
