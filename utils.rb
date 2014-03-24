require 'bundler/setup'
require 'aws/decider'
require 'logger'

# These are utilities that are common to all samples and recipes
module SharedUtils

  def setup_domain(domain_name)
    swf = AWS::SimpleWorkflow.new
    domain = swf.domains[domain_name]
    unless domain.exists?
        swf.domains.create(domain_name, 10)
    end
    domain
  end

  def build_workflow_worker(domain, klass, task_list)
    AWS::Flow::WorkflowWorker.new(domain.client, domain, task_list, klass)
  end

  def build_generic_activity_worker(domain, task_list)
    AWS::Flow::ActivityWorker.new(domain.client, domain, task_list)
  end

  def build_activity_worker(domain, klass, task_list)
    AWS::Flow::ActivityWorker.new(domain.client, domain, task_list, klass)
  end

  def build_workflow_client(domain, options_hash)
    AWS::Flow::workflow_client(domain.client, domain) { options_hash }
  end
end
