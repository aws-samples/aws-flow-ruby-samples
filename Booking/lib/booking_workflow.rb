
require_relative 'utils.rb'
require_relative 'booking_activity.rb'

class BookingWorkflow
  extend AWS::Flow::Workflows

  workflow :make_booking do 
    {
      :version => "1.0",
      :task_list => $workflow_task_list,
      :execution_start_to_close_timeout => 120 
    }
  end

  activity_client(:activity){ {:from_class => "BookingActivity"} }

  def make_booking(requestId, customerId, is_reserve_air, is_reserve_car)
    car_future = Future.new.set
    air_future = Future.new.set
    car_future = activity.send_async(:reserve_car, requestId) if is_reserve_car
    air_future = activity.send_async(:reserve_airline, requestId) if is_reserve_air

    wait_for_all(car_future, air_future)
    activity.send_async(:send_confirmation, customerId)
  end
end

worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, BookingWorkflow)

worker.start if __FILE__ == $0


