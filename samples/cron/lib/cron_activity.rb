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

require_relative '../cron_utils'

# CronActivity class defines a set of activities for the Cron sample.
class CronActivity
  extend AWS::Flow::Activities

  # The activity method is used to define activities. It accepts a list of names
  # of activities and a block specifying registration options for those
  # activities
  activity :run_job, :add, :sum do
    {
      default_task_list: CronUtils::ACTIVITY_TASKLIST,
      version: CronUtils::ACTIVITY_VERSION,
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
    }
  end

  # This activity takes in a function to call and executes it
  # @param func [lambda] function that will get called by the activity
  # @return [void] returns whatever the function call returns
  def run_job(func, *args)
    puts "Running a job"
    if self.method(func).arity > 1
      self.send(func, *args)
    else
      self.send(func, args)
    end
  end

  # This activity adds two numbers
  def add(a,b)
    puts "Adding two numbers"
    a + b
  end

end

# Start an ActivityWorker to work on the CronActivity tasks
CronUtils.new.activity_worker.start if __FILE__ == $0
