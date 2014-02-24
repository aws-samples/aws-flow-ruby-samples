require 'aws/decider'

$RUBYFLOW_DECIDER_DOMAIN = "CronWithRetry"
config_file = File.open('credentials.cfg') { |f| f.read }
AWS.config(YAML.load(config_file))

@swf = AWS::SimpleWorkflow.new
if @swf.domains.select { |x| x.name == $RUBYFLOW_DECIDER_DOMAIN }.empty?
          @swf.domains.create($RUBYFLOW_DECIDER_DOMAIN, "10")
end
@domain = @swf.domains[$RUBYFLOW_DECIDER_DOMAIN]
$swf, $domain = @swf, @domain #globalize them for use in tests


# Set up the workflow/activity worker
$activity_task_list = "cron_with_retry_activity_task_list"
$workflow_task_list = "cron_with_retry_workflow_task_list"
