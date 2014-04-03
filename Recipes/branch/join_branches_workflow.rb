require_relative '../../recipe_activities'

# Implements the synchronization workflow pattern.
class JoinBranchesWorkflow
  extend AWS::Flow::Workflows

  # defines the workflow entry point.
  workflow :join_branches do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  activity_client(:client) { { from_class: "RecipeActivity" } }

  # This is the entry point for the workflow
  def join_branches(num_branches)
    # launch the activities asynchronously and gather the Futures.
    future_array = (1..num_branches).map { client.send_async(:activity_1) }

    # wait for all activities to complete (the futures will be filled)
    wait_for_all(*future_array)

    # sum the results and send the result to the report_results activity
    client.send(:report_results, future_array.map(&:get).reduce(0, :+))
  end
end
