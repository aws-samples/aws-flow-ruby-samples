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

require_relative 'retry_activities'

# CustomLogicSyncRetryWorkflow class defines a workflow for the retry_activity
# recipes. This recipe shows how to set up custom retry for activities.
class CustomLogicSyncRetryWorkflow
  extend AWS::Flow::Workflows

  workflow :process do
    {
      version: "1.0",
      task_list: "workflow_tasklist",
      execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities. 
  activity_client(:client) { { from_class: "RetryActivities" } }

  # This is the entry point for the workflow
  def process
    handle_unreliable_activity
  end

  # For synchronous activities, use standard ruby begin / rescue / ensure
  # blocks for error handling. When an exception is caught, schedule the
  # activity again based on your custom retry logic.
  def handle_unreliable_activity
    begin
      client.unreliable_activity_without_retry_options
    rescue Exception => e
      retry_on_failure(e)
    end
  end

  def retry_on_failure(ex)
    handle_unreliable_activity if should_retry(ex)
  end

  def should_retry(ex)
    # custom logic to decide to retry the activity or not according to 'ex'
    return true
  end
end
