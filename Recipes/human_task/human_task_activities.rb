require_relative '../../../utils'

# HumanTaskActivities defines the activities required for the human_task recipe.
class HumanTaskActivities
  extend AWS::Flow::Activities

  # Automated activity, this activity is complete when the automated_activity
  # method returns.
  activity :automated_activity, :send_notification do
    {
      version: "1.0",
      default_task_list: "activity_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
    }
  end

  # Setting the manual_completion option to true alerts SWF that this activity
  # requires manual completion. human_activity returns immediately.
  activity :human_activity do
    {
      version: "1.0",
      default_task_list: "activity_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 120,
      manual_completion: true
    }
  end

  # This is just an automated activity.
  def automated_activity
    puts "activity: automated_activity"
  end

  # This activity gets the task_token from the activity_execution_context and
  # prints it out so that the user can enter it when prompted.
  def human_activity
    puts "activity: human_activity"
    # Fetch the task token for this activity task using
    # activity_execution_context.
    task_token = activity_execution_context.task_token
    puts "Task received, completion token:#{task_token}\n"
    return "default string"
  end

  # Send notification of the input
  def send_notification(input)
    puts "activity: send_notification: #{input}"
  end
end
