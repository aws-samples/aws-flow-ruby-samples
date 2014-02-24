require_relative 'utils'

class HumanTaskConsole

  def run
    task_token = get_task_token
    result = get_result

    puts "task_token:#{task_token}"
    puts "result:#{result}"
    $swf.client.respond_activity_task_completed({
        :task_token => "#{task_token}",
        :result => "#{result}"
      })
  end

  def get_task_token
    puts "Enter the token of the task to compelete:"
    token = $stdin.gets.chomp
  end

  def get_result
    puts "Enter the result of the task:"
    result = $stdin.gets.chomp
  end
end

HumanTaskConsole.new.run if __FILE__ == $0
