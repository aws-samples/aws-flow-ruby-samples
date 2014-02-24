#!/bin/bash
ruby error_reporting_activity.rb &
ruby periodic_activity.rb &
ruby periodic_workflow.rb &
ruby periodic_workflow_starter.rb
