# A basic implementation of a console that a user could use to enter the
# task_token received from a manual activity.
class HumanTaskConsole

  # The main method for the console.
  def run
    # Prompt the user for the task token
    puts "Enter the token of the task to complete:"
    task_token = $stdin.gets.chomp

    # Prompt the user for the result of the task
    puts "Enter the result of the task:"
    result = $stdin.gets.chomp

    # Create a SimpleWorkflow client to call the service
    swf = AWS::SimpleWorkflow.new

    # Call respond_activity_task_completed, providing it with the task_token and
    # the human task result to alert SWF that the task has been completed.
    swf.client.respond_activity_task_completed({
        task_token: "#{task_token}",
        result: "#{result}"
      })
  end
end

# If the script is executed, create a new HumanTaskConsole and run the main
# (run) method.
HumanTaskConsole.new.run if __FILE__ == $0
