# Copyright 2014-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

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
