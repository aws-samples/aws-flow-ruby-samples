require_relative '../../recipe_activities'

# Shows how to use signals in SWF
class WaitForSignalWorkflow
  extend AWS::Flow::Workflows

  # define the workflow entry point.
  workflow :place_order do
    {
      version: "1.0",
      task_list: "wait_for_signal_workflow",
      execution_start_to_close_timeout: 60,
      task_start_to_close_timeout: 20,
    }
  end

  # Create an activity client used to schedule activities
  activity_client(:client) { { from_class: "RecipeActivity" } }

  # assign a method that will be called if a signal is received by the workflow
  signal :change_order

  def initialize
    @change_order_period = 30
    @signal_received = Future.new
  end

  # the entry point for the workflow
  def place_order(original_amount)

    # create an asynchronous timer to give the customer time to change the order
    timer = create_timer_async(@change_order_period)

    # blocks until the timer is set or a signal is received.
    wait_for_any(timer, @signal_received)

    # run the final activity.
    process_order(original_amount)
  end

  def process_order(original_amount)
    # process the original amount or the signal amount (if a signal was
    # received)
    amount = original_amount
    amount = @signal_received.get if @signal_received.set?
    # schedule the process activity
    client.process(amount)
  end

  # called when a signal is received
  def change_order(amount)
    # set the @signal_received future with the amount
    @signal_received.set(amount) unless @signal_received.set?
  end
end
