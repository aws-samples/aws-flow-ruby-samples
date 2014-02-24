require 'yaml'

require_relative 'utils.rb'
require_relative 'deployment_activity.rb'
require_relative 'deployment_types.rb'

class DeploymentWorkflow
  extend AWS::Flow::Workflows

  workflow :deploy do
    {
      :version => "1.0",
      :task_list => $workflow_task_list,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:deployment_activities) { {:from_class => "DeploymentActivity"} }

  def deploy(configuration_file)
    deployment_config = YAML.load_file configuration_file
    components_config = deployment_config["application_stack"]["components"]

    # Create all the components
    # create databases
    databases = Hash.new
    components_config["database"].each { |database| databases[database["id"].to_sym] = Database.new(database["host"]) }

    # create app servers
    app_servers = Hash.new
    components_config["app_server"].each { |app_server| app_servers[app_server["id"].to_sym] = AppServer.new(app_server["host"], extract_keys(app_server["database"], databases)) }

    # create web servers
    web_servers = Hash.new
    components_config["web_server"].each { |web_server| web_servers[web_server["id"].to_sym] = WebServer.new(web_server["host"], extract_keys(web_server["database"], databases), extract_keys(web_server["app_server"], app_servers)) }

    # create load balancers
    load_balancers = Hash.new
    components_config["load_balancer"].each { |load_balancer| load_balancers[load_balancer["id"].to_sym] = LoadBalancer.new(load_balancer["host"], extract_keys(load_balancer["web_server"], web_servers)) }

    # Create the frontend components
    frontend_config = deployment_config["application_stack"]["frontend_component"]
    frontend_component = frontend_config.map {|id| load_balancers[id.to_sym] if load_balancers.key? id.to_sym}

    application_stack = ApplicationStack.new(databases.values.concat(app_servers.values).concat(web_servers.values).concat(load_balancers.values), frontend_component, deployment_activities)
    application_stack.deploy

  end

  def extract_keys(components, hash)
    components.map { |id| hash[id.to_sym] if hash.key? id.to_sym }
  end
end

worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, DeploymentWorkflow)

worker.start if __FILE__ == $0
