This project contains sample code for the AWS Flow Framework for Ruby.

Prerequisites
=============

This sample requires the *AWS Flow Framework for Ruby*, which can be obtained and installed using the information here:

-   [https://aws.amazon.com/swf/flow/](https://aws.amazon.com/swf/flow/)

If you already have [Ruby](https://www.ruby-lang.org/) and [RubyGems](http://rubygems.org/) installed, you can install the framework by opening a terminal window and typing:

~~~~ {.literal-block}
gem install aws-flow
~~~~

For more information about setting up the AWS Flow Framework for Ruby, see [Installing the AWS Flow Framework for Ruby](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/installing.html) in the *AWS Flow Framework for Ruby Developer Guide*.

The Samples
===========

Booking
-------

The *Booking* sample demonstrates a [synchronization](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-synchronization) workflow pattern. It waits for two activities to complete: a car reservation and airline reservation. When both activities complete, it sends a confirmation. All activities are performed asynchronously.

Sample code + description: [Booking](Booking/)

Cron
----

The *Cron* sample runs an activity periodically based on a cron expression.

Sample code + description: [Cron](Cron/)

CronWithRetry
-------------

The *CronWithRetry* sample demonstrates how to run a scheduled task with `exponential_retry` options. Once the workflow is complete, `continue_as_new` is used to re-run the workflow at the next scheduled time.

Sample code + description: [CronWithRetry](CronWithRetry/)

Deployment
----------

The *Deployment* sample illustrates the deployment of a set of application components through a workflow. A YAML configuration file is used to describe the application stack. The workflow takes this description as input and simulates the deployment of the components specified in it.

Sample code + description: [Deployment](Deployment/)

FileProcessing
--------------

The *FileProcessing* sample demonstrates a media processing use case. The workflow downloads a file from an Amazon S3 bucket, creates a `.zip` file and uploads that `.zip` file back to Amazon S3. The task routing feature in Amazon SWF is illustrated in this sample.

Sample code + description: [FileProcessing](FileProcessing/)

HelloWorld
----------

The *HelloWorld* sample uses a very simple workflow that calls an activity to print Hello World. It shows basic usage of the framework, including implementing activities and workflow coordination logic and building workers to run the workflow and activities.

Sample code + description: [HelloWorld](HelloWorld/)

Periodic
--------

The *Periodic* sample periodically executes an activity in a long-running workflow. The ability to continue executions as new executions so that an execution can run for very extended periods of time is demonstrated.

Sample code + description: [Periodic](Periodic/)

SplitMerge
----------

The *SplitMerge* sample demonstrates a [parallel split](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-synchronization) followed by a [simple merge](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-simple-merge) workflow pattern. It spawns a number of worker activities which are then merged using `wait_for_all`.

Sample code + description: [SplitMerge](SplitMerge/)

For More Information
====================

For more information about the Amazon Simple Workflow service and the Amazon Flow Framework for Ruby, consult the following resources:

-   [AWS Flow Framework for Ruby Developer Guide](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/)
-   [AWS Flow Framework for Ruby API Reference](https://docs.aws.amazon.com/amazonswf/latest/awsrbflowapi/)
-   [AWS Flow Framework](http://aws.amazon.com/swf/flow/)
-   [Amazon Simple Workflow Service](http://aws.amazon.com/swf/)

