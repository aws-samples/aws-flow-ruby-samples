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

require_relative '../../recipe_activities'

# ChildWorkflow class defines a child workflow for the child_workflow 
# recipe. This recipe shows how to create a child workflow from a parent 
# workflow. In a real workflow, the parent workflow could be an order
# processing workflow and the child workflow could be a payment processing
# workflow that gets called by the parent workflow.
class ChildWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :child do
    {
      version: "1.0",
      task_list: "child_workflow_tasklist",
      execution_start_to_close_timeout: 120
    }
  end

  activity_client(:client) { { from_class: "RecipeActivity" } }

  # This is the entry point for the child workflow
  def child(input)
    # You can use the child workflow to do some work and return a result to the
    # parent workflow or just close when the work is completed successfully.
    client.report_results(input)
  end
end
