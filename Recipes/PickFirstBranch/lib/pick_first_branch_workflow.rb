require_relative 'utils'
require_relative 'search_activities'

class PickFirstBranchWorkflow
  extend AWS::Flow::Workflows

  workflow :search do
    {
      :version => "1.0",
      :task_list => $WORKFLOW_TASK_LIST,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:client){ {:from_class => "SearchActivities"} }

  def search(query)
    branch1_result = search_on_cluster1(query)
    branch2_result = search_on_cluster2(query)

    wait_for_any(branch1_result, branch2_result)
    process_result(branch1_result, branch2_result)
  end

  def process_result(branch1_result, branch2_result)
    if branch1_result.set?
      output = branch1_result.get
      #cancel branch2 if it is not complete yet
      @branch2.cancel(CancellationException.new) unless branch2_result.set?
    else
      output = branch2_result.get
      @branch1.cancel(CancellationException.new) unless branch1_result.set?
    end
    return output
  end

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
