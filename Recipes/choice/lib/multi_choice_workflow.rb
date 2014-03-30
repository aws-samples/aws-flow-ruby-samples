require_relative '../../recipe_activities'

# MultiChoiceWorkflow class defines a workflow for the multi choice recipe. 
# This recipe shows how a workflow can execute multiple activities in parallel 
# from a given set of activities based on a workflow input or result of an
# activity. 
class MultiChoiceWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :multi_choice do
    {
      version: "1.0",
      task_list: "multi_choice_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "RecipeActivity" } }

  # This is the entry point for the workflow
  def multi_choice

    # Use the activity client to get an input to decide what the next steps of
    # the workflow.
    multi_choice = client.get_multi_choice

    results = multi_choice.map do |choice|
      # Use a case statement or an equivalent branching mechanism to decide 
      # which branch of code to execute
      case choice
      when :input_1
        # Use the send_async method of the activity client to call activity_1 
        # asynchronously if the choice is 1
        client.send_async(:activity_1)
      when :input_2
        # Use the send_async method of the activity client to call activity_2 
        # asynchronously if the choice is 2
        client.send_async(:activity_2)
      end

    end

    # wait_for_all will block until all the futures in the enumerable 
    # collection that it is given are ready. There is also wait_for_any, which 
    # will return when any of the futures are ready. In this way, you can join 
    # on a parallel split and synchronize multiple branches.
    wait_for_all(*results)
  end

end
