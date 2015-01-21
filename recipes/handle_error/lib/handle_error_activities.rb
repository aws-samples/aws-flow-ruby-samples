require_relative '../../../utils'
require_relative 'custom_exceptions'


# HandleErrorActivities defines the activities for the handle_error recipes.
class HandleErrorActivities
  extend AWS::Flow::Activities

  activity :allocate_resource, :use_resource, :cleanup,
    :report_resource, :refresh_catalogue, :rollback do
    {
      version: "1.0",
      default_task_list: "handle_error_activity_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
    }
  end

  def allocate_resource
    puts "activity: allocate_resource"
    100
  end

  def use_resource(resource_id)
    puts "activity: use_resource"
    # This activity will intentionally raise an error to demonstrate the error
    # handling capability of the HandleErrorWorkflow
    raise ResourceNoResponseException, "an intentional error"
  end

  def cleanup(resource_id)
    puts "activity: cleanup"
  end

  def report_resource(resource_id)
    puts "activity: report_resource"
  end

  def refresh_catalogue(resource_id)
    puts "activity: refresh_catalogue"
  end

  def rollback(resource_id)
    puts "activity: rollback"
  end
end
