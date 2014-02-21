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

require_relative 'spec_helper'
require 'yaml'

describe "Average Calculator Workflow Tests" do

  before(:all) do
    workflow_worker = WorkflowWorker.new($swf.client, $domain, $workflow_task_list, AverageCalculatorWorkflow)
    activity_worker = ActivityWorker.new($swf.client, $domain, $activity_task_list)
    workflow_worker.register
    activity_worker.register
    activity_worker.add_implementation(AverageCalculatorActivity.new($s3))

    my_workflow_client = workflow_client($swf.client, $domain){ {:from_class => "AverageCalculatorWorkflow"} }

    # Read keys from Config file
    config = SplitMergeConfig.new(File.join(File.dirname(__FILE__), "split_merge_spec_config.yml"))

    #write numbers to the s3 file so that we can test workflow execution
    obj = $s3.buckets[config.bucket_name].objects[config.filename]

    content = ""
    numbers = (1..100).to_a.shuffle
    numbers.each do |number|
      content += "%05d\r\n" % number
    end
    obj.write(content)

    # retrieve the expected results for some activities
    @data_size = numbers.length
    @first_half_sum = numbers[0, numbers.size/2].reduce(:+)
    @second_half_sum = numbers[numbers.size/2, numbers.size].reduce(:+)
    @average = numbers.reduce(:+).to_f/numbers.size.to_f

    puts "Starting an execution..."
    @workflow_execution = my_workflow_client.start_execution(config.bucket_name, config.filename, config.number_of_workers.to_i)

    $forking_executor = ForkingExecutor.new(:max_workers => 3)
    $forking_executor.execute { workflow_worker.start }
    $forking_executor.execute { activity_worker.start }

    sleep 5 until ["WorkflowExecutionContinuedAsNew", "WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? @workflow_execution.events.to_a.last.event_type

  end

  describe "Workflow History" do

    let(:events) { @workflow_execution.events }
    let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }
    let(:completed_activities) { events.select { |item| item.event_type == "ActivityTaskCompleted" } }

    it "should complete successfully" do
      events.to_a.last.event_type.should == "WorkflowExecutionCompleted"
    end

    it "should schedule 4 activities" do
      scheduled_activities.count.should == 4
    end

    it "should schedule activities in right order" do
      expected_trace = [["AverageCalculatorActivity.compute_data_size", "AverageCalculatorActivity.compute_sum_for_chunk",
                         "AverageCalculatorActivity.compute_sum_for_chunk", "AverageCalculatorActivity.report_result"]]
      expected_trace.should include scheduled_activities
    end

    it "should have expected results" do
      activity_results = completed_activities.map{|event| YAMLDataConverter.new.load(event.attributes[:result])}
      expected_results = [@data_size, @first_half_sum, @second_half_sum, @average]
      activity_results.each { |result| expected_results.should include result }
    end
  end

  after(:all) do
    $forking_executor.shutdown(1)
  end

end
