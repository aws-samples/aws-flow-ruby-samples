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
include AWS::Flow

class AverageCalculatorActivity 
  extend AWS::Flow::Activities

  ROW_SIZE = 7

  activity :compute_data_size, :compute_sum_for_chunk, :report_result do
    {
      :version => "1.0",
      :default_task_list => $activity_task_list, 
      :default_task_schedule_to_start_timeout => 60,
      :default_task_start_to_close_timeout => 120
    }
  end

  def initialize(s3_client)
    @s3_client = s3_client
  end

  def compute_data_size(bucket_name, filename)
    puts "compute data size starting filename=#{filename}"
    size = @s3_client.buckets[bucket_name].objects[filename].content_length
    puts "compute data size done"
    size/ROW_SIZE
  end

  def compute_sum_for_chunk(bucket_name, filename, chunk_number, chunk_size) 
    puts "compute sum for chunk starting chunk number: #{chunk_number}, chunk size: #{chunk_size}"

    sum = 0
    from = chunk_number * chunk_size
    to = from + chunk_size
    byte_off_set = chunk_number * chunk_size * ROW_SIZE
    bytes_to_read = chunk_size * ROW_SIZE

    # Read determined range of numbers from S3 file
    object = @s3_client.buckets[bucket_name].objects[filename]
    str = ""
    range = (byte_off_set..(byte_off_set + bytes_to_read - 1))
    object.read(:range => range) do |chunk|
      str += chunk
    end 

    # Compute sum of read numbers
    array = str.split(/\r?\n/).map(&:to_i)
    sum = array.reduce(:+)

    puts "sum from #{from+1} to #{to} is #{sum}"
    puts "compute sum for chunk done"
    sum
  end

  def report_result(result)
    puts "result: #{result}"
    result
  end

end


activity_worker = ActivityWorker.new($swf.client, $domain, $activity_task_list)
activity_worker.add_implementation(AverageCalculatorActivity.new($s3))
activity_worker.start if __FILE__ == $0
