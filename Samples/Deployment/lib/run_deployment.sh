#!/bin/bash
ruby deployment_activity.rb &
ruby deployment_workflow.rb &
ruby deployment_workflow_starter.rb
