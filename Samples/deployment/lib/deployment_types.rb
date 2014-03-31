module Deployable
  attr_accessor :host, :depends_on, :url

  def initialize(host, depends_on, url)
    @host = host
    @depends_on = depends_on
    @url = url
  end

  def deploy(activity_client)
    deployable_urls = @depends_on.map {|x| x.url } unless @depends_on.nil?
    task do
      wait_for_all(deployable_urls) unless deployable_urls.nil?
      url.set(deploy_self(activity_client))
    end
  end

  def deploy_self(activity_client)
    # Fill me in inside a sublass for polymorphic magic!
  end
end

class LoadBalancer
  include Deployable

  attr_accessor :web_servers
  def initialize(host, web_servers)
    @webservers = web_servers
    super host, web_servers, Future.new
  end

  def deploy_self(activity_client)
    web_server_urls = @web_servers.map { |x|
      x.url.get if x.url.is_a? Future
    }.compact unless @web_servers.nil?

    activity_client.deploy_load_balancer(web_server_urls)
  end

end

class AppServer
  include Deployable

  attr_accessor :databases

  def initialize(host, databases)
    @databases = databases
    super host, databases, Future.new
  end

  def deploy_self(activity_client)
    data_sources = @databases.map { |x|
      x.url.get if x.url.is_a? Future
    }.compact unless @databases.nil?

    activity_client.deploy_app_server(data_sources)
  end
end

class WebServer
  include Deployable
  attr_accessor :databases, :app_servers

  def initialize(host, databases, app_servers)
    @databases = databases
    @app_servers = app_servers
    super host, databases.concat(app_servers), Future.new
  end

  def deploy_self(activity_client)
    data_sources = @databases.map { |x|
      x.url.get if x.url.is_a? Future
    }.compact unless @databases.nil?

    app_server_urls = @app_servers.map { |x|
      x.url.get if x.url.is_a? Future
    }.compact unless @app_servers.nil?

    activity_client.deploy_web_server(data_sources, app_server_urls)
  end
end

class Database
  include Deployable

  def initialize(host)
    super host, nil, Future.new
  end

  def deploy_self(activity_client)
    activity_client.deploy_database
  end
end

class ApplicationStack

  attr_accessor :components, :frontend, :activity_client
  def initialize(types)
    @components = types[:components]
    @frontend = types[:frontend]
    @activity_client = types[:activity_client]
  end

  def deploy
    @components.each { |x|
      x.deploy(@activity_client) if x.is_a? Deployable
    }
  end

  def get_url
    @frontend.url
  end
end
