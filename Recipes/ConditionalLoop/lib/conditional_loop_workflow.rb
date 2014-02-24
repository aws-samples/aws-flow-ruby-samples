require_relative 'utils'
require_relative 'conditional_loop_activities'

class ConditionalLoopWorkflow
  extend AWS::Flow::Workflows

  workflow :start_workflow do
    {
      :version => "1.0",
      :task_list => $WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client){ {:from_class => "ConditionalLoopActivities"} }

  def start_workflow
    process_records(client.get_record_count)
  end

  def process_records(record_count)
    if record_count >= 1
      client.process_record
      process_records(record_count - 1)
    end
  end
end
