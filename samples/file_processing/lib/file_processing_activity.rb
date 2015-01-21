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
