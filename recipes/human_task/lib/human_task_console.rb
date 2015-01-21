# HumanTaskConsole is a basic implementation of a console that a user will use
# to enter the task_token that he receives from an activity.
class HumanTaskConsole

  # The main method of the console. You can run the console by running
  # HumanTaskConsole.new.run
  def run
    # Prompt the user for the task token
    puts "Enter the token of the task to compelete:"
    task_token = $stdin.gets.chomp

    # Prompt the user for the result of the task
    puts "Enter the result of the task:"
    result = $stdin.gets.chomp

    # Create a SimpleWorkflow client to call the service
    swf = AWS::SimpleWorkflow.new

    # Use respond_activity_task_completed with the task_token and the result to
    # let SimpleWorkflow know that the task has been completed.
    swf.client.respond_activity_task_completed({
        task_token: "#{task_token}",
        result: "#{result}"
      })
  end
end

# You can run the console by just running this file as follows in your terminal
# - $ ruby human_task_workflow.rb
HumanTaskConsole.new.run if __FILE__ == $0
