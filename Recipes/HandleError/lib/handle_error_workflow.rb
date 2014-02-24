require_relative 'utils'
require_relative 'resource_management_activities'

class ResourceNoResponseException < Exception; end
class ResourceNotAvailableException < Exception; end

class HandleErrorWorkflow
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
    ex = Future.new
    resource_id = client.allocate_resource

    error_handler do |t|
      t.begin do
        wait_for = client.send_async(:use_resource, resource_id)
        wait_for_all(wait_for)
      end
      t.rescue Exception do |e|
        ex.set(e)
      end
      t.ensure do
        handle_exception(ex.get, resource_id) if ex.set?
      end
    end
  end

  def handle_exception(e, resource_id)
    throw e unless e.instance_of? ActivityTaskFailedException and 
      (e.cause.instance_of? ResourceNoResponseException or 
       e.cause.instance_of? ResourceNotAvailableException)

    client.report_bad_resource(resource_id) if e.cause.instance_of? ResourceNoResponseException
    client.refresh_resource_catalog(resource_id) if e.cause.instance_of? ResourceNotAvailableException
  end
end
