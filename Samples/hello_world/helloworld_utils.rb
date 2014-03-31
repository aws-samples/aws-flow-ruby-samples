require_relative '../../utils'

class HelloWorldUtils
  include SharedUtils

  WF_VERSION = "1.0"
  ACTIVITY_VERSION = "1.0"
  WF_TASKLIST = "workflow_tasklist"
  ACTIVITY_TASKLIST = "activity_tasklist"
  DOMAIN = "HelloWorld"

  def initialize
    @domain = setup_domain(DOMAIN)
  end

  def activity_worker
    build_activity_worker(@domain, HelloWorldActivity, ACTIVITY_TASKLIST)
  end

  def workflow_worker
    build_workflow_worker(@domain, HelloWorldWorkflow, WF_TASKLIST)
  end

  def workflow_client
    build_workflow_client(@domain, from_class: "HelloWorldWorkflow")
  end
end
