require_relative '../periodic_utils'
require_relative 'periodic_workflow'
require_relative 'periodic_activity'
require_relative 'error_reporting_activity'

# Get a workflow client for PeriodicWorkflow and start a workflow execution with
# the required options
PeriodicUtils.new.workflow_client.start_execution(
  activity_name: :do_some_work,
  activity_prefix: "PeriodicActivity",
  execution_period_secs: 10,
  wait_for_completion: false,
  continue_as_new_secs: 20,
  completion_secs: 40
)
