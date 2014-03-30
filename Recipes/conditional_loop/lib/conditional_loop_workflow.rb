require_relative '../../recipe_activities'

# ConditionalLoopWorkflow class defines a workflow for the conditional_loop 
# recipe. This recipe shows how we can schedule an activity multiple times.
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

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "RecipeActivity" } }

  # This is the entry point for the workflow
  def loop_workflow

    # Use the activity client to get the number of records that we need to
    # process.
    count = client.get_count

    # Iteratively call the 'process' activity until the activity has been
    # invoked the desired number of times. Note that this will schedule
    # activities synchronously, so an invocation of activity will take place
    # only after the previous invocation finishes executing.
    count.times { |x| client.process(x) }
  end

end
