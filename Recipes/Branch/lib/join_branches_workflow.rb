require_relative 'utils'
require_relative 'branch_activities'

class JoinBranchesWorkflow
    extend AWS::Flow::Workflows

    workflow :parallel_computing do
        {
            :version => "1.0",
            :task_list => $WORKFLOW_TASK_LIST,
            :execution_start_to_close_timeout => 120,
        }
    end

    activity_client(:client){ {:from_class => "BranchActivities"} }

    def parallel_computing(number_of_branches)

        results = (1..number_of_branches).map { client.send_async(:do_some_work) }
        
        wait_for_all(*results)
        sum = join_branches(results)
        client.send(:report_result, sum)
    end

    def join_branches(results)
      results.map(&:get).reduce(0, :+)
    end
end
