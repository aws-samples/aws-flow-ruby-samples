require 'aws/decider'
include AWS::Flow

require_relative '../lib/utils'
require_relative '../lib/resource_management_activities'
require_relative '../lib/clean_up_resource_workflow'
require_relative '../lib/handle_error_workflow'
