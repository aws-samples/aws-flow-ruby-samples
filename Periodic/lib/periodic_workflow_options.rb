class PeriodicWorkflowOptions

  attr_accessor :execution_period_seconds, :wait_for_activity_completion,
  :continue_as_new_after_seconds, :complete_after_seconds

  def initialize(options)
    options.each_pair { |key, val| self.send("#{key}=", val) }
  end
end
