require_relative 'utils.rb'

class DeploymentActivity
  extend AWS::Flow::Activities

  activity :deploy_database, :deploy_app_server, :deploy_web_server, :deploy_load_balancer do
    {
      :version => "1.0",
      :default_task_list => $activity_task_list,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end

  def deploy_database
    puts "deploying database"
    "jdbc:foo/bar"
  end

  def deploy_app_server(data_sources)
    puts "deploying app server"
    "http://baz"
  end

  def deploy_web_server(data_sources, app_servers)
    puts "deploying web server"
    "http://webserver"
  end

  def deploy_load_balancer(web_server_urls)
    puts "deploying load balancer"
    "http://myweb.com"
  end

end

activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $activity_task_list, DeploymentActivity)
activity_worker.start if __FILE__ == $0

