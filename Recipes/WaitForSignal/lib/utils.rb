require 'aws/decider'
require 'logger'

$RUBYFLOW_DECIDER_DOMAIN = "Recipes"
config_file = File.open('credentials.cfg') {|f| f.read}
AWS.config(YAML.load(config_file))

@swf = AWS::SimpleWorkflow.new
begin
  @domain = @swf.domains.create($RUBYFLOW_DECIDER_DOMAIN, "10")
rescue AWS::SimpleWorkflow::Errors::DomainAlreadyExistsFault => e
  @domain = @swf.domains[$RUBYFLOW_DECIDER_DOMAIN]
end
$swf, $domain = @swf, @domain #globalize them for use in tests

$WORKFLOW_TASK_LIST = "wait_for_signal_workflow_task_list"
$ACTIVITY_TASK_LIST = "wait_for_signal_activity_task_list"

$logger = Logger.new(STDOUT)
