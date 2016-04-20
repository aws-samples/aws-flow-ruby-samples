# Copyright 2014-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../utils'

class PeriodicUtils
  include SharedUtils

  WF_VERSION = "1.0"
  ACTIVITY_VERSION = "1.0"
  ERROR_ACTIVITY_VERSION = "1.0"
  WF_TASKLIST = "periodic_workflow_tasklist"
  ACTIVITY_TASKLIST = "periodic_activity_tasklist"
  ERROR_ACTIVITY_TASKLIST = "error_activity_tasklist"
  DOMAIN = "Periodic"

  def initialize
    @domain = setup_domain(DOMAIN)
  end

  def periodic_activity_worker
    build_activity_worker(@domain, PeriodicActivity, ACTIVITY_TASKLIST)
  end

  def error_activity_worker
    build_activity_worker(@domain, ErrorReportingActivity, ERROR_ACTIVITY_TASKLIST)
  end

  def workflow_worker
    build_workflow_worker(@domain, PeriodicWorkflow, WF_TASKLIST)
  end

  def workflow_client
    build_workflow_client(@domain, from_class: "PeriodicWorkflow")
  end
end
