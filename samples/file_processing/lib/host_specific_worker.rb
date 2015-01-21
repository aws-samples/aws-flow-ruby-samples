require_relative '../file_processing_utils'
require_relative 'file_processing_activity'
require_relative 's3_activity'

FileProcessingUtils.new.host_specific_activity_worker.start
