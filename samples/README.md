AWS Flow Framework for Ruby Samples
===================================

This directory contains the AWS Flow Framework for Ruby *Samples*.

These samples demonstrate many of the features of the AWS Flow Framework
for Ruby, as described in the [AWS Flow Framework for Ruby Developer
Guide](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/) and
the [AWS Flow Framework for Ruby API
Reference](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowapi/).

The following samples are provided:

booking
-------

The *Booking* sample demonstrates a
[synchronization](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-synchronization)
workflow pattern. It waits for two activities to complete: a car
reservation and airline reservation. When both activities complete, it
sends a confirmation. All activities are performed asynchronously.

Code + info: [booking](booking/)

cron
----

The *Cron* sample runs an activity periodically based on a cron
expression.

Code + info: [cron](cron/)

cron_with_retry
-----------------

The *CronWithRetry* sample demonstrates how to run a scheduled task with
`exponential_retry` options. Once the workflow is
complete, `continue_as_new` is used to re-run the
workflow at the next scheduled time.

Code + info: [cron_with_retry](cron_with_retry/)

deployment
----------

The *Deployment* sample illustrates the deployment of a set of
application components through a workflow. A YAML configuration file is
used to describe the application stack. The workflow takes this
description as input and simulates the deployment of the components
specified in it.

Code + info: [deployment](deployment/)

file_processing
----------------

The *FileProcessing* sample demonstrates a media processing use case.
The workflow downloads a file from an Amazon S3 bucket, creates a
`.zip` file and then uploads the file back to Amazon
S3. The task routing feature in Amazon SWF is illustrated in this
sample.

Code + info: [file_processing](file_processing/)

hello_world
------------

The *HelloWorld* sample uses a very simple workflow that calls an
activity to print Hello World. It shows basic usage of the framework,
including implementing activities and workflow coordination logic and
building workers to run the workflow and activities.

Code + info: [hello_world](hello_world/)

periodic
--------

The *Periodic* sample periodically executes an activity in a
long-running workflow. The ability to continue executions as new
executions so that an execution can run for very extended periods of
time is demonstrated.

Code + info: [periodic](periodic/)

split_merge
------------

The *SplitMerge* sample demonstrates a [parallel
split](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-synchronization)
followed by a [simple
merge](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-simple-merge)
workflow pattern. It spawns a number of worker activities which are then
merged using `wait_for_all`.

Code + info: [split_merge](split_merge/)
