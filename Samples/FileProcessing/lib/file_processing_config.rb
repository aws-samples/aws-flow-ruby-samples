require 'yaml'

class FileProcessingConfig

  def initialize(config_file)
    @config = YAML.load_file(config_file)
    class << self
      {
        "local_folder" => "Activity.Worker.LocalFolder",
        "source_filename" => "Workflow.Input.SourceFileName",
        "source_bucket_name" => "Workflow.Input.SourceBucketName",
        "target_filename" => "Workflow.Input.TargetFileName",
        "target_bucket_name" => "Workflow.Input.TargetBucketName"
      }.each_pair do |key, mapping_key|
        define_method(key) { @config[mapping_key] }
      end
    end
  end

end


