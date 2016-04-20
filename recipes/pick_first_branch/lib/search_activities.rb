# Copyright 2014-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

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
