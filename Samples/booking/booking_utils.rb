require_relative '../../utils'

class BookingUtils
  include SharedUtils

  WF_VERSION = "1.0"
  ACTIVITY_VERSION = "1.0"
  WF_TASKLIST = "booking_workflow_task_list"
  ACTIVITY_TASKLIST = "booking_activity_task_list"
  DOMAIN = "Booking"

  def initialize
    @domain = setup_domain(DOMAIN)
  end

  def activity_worker
    build_activity_worker(@domain, BookingActivity, ACTIVITY_TASKLIST)
  end

  def workflow_worker
    build_workflow_worker(@domain, BookingWorkflow, WF_TASKLIST)
  end

  def workflow_client
    build_workflow_client(@domain, from_class: "BookingWorkflow")
  end
end
