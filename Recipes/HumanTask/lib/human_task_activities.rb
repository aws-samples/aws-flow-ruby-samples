require_relative 'utils'

class HumanTaskActivities
  extend AWS::Flow::Activities

  activity :automated_activity, :send_notification do
    {
      :version => "1.0",
      :default_task_list => $ACTIVITY_TASK_LIST,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end

  activity :human_activity do
    {
      :version => "1.0",
      :default_task_list => $ACTIVITY_TASK_LIST,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 120,
      :manual_completion => true
    }
  end

  def automated_activity
    $logger << "Automated activity executed\n"
  end

  def human_activity
    task_token = activity_execution_context.task_token
    $logger << "Task received, completion token:#{task_token}\n"
    # Ensure that we give the user the task token before asking to supply it
    $stdout.flush
    return "default string"
  end

  def send_notification(input)
    $logger << "message:#{input}\n"
  end
end
