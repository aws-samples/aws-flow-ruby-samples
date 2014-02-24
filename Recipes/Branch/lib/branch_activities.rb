require_relative 'utils'

class BranchActivities
  extend AWS::Flow::Activities

  activity :do_some_work, :report_result do
    {
      :version => "1.0",
      :default_task_list => $ACTIVITY_TASK_LIST, 
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end

  def do_some_work()
    $logger << "result: 1\n"
    1 # each branch returns 1, and so the sum is the number of branches 
  end

  def report_result(sum)
    $logger << "sum: #{sum}\n"
    sum
  end

end
