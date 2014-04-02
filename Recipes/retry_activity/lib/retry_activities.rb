require_relative '../../../utils'

# RetryActivities class provides a set of activities for the retry_activities
# recipe.
class RetryActivities
  extend AWS::Flow::Activities

  activity :unreliable_activity_with_retry_options do
    {
      version: "1.0",
      default_task_list: "activity_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,

      # This activity specifies retry options upon registration.
      exponential_retry: {
        maximum_attempts: 5,
        exceptions_to_retry: [ArgumentError],
      }
    }
  end

  activity :unreliable_activity_without_retry_options do
    {
      version: "1.0",
      default_task_list: "activity_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
   }
  end

  def initialize
    @count = 0
  end

  def unreliable_activity_with_retry_options
    @count += 1
    puts "@count = #{@count} in unreliable activity with retry options\n"
    raise ArgumentError, "Intentional failure count=#{@count}" if @count < 3
  end

  def unreliable_activity_without_retry_options
    @count += 1
    puts "@count = #{@count} in unreliable activity without retry options\n"
    raise ArgumentError, "Intentional failure count=#{@count}" if @count < 3
  end
end
