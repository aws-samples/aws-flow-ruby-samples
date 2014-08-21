require_relative '../splitmerge_utils'
require_relative 'splitmerge_activity'

# SplitMergeWorkflow class defines the workflows for the SplitMerge sample
class SplitMergeWorkflow
  extend AWS::Flow::Workflows

  workflow :average do
    {
      version: SplitMergeUtils::WF_VERSION,
      defalt_task_list: SplitMergeUtils::WF_TASKLIST,
      default_execution_start_to_close_timeout: 360
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "SplitMergeActivity" } }

  # This is the entry point for the workflow
  def average(options)
    puts "Workflow has started" unless is_replaying?

    # Select out the options that need to be passed to activities in a separate
    # hash
    activity_options = options.select do |key, value|
      [:bucket, :filename].include?(key)
    end

    puts "Calling compute_size activity" unless is_replaying?
    # Use the activity client to call the compute_size activity
    size = client.compute_size(activity_options)


    # Add chunk_size as an activity option
    activity_options[:chunk_size] = size/options[:fleet_size]

    # This array will hold all futures that are created when the activities are
    # scheduled asynchronously
    results = Array.new

    # Split section
    for i in 0..(options[:fleet_size]-1)
      # Use the send_async method of activity client to call the
      # partial_sum activity asynchronously and store the futures in the
      # results array
      puts "Calling partial_sum activity for chunk #{i}" unless is_replaying?
      results << client.send_async(:partial_sum, activity_options, i)
    end

    # Wait for all futures to be ready before proceeding
    wait_for_all(results)

    # Merge section

    puts "Merge all results" unless is_replaying?
    # Once all the partial sums are ready, we will merge the results and compute
    # average.
    # This gets the result from each future and computes the sum
    sum = results.map! { |x| x.get }.reduce(:+)

    puts "Reporting the results" unless is_replaying?
    # Use the activity client to call the report_result activity
    client.report_result(sum.to_f/size.to_f)

    puts "Workflow has completed" unless is_replaying?
  end

  # Helper method to check if Flow is replaying the workflow. This is used to
  # avoid duplicate log messages
  def is_replaying?
    decision_context.workflow_clock.replaying
  end

end

# Start a WorkflowWorker to work on the SplitMergeWorkflow tasks
SplitMergeUtils.new.workflow_worker.start if $0 == __FILE__
