require_relative '../../../utils'

# SearchActivities defines the activities for the pick_first_branch recipe.
class SearchActivities
  extend AWS::Flow::Activities

  activity :search_cluster1, :search_cluster2 do
    {
      version: "1.0",
      default_task_list: "search_activities_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
    }
  end

  def search_cluster1(query)
    puts "activity: search_cluster1"
    # For demonstration purposes, we will ensure the activity gets cancelled 
    # by forcing it to wait.
    # Activities will only be cancelled early if they heartbeat, otherwise
    # cancellation will only take effect when they attempt to complete
    1.upto(6) do |i|
        sleep 5
        activity_execution_context.record_activity_heartbeat(i.to_s)
    end
  end

  def search_cluster2(query)
    puts "activity: search_cluster2"
    ["result3", "result4"]
  end
end
