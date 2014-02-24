require_relative 'utils.rb'

class ErrorReportingActivity
  extend AWS::Flow::Activities

  activity :report_failure do 
    {
      :version => "1.0",
      :default_task_list => $error_reporting_activity_task_list,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30 
    }
  end

  def report_failure(e)
    workflow_execution = activity_execution_context.workflow_execution
    puts "Run Id:" + workflow_execution.run_id + ", Failure in periodic task:" + e.backtrace.to_s
  end

end

activity_worker = AWS::Flow::ActivityWorker.new(
  $swf.client, $domain, $error_reporting_activity_task_list, ErrorReportingActivity)

activity_worker.start if __FILE__ == $0
