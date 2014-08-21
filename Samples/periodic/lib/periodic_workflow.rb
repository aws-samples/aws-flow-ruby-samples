require_relative '../periodic_utils'
require_relative "periodic_activity"
require_relative "error_reporting_activity"

# PeriodicWorkflow class defines the workflows for the Periodic sample
class PeriodicWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :periodic do
    {
      version: PeriodicUtils::WF_VERSION,
      default_task_list: PeriodicUtils::WF_TASKLIST,
      default_execution_start_to_close_timeout: 120
    }
  end

  # Create activity clients using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "PeriodicActivity" } }
  activity_client(:error_report) { { from_class: "ErrorReportingActivity" } }

  # This is the entry point for the workflow
  def periodic(options)

    puts "Workflow has started" unless is_replaying?
    # Get the start time from the workflow_clock. get_current_time is a method
    # definied in this workflow that gets a workflow_clock object from the
    # decision_context
    start_time = get_current_time

    # error_handler is a flow construct that should be used for error handling
    # when scheduling asynchronous activities and workflows. It is modeled after
    # the begin / rescue / ensure pattern.
    error_handler do |t|
      t.begin do
        puts "Running the activity periodically" unless is_replaying?
        run_periodically(options, start_time)
      end

      # This shows how we can use the error_handler for reporting failures and
      # doing cleanup. When we catch an exception from an asynchronous
      # activity/workflow, we can call report_failure activity using the
      # error_report activity client that we created above
      t.rescue AWS::Flow::ActivityTaskFailedException do |e|
        # Call the report_failure activity using the error_report activity
        # client
        unless is_replaying?
          puts "Failure encountered. Calling error reporting activity"
        end
        error_report.report_failure(e)
      end

      t.ensure do
        time_left = options[:completion_secs] - (get_current_time - start_time)

        if (time_left > 0)
          options[:completion_secs] = time_left

          # Use the continue_as_new flow method to continue the workflow as a
          # new workflow. This is very useful in long running workflows with
          # large histories. SimpleWorkflow has a limit of 25K events per
          # workflow.
          puts "Workflow is continuing as new" unless is_replaying?
          continue_as_new(options)
        end
      end
    end
  end

  def run_periodically(options, start_time)
    current_time = get_current_time
    duration = current_time - start_time
    if duration < options[:continue_as_new_secs]
      # Use send_async to schedule an asynchronous activity.
      activity_future = client.send_async(options[:activity_name]) do
        { activity_name: options[:activity_prefix] }
      end

      # Use the create_timer_async method to create an asynchronous timer
      timer_future = create_timer_async(options[:execution_period_secs])

      if options[:wait_for_completion]
        # If the wait_for_completion option is set to true, then we wait on both
        # the timer_future and the activity_future to get set.
        wait_for_all(activity_future, timer_future)
      else
        # If wait_for_completion options is set to false, then we only wait on
        # the timer_future to get set
        wait_for_all(timer_future)
      end

      # Recursively call run_periodically to schedule the activity again
      run_periodically(options, start_time)
    end
  end

  def get_current_time
    # decision_context is a method available to all Workflow classes that extend
    # AWS::Flow::Workflows. It can be used to get the workflow_clock and the
    # current time of the workflow
    decision_context.workflow_clock.replay_current_time_millis
  end

  # Helper method to check if Flow is replaying the workflow. This is used to
  # avoid duplicate log messages
  def is_replaying?
    decision_context.workflow_clock.replaying
  end

end

# Start a WorkflowWorker to work on the PeriodicWorkflow tasks
PeriodicUtils.new.workflow_worker.start if $0 == __FILE__
