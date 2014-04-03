require_relative 'human_task_activities'

# schedule an activity that requires manual (human) completion using a task
# token.
class HumanTaskWorkflow
  extend AWS::Flow::Workflows

  # define the workflow entry point.
  workflow :human_task_workflow do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client
  activity_client(:client){ {from_class: "HumanTaskActivities"} }

  # run several activities, including a manual activity. These are all run
  # synchronously.
  def human_task_workflow
    # Schedule an automated activity (for demo purposes)
    client.automated_activity

    # Next, Schedule the human_activity.
    human_result = client.human_activity

    # Finally, schedule the notification (also automated) activity.
    client.send_notification(human_result)
  end
end
