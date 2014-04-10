require_relative '../../recipe_activities'
require_relative 'child_workflow'

# ParentWorkflow class defines a parent workflow for the child_workflow 
# recipe. This recipe shows how to create a child workflow from a parent 
# workflow. In a real workflow, the parent workflow could be an order
# processing workflow and the child workflow could be a payment processing
# workflow that gets called by the parent workflow.
class ParentWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :parent do
    {
      version: "1.0",
      task_list: "parent_workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "RecipeActivity" } }

  # This is the entry point for the parent workflow
  def parent

    # Use the activity client to get an input for the child workflow
    input = client.get_input

    # Set up swf client and domain that will be needed to create a workflow
    # client
    swf = AWS::SimpleWorkflow.new
    domain = swf.domains["Recipes"]

    # Create a workflow client using the workflow_client provided by flow
    child_client = AWS::Flow::workflow_client(swf, domain) { 
      { from_class: "ChildWorkflow" } 
    }

    # Use the workflow client to start a child workflow execution.
    child_client.start_execution(input)
  end
end
