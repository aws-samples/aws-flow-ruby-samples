The *SplitMerge* sample demonstrates a [parallel split](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-synchronization) followed by a [simple merge](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-simple-merge) workflow pattern. It spawns a number of worker activities which are then merged using `wait_for_all`.

Prerequisites
=============

This sample requires the *AWS Flow Framework for Ruby*, which can be obtained and installed using the information here:

-   [https://aws.amazon.com/swf/flow/](https://aws.amazon.com/swf/flow/)

If you already have [Ruby](https://www.ruby-lang.org/) and [RubyGems](http://rubygems.org/) installed, you can install the framework by opening a terminal window and typing:

~~~~ {.literal-block}
gem install aws-flow
~~~~

For more information about setting up the AWS Flow Framework for Ruby, see [Installing the AWS Flow Framework for Ruby](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/installing.html) in the *AWS Flow Framework for Ruby Developer Guide*.

Download the Sample
===================

Download the sample by clicking the following link:

-   [SplitMerge Sample](https://awsdocs.s3.amazonaws.com/swf/1.0/samples/SplitMerge.zip)

Once you've downloaded the sample `.zip`, unarchive it and make note of the location you've expanded the archive into.

Configure the Sample
====================

This sample requires a little bit of configuration. Open the `split_merge_config.yml` file and edit the following line:

~~~~ {.literal-block}
SplitMerge.Input.BucketName: swf-private-beta-samples
~~~~

Replace the value `swf-private-beta-samples` with an S3 bucket name associated with your AWS account. For more information about how to create S3 buckets, see the [Amazon S3 Getting Started Guide](http://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html)

Run the Sample
==============

**To run the SplitMerge sample:**

1.  Open a terminal window and change to the `lib` directory in the location where you unarchived the sample code. For example:

    ~~~~ {.literal-block}
    cd ~/Downloads/SplitMerge/lib
    ~~~~

1.  Create a file in the `lib` directory called `credentials.cfg` and enter the following text, replacing the strings "insert ... access key here" with your AWS Access Key ID and your Secret Access Key.:

    ~~~~ {.literal-block}
    ---
    :access_key_id: "insert access key here"
    :secret_access_key: "insert secret access key here"
    ~~~~

2.  Execute the following commands on your command-line:

    ~~~~ {.literal-block}
    ruby average_calculator_activity.rb &
    ruby average_calculator_workflow.rb &
    ruby average_calculator_workflow_starter.rb
    ~~~~

    Alternately, you can execute the run\_split\_merge.sh shell script to run all of these commands at once.

For More Information
====================

For more information about the Amazon Simple Workflow service and the Amazon Flow Framework for Ruby, consult the following resources:

-   [AWS Flow Framework for Ruby Developer Guide](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/)
-   [AWS Flow Framework for Ruby API Reference](https://docs.aws.amazon.com/amazonswf/latest/awsrbflowapi/)
-   [AWS Flow Framework](http://aws.amazon.com/swf/flow/)
-   [Amazon Simple Workflow Service](http://aws.amazon.com/swf/)

