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

require 'zip'
require_relative 'utils.rb'

class FileProcessingActivity
  extend AWS::Flow::Activities

  activity :process_file do 
    {
      :version => "1.0",
      :defaul_task_list => $activity_task_list,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 60 
    }
  end

  def initialize(local_dir)
    @local_dir = local_dir
  end

  def process_file(filename, zip_filename)
    full_path_filename = @local_dir + filename
    full_path_zip_filename = @local_dir + zip_filename

    puts "zip filename=#{full_path_filename} to zip_filename=#{full_path_zip_filename}"

    begin
      Zip::ZipFile.open(full_path_zip_filename, Zip::ZipFile::CREATE) do |zipFile|
        zipFile.add(filename, full_path_filename)
      end
    rescue Exception => e
      puts "Failed: #{e.message}"
    end

    puts "finish compressing"
  end
end
