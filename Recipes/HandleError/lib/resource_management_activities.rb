require_relative 'utils'

class ResourceManagementActivities
  extend AWS::Flow::Activities

  activity :allocate_resource, :use_resource, :clean_up_resource,
    :report_bad_resource, :refresh_resource_catalog, :roll_back_changes do
    {
      :version => "1.0",
      :default_task_list => $ACTIVITY_TASK_LIST,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end


  def initialize(should_fail, should_raise_handleable)
    # For testing purposes, variables for controlling exception throw
    # in the activity of use_resource
    @should_fail = should_fail
    @should_raise_handleable = should_raise_handleable
  end

  def allocate_resource()
    resource_id = 100
    $logger << "allocating resource with resource_id:#{resource_id}\n"
    resource_id
  end

  def use_resource(resource_id)
    $logger << "using resource with resource_id:#{resource_id}\n"
    if @should_fail
      if @should_raise_handleable
        raise ResourceNoResponseException, "an intentional error"
      else
        raise RuntimeError, "an intentional error"
      end
    end
  end

  def clean_up_resource(resource_id)
    $logger << "cleaning up resource with resource_id:#{resource_id}\n"
  end

  def report_bad_resource(resource_id)
    $logger << "reporting bad resource with resource_id:#{resource_id}\n"
  end

  def refresh_resource_catalog(resource_id)
    $logger << "refreshing resource with resource_id:#{resource_id}\n"
  end

  def roll_back_changes(resource_id)
    $logger << "rolling back changes with resource_id:#{resource_id}\n"
  end
end
