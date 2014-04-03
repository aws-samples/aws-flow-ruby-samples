require_relative '../../recipe_activities'

# execute multiple activitise in parallel based on a set of choices.
class MultiChoiceWorkflow
  extend AWS::Flow::Workflows

  # define the workflow entry point.
  workflow :multi_choice do
    {
      version: "1.0",
      task_list: "multi_choice_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client
  activity_client(:client) { { from_class: "RecipeActivity" } }

  # execute activities based on a set of choices.
  def multi_choice
    # get the choices from the client.
    multi_choice = client.get_multi_choice

    # for each choice, pick an activity to run.
    results = multi_choice.map do |choice|
      case choice
      when :input_1
        # call activity_1 asynchronously if the choice is 1
        client.send_async(:activity_1)
      when :input_2
        # call activity_2 asynchronously if the choice is 2
        client.send_async(:activity_2)
      end
    end

    # wait for all of the chosen activities to complete before completing the workflow.
    wait_for_all(*results)
  end
end
