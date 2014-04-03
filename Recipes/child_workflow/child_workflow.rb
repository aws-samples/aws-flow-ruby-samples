require_relative '../../recipe_activities'

# Shows how to create a child workflow from a parent workflow.
class ChildWorkflow
  extend AWS::Flow::Workflows

  # Define the workflow entry point.
  workflow :child do
    {
      version: "1.0",
      task_list: "child_workflow_tasklist",
      execution_start_to_close_timeout: 120
    }
  end

  activity_client(:client){ {from_class: "RecipeActivity"} }

  # the entry point for the child workflow
  def child(input)
    # You can use the child workflow to do some work and return a result to the
    # parent workflow, or just close it when the work is completed successfully.
    client.report_results(input)
  end
end
