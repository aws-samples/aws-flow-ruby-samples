require_relative 'search_activities'

# Starts multiple branches of execution in parallel and picks the first one that
# completes, canceling the remaining branches.
class PickFirstBranchWorkflow
  extend AWS::Flow::Workflows

  workflow :search do
    {
      version: "1.0",
      task_list: "pick_first_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client
  activity_client(:client) { { from_class: "SearchActivities" } }

  # The main workflow, starts each cluster executing.
  def search(query)
    # this returns immediately with a future.
    branch1_result = search_on_cluster1(query)
    # so does this.
    branch2_result = search_on_cluster2(query)

    # wait for the first branch (either one) to return a result, then continue.
    wait_for_any(branch1_result, branch2_result)

    # cancels the slow branch and gets the result of the faster one.
    process_result(branch1_result, branch2_result)
  end

  # Cancel any unset branch, and return the result of the faster branch.
  def process_result(branch1_result, branch2_result)
    if branch1_result.set?
      output = branch1_result.get
      # Cancel branch 2 if not set
      @branch2.cancel(CancellationException.new) unless branch2_result.set?
    else
      output = branch2_result.get
      # Cancel branch 1 if not set
      @branch1.cancel(CancellationException.new) unless branch1_result.set?
    end
    return output
  end

  # Run the search_cluster1 activity asynchronously.
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

  # Run the search_cluster2 activity asynchronously.
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
