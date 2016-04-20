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

require_relative '../utils'

# RecipeActivity class contains a group of activities that are common to a
# bunch of recipes in this directory. 
class RecipeActivity
  extend AWS::Flow::Activities

  activity :activity_1, :activity_2, :report_results, :get_input, :get_choice, 
    :get_multi_choice, :get_count, :process do
    {
      version: "1.0",
      default_task_list: "activity_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
    }
  end

  def activity_1
    puts "activity: activity_1"
    1
  end

  def activity_2
    puts "activity: activity_2"
    2
  end

  def report_results(value)
    puts "reporting result: #{value}"
  end
  
  def get_input
    puts "activity: get_input"
    "input"
  end

  def get_choice
    puts "activity: get_choice"
    :input_1
  end

  def get_multi_choice
    puts "activity: get_multi_choice"
    [:input_1, :input_2]
  end
  
  def get_count
    puts "activity: get_count"
    10
  end

  def process(i)
    puts "activity: process #{i}"
  end

end
