
require 'aws/decider'

$RUBYFLOW_DECIDER_DOMAIN = "Booking"
config_file = File.open('credentials.cfg') { |f| f.read }
AWS.config(YAML.load(config_file))

@swf = AWS::SimpleWorkflow.new
if @swf.domains.select { |x| x.name == $RUBYFLOW_DECIDER_DOMAIN }.empty?
          @swf.domains.create($RUBYFLOW_DECIDER_DOMAIN, "10")
end
@domain = @swf.domains[$RUBYFLOW_DECIDER_DOMAIN]
$swf, $domain = @swf, @domain #globalize them for use in tests


# Set up the workflow/activity worker
$workflow_task_list = "booking_workflow_task_list"
$activity_task_list = "booking_activity_task_list"


