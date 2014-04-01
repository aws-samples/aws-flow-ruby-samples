require 'aws/decider'

class HelloWorldUtils
  WF_VERSION = "1.0"
  ACTIVITY_VERSION = "1.0"
  WF_TASKLIST = "workflow_tasklist"
  ACTIVITY_TASKLIST = "activity_tasklist"
  DOMAIN = "HelloWorld"

  def initialize
    swf = AWS::SimpleWorkflow.new
    @domain = swf.domains[DOMAIN]
    unless @domain.exists?
      @domain = swf.domains.create(DOMAIN, 10)
    end
  end

  def activity_worker
    AWS::Flow::ActivityWorker.new(@domain.client, @domain, ACTIVITY_TASKLIST, HelloWorldActivity)
  end

  def workflow_worker
    AWS::Flow::WorkflowWorker.new(@domain.client, @domain, WF_TASKLIST, HelloWorldWorkflow)
  end

  def workflow_client
    AWS::Flow::workflow_client(@domain.client, @domain) { {from_class: "HelloWorldWorkflow"} }
  end
end
