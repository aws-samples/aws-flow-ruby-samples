require 'aws/decider'

require_relative 'split_merge_config'
require_relative 'utils'
require_relative 'average_calculator_workflow.rb'

include AWS::Flow

config = SplitMergeConfig.new(File.join(File.dirname(__FILE__), "split_merge_config.yml"))

puts "Starting an execution..."
my_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "AverageCalculatorWorkflow"} }
workflow_execution = my_workflow_client.start_execution(config.bucket_name, config.filename, config.number_of_workers.to_i)

