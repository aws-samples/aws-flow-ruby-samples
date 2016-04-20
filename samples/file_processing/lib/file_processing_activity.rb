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

require 'zip'
require_relative '../file_processing_utils.rb'

# FileProcessingActivity class defines a set of activities for the
# FileProcessing sample.
class FileProcessingActivity
  extend AWS::Flow::Activities

  # The activity method is used to define activities. It accepts a list of names
  # of activities and a block specifying registration options for those
  # activities
  activity :process_file do
    {
      version: FileProcessingUtils::FILE_ACTIVITY_VERSION,
      defaul_task_list: FileProcessingUtils::ACTIVITY_TASKLIST,
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 60
    }
  end

  def initialize(local_dir)
    @local_dir = local_dir
  end

  # This activity can be used to zip a given file
  def process_file(filename, zipname)
    puts "Process file activity"
    Zip::ZipFile.open(@local_dir + zipname, Zip::ZipFile::CREATE) do |zipFile|
      zipFile.add(filename, @local_dir + filename)
    end
  end
end
