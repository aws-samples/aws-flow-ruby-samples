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

  # Use the signal method to assign a method that will be called when a signal
  # is received by this workflow
  signal :change_order

  def initialize
    @change_order_period = 30
    @signal_received = Future.new
  end

  # the entry point for the workflow
  def place_order(original_amount)

    # create an asynchronous timer to give the customer some grace period to
    # change the order
    timer = create_timer_async(@change_order_period)

    # blocks until the timer is set. Here we will wait on the timer
    # future and the future that is waiting for a signal to be received.
    wait_for_any(timer, @signal_received)

    # Once the grace period is over (or a signal is received), run the final
    # activity.
    process_order(original_amount)
  end

  def process_order(original_amount)
    # The amount to be processed will be either the original amount or the
    # signal amount depending upon whether a signal was received.
    amount = original_amount
    amount = @signal_received.get if @signal_received.set?
    # schedule the process activity
    client.process(amount)
  end

  # called when a signal is received
  def change_order(amount)
    # set the value of the @signal_received future with the amount passed to the
    # method with the signal
    @signal_received.set(amount) unless @signal_received.set?
  end
end
