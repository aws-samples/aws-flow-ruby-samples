require_relative '../../utils'

class PeriodicUtils
  include SharedUtils

  WF_VERSION = "1.0"
  ACTIVITY_VERSION = "1.0"
  ERROR_ACTIVITY_VERSION = "1.0"
  WF_TASKLIST = "periodic_workflow_tasklist"
  ACTIVITY_TASKLIST = "periodic_activity_tasklist"
  ERROR_ACTIVITY_TASKLIST = "error_activity_tasklist"
  DOMAIN = "Periodic"

  def initialize
    @domain = setup_domain(DOMAIN)
  end

  def periodic_activity_worker
    build_activity_worker(@domain, PeriodicActivity, ACTIVITY_TASKLIST)
  end

  def error_activity_worker
    build_activity_worker(@domain, ErrorReportingActivity, ERROR_ACTIVITY_TASKLIST)
  end

  def workflow_worker
    build_workflow_worker(@domain, PeriodicWorkflow, WF_TASKLIST)
  end

  def workflow_client
    build_workflow_client(@domain, from_class: "PeriodicWorkflow")
  end
end
