# In order to build this package, you will have to either add library code in
# lib/, or remove the "Brazil::LibraryPackageTask.new" line below.
#
# For general help with Ruby packages, see
# https://w.amazon.com/index.php/Ruby/QuickStart
#
# For help with Brazil Rakefiles, see
# https://w.amazon.com/index.php/BrazilRake

require "rspec/core/rake_task"

@samples = [:booking, :deployment, :hello_world, :file_processing, :split_merge, :cron, :periodic, :cron_with_retry]

@samples.each do |sample|
  RSpec::Core::RakeTask.new(sample) do |spec|
    spec.rspec_opts = ['--color', '--format nested']
    spec.pattern = "#{sample.to_s.gsub('_', ' ').split.map(&:capitalize).join}/spec/*.rb"
  end
end

# The following rake task will run each of the rspec rake tasks defined above serially
task :all_tests do
  @samples.each do |sample|
    Rake::Task[sample].execute
  end
end
