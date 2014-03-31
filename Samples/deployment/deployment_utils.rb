require_relative '../../utils'

class DeploymentUtils
  include SharedUtils

  WF_VERSION = "1.0"
  ACTIVITY_VERSION = "1.0"
  WF_TASKLIST = "deployment_workflow_task_list"
  ACTIVITY_TASKLIST = "deployment_activity_task_list"
  DOMAIN = "Deployment"

  def initialize
    @domain = setup_domain(DOMAIN)
  end

  def activity_worker
    build_activity_worker(@domain, DeploymentActivity, ACTIVITY_TASKLIST)
  end

  def workflow_worker
    build_workflow_worker(@domain, DeploymentWorkflow, WF_TASKLIST)
  end

  def workflow_client
    build_workflow_client(@domain, from_class: "DeploymentWorkflow")
  end
end
