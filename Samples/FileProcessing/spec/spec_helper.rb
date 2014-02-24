require 'aws/decider'

include AWS::Flow

require_relative '../lib/utils'
require_relative '../lib/simple_store_s3_activities'
require_relative '../lib/file_processing_activity'
require_relative '../lib/file_processing_workflow'
require_relative '../lib/file_processing_config'
