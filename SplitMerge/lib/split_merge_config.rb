require 'yaml'

class SplitMergeConfig

  def initialize(config_file)
    @config = YAML.load_file(config_file)
    class << self
      {
        "bucket_name" => "SplitMerge.Input.BucketName",
        "filename" => "SplitMerge.Input.FileName",
        "number_of_workers" => "SplitMerge.Input.NumberOfWorkers"
      }.each_pair do |key, mapping_key|
        define_method(key) { @config[mapping_key] }
      end
    end
  end

end
