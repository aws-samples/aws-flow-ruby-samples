require_relative 'utils'
require_relative 'resource_management_activities'

class CleanUpResourceWorkflow
  extend AWS::Flow::Workflows

  workflow :start_workflow do
    {
      :version => "1.0",
      :task_list => $WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client){ {:from_class => "ResourceManagementActivities"} }

  def start_workflow
    roll_back_changes = Future.new
    resource_id = client.allocate_resource

    error_handler do |t|
      t.begin do
        client.send_async(:use_resource, resource_id)
      end
      t.rescue Exception do |ex|
        roll_back_changes.set(true)
      end
      t.ensure do
        client.roll_back_changes(resource_id) if roll_back_changes.set?
        client.clean_up_resource(resource_id) 
      end
    end
  end
end
