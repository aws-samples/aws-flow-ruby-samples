require 'aws/decider'

$HELLOWORLD_DOMAIN = "HelloWorld"
config_file = File.open('credentials.cfg') { |f| f.read }
AWS.config(YAML.load(config_file))

@swf = AWS::SimpleWorkflow.new

begin
  @domain = @swf.domains.create($HELLOWORLD_DOMAIN, "10")
rescue AWS::SimpleWorkflow::Errors::DomainAlreadyExistsFault => e
  @domain = @swf.domains[$HELLOWORLD_DOMAIN]
end

$swf, $domain = @swf, @domain
# Set up the workflow/activity worker
$task_list = "hello_world_task_list"
