require_relative '../../recipe_activities'

# WaitForSignalWorkflow class defines a workflow for the wait_for_signal 
# recipe. This recipe shows how to use the signal feature of SimpleWorkflow.
class WaitForSignalWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :place_order do
    {
      version: "1.0",
      task_list: "wait_for_signal_workflow",
      execution_start_to_close_timeout: 60,
      task_start_to_close_timeout: 20,
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:client) { { from_class: "RecipeActivity" } }

  # Use the signal method provided by the flow framework to assign the method
  # that will be called when a signal is recieved by this workflow
  signal :change_order

  def initialize
    @change_order_period = 30
    @signal_received = Future.new
  end

  # This is the entry point for the workflow
  def place_order(original_amount)

    # We will create an asynchronous timer to give the customer some grace 
    # period to change the order
    timer = create_timer_async(@change_order_period)

    # wait_for_any will block until atleast one of the futures in the enumerable
    # collection that it is given is ready. Here we will wait on the timer
    # future and the future that is waiting for a signal to be received.
    wait_for_any(timer, @signal_received)

    # Once either the grace period is over or a signal is received, we will
    # continue our execution. Set the amount to be processed to either the
    # original amount or the signal amount based on whether a signal was
    # received or not.
    amount = if @signal_received.set?
               @signal_received.get
             else
               original_amount
             end

    # Use the activity client to call the process activity
    client.process(amount)
  end

  # This method will be called when a signal is received
  def change_order(amount)
    # We will set the value of the @signal_received future with the amount
    # passed to the  method with the signal
    @signal_received.set(amount) unless @signal_received.set?
  end
end
