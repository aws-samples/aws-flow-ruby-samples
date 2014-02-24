require 'aws/decider'
require 'logger'

$RUBYFLOW_DECIDER_DOMAIN = "Recipes"
config_file = File.open('credentials.cfg') { |f| f.read }
AWS.config(YAML.load(config_file))

@swf = AWS::SimpleWorkflow.new
if @swf.domains.select { |x| x.name == $RUBYFLOW_DECIDER_DOMAIN }.empty?
      @swf.domains.create($RUBYFLOW_DECIDER_DOMAIN, "10")
end
@domain = @swf.domains[$RUBYFLOW_DECIDER_DOMAIN]

$swf, $domain = @swf, @domain #globalize them for use in tests

# Set up the workflow/activity worker
$WORKFLOW_TASK_LIST = "branch_workflow_task_list"
$ACTIVITY_TASK_LIST = "branch_activity_task_list"

$logger = Logger.new(STDOUT)
