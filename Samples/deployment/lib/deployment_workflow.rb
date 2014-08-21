require 'yaml'

require_relative '../deployment_utils'
require_relative 'deployment_activity'
require_relative 'deployment_types'

# DeploymentWorkflow class defines the workflows for the Deployment sample
class DeploymentWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :deploy do
    {
      version: DeploymentUtils::WF_VERSION,
      default_task_list: DeploymentUtils::WF_TASKLIST,
      default_execution_start_to_close_timeout: 120,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "DeploymentActivity" } }

  # This is the entry point for the workflow
  def deploy(configuration_file)

    puts "Workflow has started\n" unless is_replaying?
    puts "Loading deployment configuration\n" unless is_replaying?

    deployment_config = YAML.load_file configuration_file
    config = deployment_config["application_stack"]["components"]
    frontend_config = deployment_config["application_stack"]["frontend"]

    # Create all components
    # create databases
    puts "Building databases\n" unless is_replaying?
    databases = build_databases(config["database"])

    # create app servers
    puts "Building app servers\n" unless is_replaying?
    app_servers = build_app_servers(config["app_server"], databases)

    # create web servers
    puts "Building web servers\n" unless is_replaying?
    web_servers =  build_web_servers(config["web_server"], databases, app_servers)

    # create load balancers
    puts "Building load balancers\n" unless is_replaying?
    load_balancers = build_load_balancers(config["load_balancer"], web_servers)

    # Create the frontend components
    puts "Building frontend\n" unless is_replaying?
    frontend = build_frontend(frontend_config, load_balancers)

    components = [databases, app_servers, web_servers, load_balancers]

    # Create the application stack
    application_stack = ApplicationStack.new( {
      components: components.map! { |t| t = t.values }.flatten!,
      frontend: frontend,
      activity_client: client
    })

    # Deploy the stack
    application_stack.deploy

  end

  # Helper method used to create Database objects from a database config
  def build_databases databases
    result = {}
    databases.each do |database|
      result[database["id"].to_sym] = Database.new(database["host"])
    end
    result
  end

  # Helper method used to create AppServer objects from an app server config
  def build_app_servers(app_servers, databases)
    result = {}
    app_servers.each do |app_server|
      result[app_server["id"].to_sym] = AppServer.new(
        app_server["host"], extract_keys(app_server["database"], databases))
    end
    result
  end

  # Helper method used to create WebServer objects from web server config
  def build_web_servers(web_servers, databases, app_servers)
    result = {}
    web_servers.each do |web_server|
      result[web_server["id"].to_sym] = WebServer.new( web_server["host"],
        extract_keys(web_server["database"], databases),
        extract_keys(web_server["app_server"], app_servers))
    end
    result
  end

  # Helper method used to create LoadBalancer objects from a load balancer config
  def build_load_balancers(load_balancers, web_servers)
    result = {}
    load_balancers.each do |load_balancer|
      result[load_balancer["id"].to_sym] = LoadBalancer.new( load_balancer["host"],
        extract_keys(load_balancer["web_server"], web_servers))
    end
    result
  end

  # Helper method used to create frontend from a load balancer config
  def build_frontend(frontends, load_balancers)
    extract_keys(frontends, load_balancers)
    #frontends.map {|id| load_balancers[id.to_sym] if load_balancers.key? id.to_sym}
  end

  def extract_keys(components, hash)
    components.map { |id| hash[id.to_sym] if hash.key? id.to_sym }
  end

  # Helper method to check if Flow is replaying the workflow. This is used to
  # avoid duplicate log messages
  def is_replaying?
    decision_context.workflow_clock.replaying
  end
end

# Start a WorkflowWorker to work on the DeploymentWorkflow tasks
DeploymentUtils.new.workflow_worker.start if $0 == __FILE__
