require_relative '../../recipe_activities'

# JoinBranchesWorkflow class defines a workflow for the branch recipe. This
# recipe shows how we can schedule multiple activities in parallel and wait for
# all of them to complete before continuing execution. This is an implementation
# of the Synchronization workflow pattern.
class JoinBranchesWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :join_branches do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "RecipeActivity" } }

  # This is the entry point for the workflow
  def join_branches(num_branches)

    # This is where we start the parallel execution of activities
    # You can use the send_async method of the activity client to schedule an
    # activity asynchronously. Here we schedule num_branches number of
    # activities in parallel. Because send_async will schedule activities
    # asynchronously, it will not block here, but will instead return a future.
    # So, at the end of this each loop, future_array will contain num_branches 
    # futures that will correspond to the values that will eventually be 
    # returned from calling the activities.
    future_array = (1..num_branches).map { client.send_async(:activity_1) }

    # wait_for_all will block until all the futures in the enumerable 
    # collection that it is given are ready. There is also wait_for_any, which 
    # will return when any of the futures are ready. In this way, you can join 
    # on a parallel split and synchronize multiple branches.
    wait_for_all(*future_array)

    # Once all the futures are ready, we can then sum the results up and report
    # the results by calling our report_results activity. Notice how we don't 
    # use send_async here because we just want to schedule a synchronous 
    # activity.
    client.send(:report_results, future_array.map(&:get).reduce(0, :+))
  end
end
