require_relative 'utils.rb'

class PeriodicActivity
  extend AWS::Flow::Activities

  activity :do_some_work do 
    {
      :version => "1.0",
      :default_task_list => $periodic_activity_task_list,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30
    }
  end

  def do_some_work(parameter)
    puts "Run Id:#{activity_execution_context.workflow_execution.run_id}, do some periodic task here for #{sleep Random.rand(3)} second(s) with parameter=#{parameter}"
  end
end

activity_worker = AWS::Flow::ActivityWorker.new(
  $swf.client, $domain, $periodic_activity_task_list, PeriodicActivity)

activity_worker.start if __FILE__ == $0
