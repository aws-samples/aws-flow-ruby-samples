require_relative '../../utils'

class CronWithRetryUtils
  include SharedUtils

  WF_VERSION = "1.0"
  ACTIVITY_VERSION = "1.0"
  WF_TASKLIST = "cron_workflow_task_list"
  ACTIVITY_TASKLIST = "cron_activity_task_list"
  DOMAIN = "CronWithRetry"

  def initialize
    @domain = setup_domain(DOMAIN)
  end

  def activity_worker
    build_activity_worker(@domain, CronWithRetryActivity, ACTIVITY_TASKLIST)
  end

  def workflow_worker
    build_workflow_worker(@domain, CronWithRetryWorkflow, WF_TASKLIST)
  end

  def workflow_client
    build_workflow_client(@domain, from_class: "CronWithRetryWorkflow")
  end

end
