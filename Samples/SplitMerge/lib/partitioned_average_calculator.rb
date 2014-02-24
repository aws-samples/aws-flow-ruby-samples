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

require 'aws/s3'
require 'fileutils'
require_relative 'average_calculator_activity'
require_relative 'utils'

class PartitionedAverageCalculator  

  def initialize(number_of_workers, bucket_name, client)
    @number_of_workers = number_of_workers
    @bucket_name = bucket_name
    @client = client
  end

  def compute_average(filename)
    data_size = @client.compute_data_size(@bucket_name, filename)
    compute_average_distributed(filename, data_size)
  end

  def compute_average_distributed(filename, data_size)
    chunk_size = data_size/@number_of_workers

    # Array will hold results of sum calculated by each worker
    results = Array.new
    for chunk_number in 0..(@number_of_workers-1)
      # Asynchronous call to activity computes sum for each chunk
      results << @client.send_async(:compute_sum_for_chunk, @bucket_name, filename, chunk_number, chunk_size)
    end

    # Block unitl all promises in array are ready
    wait_for_all(results)

    # Merge phase
    merge_sum_and_compute_average(results, data_size)
  end

  def merge_sum_and_compute_average(results, data_size)
    total_sum = 0
    results.each do |result|
      total_sum += result.get
    end
    total_sum.to_f/data_size.to_f
  end

  def report_result(result)
    @client.report_result(result)
  end

end
