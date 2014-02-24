require_relative 'utils'

class ConditionalLoopActivities
  extend AWS::Flow::Activities

  activity :get_record_count, :process_record do
    {
      :version => "1.0",
      :default_task_list => $ACTIVITY_TASK_LIST,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end

  def get_record_count
    records = 5
    $logger << "count:#{records}\n"
    records
  end

  def process_record
    $logger << "process one record\n"
  end
end
