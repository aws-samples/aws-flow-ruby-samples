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

require_relative 'search_activities'

# PickFirstBranchWorkflow class defines a workflow for the pick_first_branch 
# recipe. This recipe shows how we can start multiple branches in parallel and 
# pick the first one that completes and cancel the remaining branches.
class PickFirstBranchWorkflow
  extend AWS::Flow::Workflows

  workflow :search do
    {
      version: "1.0",
      task_list: "pick_first_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "SearchActivities" } }

  def search(query)
    # Search cluster 1
    branch1_result = search_on_cluster1(query)
    # Search cluster 2
    branch2_result = search_on_cluster2(query)

    # wait_for_any will block until atleast one of the futures in the enumerable
    # collection that it is given is ready.
    wait_for_any(branch1_result, branch2_result)

    # Here we will check which search was completed, that is which of the two
    # futures was ready, and cancel the other one.
    process_result(branch1_result, branch2_result)
  end

  # This method is used to get the output of the search that was completed and
  # cancel the other searches
  def process_result(branch1_result, branch2_result)
    if branch1_result.set?
      output = branch1_result.get
      # Cancel branch 2 if it is not complete yet
      @branch2.cancel(CancellationException.new) unless branch2_result.set?
    else
      output = branch2_result.get
      # Cancel branch 1 if it is not complete yet
      @branch1.cancel(CancellationException.new) unless branch1_result.set?
    end
    return output
  end

  # This method will run a search on cluster 1 by calling the search_cluster1
  # activity
  def search_on_cluster1(query)
    cluster1_result = Future.new
    @branch1 = error_handler do |t|
      t.begin do
        cluster1_result.set(client.search_cluster1(query))
      end
      t.rescue Exception do |e|
        raise e unless e.is_a?(CancellationException)
      end
    end
    return cluster1_result
  end

  # This method will run a search on cluster 2 by calling the search_cluster2
  # activity
  def search_on_cluster2(query)
    cluster2_result = Future.new
    @branch2 = error_handler do |t|
      t.begin do
        cluster2_result.set(client.search_cluster2(query))
      end
      t.rescue Exception do |e|
        raise e unless e.is_a?(CancellationException)
      end
    end
    return cluster2_result
  end
end
