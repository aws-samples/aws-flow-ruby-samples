require_relative 'spec_helper'

describe DeploymentWorkflow do
  @activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $activity_task_list, DeploymentActivity)
  @workflow_worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, DeploymentWorkflow)
  @activity_worker.register
  @workflow_worker.register

  deployment_workflow_client = workflow_client($swf.client, $domain) { {:from_class => "DeploymentWorkflow"} }    
  configuration_file = "Deployment/spec/application_stack_test.yml"

  $forking_executor = ForkingExecutor.new(:max_workers => 3)
  $forking_executor.execute { @workflow_worker.start }
  $forking_executor.execute { @activity_worker.start }

  $workflow_execution = deployment_workflow_client.start_execution(configuration_file) 

  sleep 5 until ["WorkflowExecutionCompleted", "WorkflowExecutionTimedOut", "WorkflowExecutionFailed"].include? $workflow_execution.events.to_a.last.event_type

  after(:all) do
    $forking_executor.shutdown(1)    
  end

  describe "Workflow History" do

    let(:events) { $workflow_execution.events }
    let(:scheduled_activities) { events.to_a.map { |event| event.attributes.activity_type.name if event.event_type == "ActivityTaskScheduled"}.compact }

    it "should complete successfully" do
      events.to_a.last.event_type.should == "WorkflowExecutionCompleted"
    end

    it "should have 7 completed activities" do
      scheduled_activities.count.should == 7
    end

    it "should schedule activities in right order" do
      expected_trace = [["DeploymentActivity.deploy_database", "DeploymentActivity.deploy_database", "DeploymentActivity.deploy_database",
                        "DeploymentActivity.deploy_app_server", "DeploymentActivity.deploy_app_server",
                        "DeploymentActivity.deploy_web_server", "DeploymentActivity.deploy_load_balancer"]]

      expected_trace.should include scheduled_activities
    end
  end

end

