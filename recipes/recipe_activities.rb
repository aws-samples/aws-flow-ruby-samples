require_relative '../utils'

# RecipeActivity class contains a group of activities that are common to a
# bunch of recipes in this directory. 
class RecipeActivity
  extend AWS::Flow::Activities

  activity :activity_1, :activity_2, :report_results, :get_input, :get_choice, 
    :get_multi_choice, :get_count, :process do
    {
      version: "1.0",
      default_task_list: "activity_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
    }
  end

  def activity_1
    puts "activity: activity_1"
    1
  end

  def activity_2
    puts "activity: activity_2"
    2
  end

  def report_results(value)
    puts "reporting result: #{value}"
  end
  
  def get_input
    puts "activity: get_input"
    "input"
  end

  def get_choice
    puts "activity: get_choice"
    :input_1
  end

  def get_multi_choice
    puts "activity: get_multi_choice"
    [:input_1, :input_2]
  end
  
  def get_count
    puts "activity: get_count"
    10
  end

  def process(i)
    puts "activity: process #{i}"
  end

end
