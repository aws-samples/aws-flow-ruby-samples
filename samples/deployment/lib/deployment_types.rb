# Copyright 2014-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module Deployable
  attr_accessor :host, :depends_on, :url

  def initialize(host, depends_on, url)
    @host = host
    @depends_on = depends_on
    @url = url
  end

  def deploy(activity_client)
    deployable_urls = depends_on.map(&:url) unless depends_on
    task do
      wait_for_all(deployable_urls) unless deployable_urls
      url.set(deploy_self(activity_client))
    end
  end

  def deploy_self(activity_client)
    raise "Fill me in inside a sublass for polymorphic magic!"
  end

  protected

  def extract_urls(hosts)
    return nil unless hosts

    hosts.each_with_object( [] ) do |host, urls|
      urls << host.url.get if host.url.is_a? Future
    end
  end
end

class LoadBalancer
  include Deployable

  attr_accessor :web_servers

  def initialize(host, web_servers)
    super host, web_servers, Future.new
    @web_servers = web_servers
  end

  def deploy_self(activity_client)
    web_server_urls = extract_urls(web_servers)
    activity_client.deploy_load_balancer(web_server_urls)
  end

end

class AppServer
  include Deployable

  attr_accessor :databases

  def initialize(host, databases)
    super host, databases, Future.new
    @databases = databases
  end

  def deploy_self(activity_client)
    data_sources = extract_urls(databases)
    activity_client.deploy_app_server(data_sources)
  end
end

class WebServer
  include Deployable
  attr_accessor :databases, :app_servers

  def initialize(host, databases, app_servers)
    super host, databases.concat(app_servers), Future.new
    @databases = databases
    @app_servers = app_servers
  end

  def deploy_self(activity_client)
    data_sources = extract_urls(databases)
    app_server_urls = extract_urls(app_servers)

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
    components.each do |component|
      component.deploy(activity_client) if component.is_a? Deployable
    end
  end

  def get_url
    frontend.url
  end
end
