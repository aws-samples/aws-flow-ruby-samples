require_relative 'utils'
require_relative 'human_task_activities'

class HumanTaskWorkflow
  extend AWS::Flow::Workflows

  workflow :start_workflow do
    {
      :version => "1.0",
      :task_list => $WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client){ {:from_class => "HumanTaskActivities"} }

  def start_workflow
    client.automated_activity
    human_result = client.human_activity
    client.send_notification(human_result)
  end
end
