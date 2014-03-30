require_relative '../../recipe_activities'

# ExclusiveChoiceWorkflow class defines a workflow for the exclusive choice
# recipe. This recipe shows how a workflow can take different execution paths. 
# In this example, we call an activity to get an input and based on that input, 
# we either execute the first code branch or the second, but never both.
# One example of such a workflow could be an online shopping transaction where 
# customers can pay with a credit card or use a gift coupon. The payment 
# workflow could then take a different execution path based on the customer's 
# choice.
class ExclusiveChoiceWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :exclusive_choice do
    {
      version: "1.0",
      task_list: "exclusive_choice_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client){ { from_class: "RecipeActivity" } }

  # This is the entry point for the workflow
  def exclusive_choice

    # Use the activity client to get an input to decide what the next steps of
    # the workflow.
    choice = client.get_choice

    # Use a case statement or an equivalent branching mechanism to decide which
    # branch of code to execute
    case choice
    when :input_1
      # Use the activity client to call activity_1 if the choice is 1
      client.activity_1
    when :input_2
      # Use the activity client to call activity_2 if the choice is 2
      client.activity_2
    end

  end
end
