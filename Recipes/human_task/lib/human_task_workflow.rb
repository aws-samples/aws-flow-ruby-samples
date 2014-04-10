require_relative 'human_task_activities'

# HumanTaskWorkflow class defines a workflow for the human_task recipe. This
# recipe shows how we can schedule activities that need manual completion, i.e.,
# the activities need some user interaction before they can be completed.
class HumanTaskWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :human_task_workflow do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "HumanTaskActivities" } }

  # This is the entry point for the workflow
  def human_task_workflow
    # Use the activity client to schedule an automated activity. This is not
    # needed and is just for demonstration purposes.
    client.automated_activity

    # Now use the activity client to run the human_activity.
    human_result = client.human_activity

    # Once the human_activity gets completed, i.e., once the
    # respond_activity_task_completed method is called with correct task_token,
    # the human_activity is marked as completed and the following activity will 
    # then be scheduled.
    client.send_notification(human_result)
  end
end
