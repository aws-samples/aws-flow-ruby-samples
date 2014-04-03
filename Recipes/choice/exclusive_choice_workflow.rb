require_relative '../../recipe_activities'

class ExclusiveChoiceWorkflow
  extend AWS::Flow::Workflows

  # define the workflow entry point.
  workflow :exclusive_choice do
    {
      version: "1.0",
      task_list: "exclusive_choice_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client
  activity_client(:client){ { from_class: "RecipeActivity" } }

  # pick one or another activity based on the output of the get_choice activity.
  def exclusive_choice

    # schedule the get_choice activity and get its result.
    choice = client.get_choice

    # choose to schedule activity 1 or 2 based on the choice value.
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
