require_relative '../../utils'
require 'socket'

class FileProcessingUtils
  include SharedUtils

  WF_VERSION = "1.0"
  S3_ACTIVITY_VERSION = "1.0"
  FILE_ACTIVITY_VERSION = "1.0"

  WF_TASKLIST = "file_workflow_tasklist"
  ACTIVITY_TASKLIST = "common_tasklist"
  DOMAIN = "FileProcessing"

  LOCAL_DIR = "/tmp/"
  SOURCE_FILENAME = "test_image.jpg"
  SOURCE_BUCKET = "swfconsole"
  TARGET_FILENAME = "file_processing_sample.zip"
  TARGET_BUCKET = "<enter_your_bucket_name_here>"

  def initialize
    @domain = setup_domain(DOMAIN)
  end

  def common_activity_worker
    worker = build_generic_activity_worker(@domain, ACTIVITY_TASKLIST)
    worker.add_implementation(S3Activity.new(LOCAL_DIR, Socket.gethostname))
    worker
  end

  def host_specific_activity_worker
    hostname = Socket.gethostname
    worker = build_generic_activity_worker(@domain, hostname)
    worker.add_implementation(FileProcessingActivity.new(LOCAL_DIR))
    worker.add_implementation(S3Activity.new(LOCAL_DIR, hostname))
    worker
  end

  def workflow_worker
    build_workflow_worker(@domain, FileProcessingWorkflow, WF_TASKLIST)
  end

  def workflow_client
    build_workflow_client(@domain, from_class: "FileProcessingWorkflow")
  end
end
