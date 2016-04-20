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
