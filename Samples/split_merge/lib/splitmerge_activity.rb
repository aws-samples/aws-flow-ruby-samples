require_relative '../splitmerge_utils'

# SplitMergeActivity class defines a set of activities for the SplitMerge sample
class SplitMergeActivity
  extend AWS::Flow::Activities

  ROW_SIZE = 7

  # The activity method is used to define activities. It accepts a list of names
  # of activities and a block specifying registration options for those
  # activities
  activity :compute_size, :partial_sum, :report_result do
    {
      version: SplitMergeUtils::ACTIVITY_VERSION,
      default_task_list: SplitMergeUtils::ACTIVITY_TASKLIST,
      default_task_schedule_to_start_timeout: 60,
      default_task_start_to_close_timeout: 120
    }
  end

  # This activity is used to calculate the size of the data
  def compute_size(options)
    puts "Compute size activity"
    # Get the file object from S3 and get it's size
    size = s3.buckets[options[:bucket]].objects[options[:filename]].content_length
    size/ROW_SIZE
  end

  # This activity is used to calculate the partial sum from each chunk of data
  def partial_sum(options, chunk_number)
    puts "Partial sum activity"
    puts "Chunk Number: #{chunk_number}"
    puts "Chunk Size: #{options[:chunk_size]}"

    # Calculate the byte offset and the number of bytes to read from the file
    byte_offset = chunk_number * options[:chunk_size] * ROW_SIZE
    bytes_to_read = options[:chunk_size] * ROW_SIZE

    # Read determined range of numbers from S3 file
    object = s3.buckets[options[:bucket]].objects[options[:filename]]
    str = ""
    range = (byte_offset..(byte_offset + bytes_to_read - 1))
    object.read(:range => range) do |chunk|
      str += chunk
    end

    # Convert the read data into integers and get their sum
    sum = str.split(/\r?\n/).map(&:to_i).reduce(:+)

    puts "Partial sum: #{sum}"
    sum
  end

  def s3
    # Initialize the S3 client if it's not already initialized
    @s3 ||= AWS::S3.new
  end

  # This activity can be used to report the result
  def report_result(result)
    puts "Report result activity: #{result}"
  end

end

# Start an ActivityWorker to work on the SplitMergeActivity tasks
SplitMergeUtils.new.activity_worker.start if $0 == __FILE__
