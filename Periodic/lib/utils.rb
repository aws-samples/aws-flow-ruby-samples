require 'aws/decider'

$RUBYFLOW_DECIDER_DOMAIN = "Periodic"
config_file = File.open('credentials.cfg') { |f| f.read }
AWS.config(YAML.load(config_file))

$swf = AWS::SimpleWorkflow.new

begin
  $domain = $swf.domains.create($RUBYFLOW_DECIDER_DOMAIN, "10")
rescue AWS::SimpleWorkflow::Errors::DomainAlreadyExistsFault => e
  $domain = $swf.domains[$RUBYFLOW_DECIDER_DOMAIN]
end

# Set up the workflow/activity worker
$workflow_task_list = "periodic_workflow_task_list"
$periodic_activity_task_list = "periodic_activity_task_list"
$error_reporting_activity_task_list = "error_reporting_activity_task_list"
