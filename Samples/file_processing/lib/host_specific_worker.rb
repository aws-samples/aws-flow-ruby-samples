require_relative '../file_processing_utils'
require_relative 'file_processing_activity'
require_relative 's3_activity'

# ForkingExecutor is an aws-flow construct that can be used to execute multiple
# processes in parallel. Here we use it to run multiple workers in separate
# processes.
#forking_executor = AWS::Flow::ForkingExecutor.new(:max_workers => 2)
#forking_executor.execute do
FileProcessingUtils.new.host_specific_activity_worker.start
#end
#forking_executor.execute do
  #FileProcessingUtils.new.common_activity_worker.start
#end
