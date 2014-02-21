require_relative 'utils.rb'

class BookingActivity
  extend AWS::Flow::Activities

  activity :reserve_car, :reserve_airline, :send_confirmation do
    {
      :version => "1.0",
      :default_task_list => $activity_task_list,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30 
    }
  end

  def reserve_car(requestId)
    puts "Reserving car for Request ID:#{requestId} \n"
  end

  def reserve_airline(requestId)
    puts "Reserving airline for Request ID: #{requestId} \n"
  end

  def send_confirmation(customerId)
    puts "Sending notification to customer #{customerId}"
  end
end

activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $activity_task_list, BookingActivity)
activity_worker.start if __FILE__ == $0

