require_relative '../../recipe_activities'

# This recipe shows how we can schedule an activity multiple times.
class ConditionalLoopWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :loop_workflow do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Set the activity client to schedule activities.
  activity_client(:client) { { from_class: "RecipeActivity" } }

  # The entry point for the workflow
  def loop_workflow

    # Get the number of records that we need to process.
    count = client.get_count

    # Iteratively call the 'process' activity until the activity has been
    # invoked the desired number of times.
    count.times { |x| client.process(x) }
  end

end
