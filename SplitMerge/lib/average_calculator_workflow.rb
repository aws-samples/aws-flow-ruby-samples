##
# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#  http://aws.amazon.com/apache2.0
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.
##

require_relative 'utils'
require_relative 'partitioned_average_calculator'
include AWS::Flow

class AverageCalculatorWorkflow 
  extend AWS::Flow::Workflows

  workflow :average do
    {
      :version => "1.0", 
      :task_list => $workflow_task_list,
      :execution_start_to_close_timeout => 360, 
    }
  end 

  # create client for activity
  activity_client(:average_calculator_activity) { 
    {:from_class => "AverageCalculatorActivity"} 
  }

  def average(bucket_name, filename, number_of_workers)
    calculator = PartitionedAverageCalculator.new(number_of_workers, bucket_name, average_calculator_activity )
    result = calculator.compute_average(filename)
    calculator.report_result(result)
  end

end

workflow_worker = WorkflowWorker.new($swf.client, $domain, $workflow_task_list, AverageCalculatorWorkflow)
workflow_worker.start if __FILE__ == $0
