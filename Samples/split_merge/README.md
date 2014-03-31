AWS Flow Framework for Ruby: SplitMerge Sample Application
==========================================================

The *SplitMerge* sample demonstrates a [parallel
split](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-synchronization)
followed by a [simple
merge](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-simple-merge)
workflow pattern. It spawns a number of worker activities which are then
merged using `wait_for_all`.

Prerequisites
-------------

The *AWS Flow Framework for Ruby* is required, which can be obtained and
installed using the information here:

-   [https://aws.amazon.com/swf/flow/](https://aws.amazon.com/swf/flow/)

If you already have [Ruby](https://www.ruby-lang.org/) and
[RubyGems](http://rubygems.org/) installed, you can install the
framework by opening a terminal window and typing:

~~~~
gem install aws-flow
~~~~

For more information about setting up the AWS Flow Framework for Ruby,
see [Installing the AWS Flow Framework for
Ruby](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/installing.html)
in the *AWS Flow Framework for Ruby Developer Guide*.

Downloading the Sample Code
---------------------------

To view or download the code for all of the AWS Flow Framework for Ruby
recipes and samples, go to:

-   [https://github.com/awslabs/aws-flow-ruby-samples](https://github.com/awslabs/aws-flow-ruby-samples)

Configure the Sample
--------------------

This sample requires a little bit of configuration. Open the
`split_merge_config.yml` file and edit the following
line:

~~~~
SplitMerge.Input.BucketName: swf-private-beta-samples
~~~~

Replace the value `swf-private-beta-samples` with an
S3 bucket name associated with your AWS account. For more information
about how to create S3 buckets, see the [Amazon S3 Getting Started
Guide](http://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html)

Run the Sample
--------------

**To run the SplitMerge sample:**

1.  Open *three* separate terminal windows and, in each one, change to
    the `lib` directory in the location where you
    cloned or unarchived the sample code. For example:

    ~~~~
    cd ~/Downloads/aws-flow-ruby-samples/Samples/split_merge/lib
    ~~~~

2.  In each command-line (terminal) window, execute the following
    commands, substituting your AWS Access keys for the example values.

    On Linux, OS X or Unix:

    ~~~~
    export AWS_ACCESS_KEY_ID='your-access-key'
    export AWS_SECRET_ACCESS_KEY='your-secret-key'
    export AWS_REGION='your-aws-region'
    ~~~~

    On Windows:

    ~~~~
    set AWS_ACCESS_KEY_ID=your-access-key
    set AWS_SECRET_ACCESS_KEY=your-secret-key
    set AWS_REGION=your-aws-region
    ~~~~

3.  Execute the following commands, one in each of the terminal windows:

    ~~~~
    ruby average_calculator_activity.rb

    ruby average_calculator_workflow.rb

    ruby average_calculator_workflow_starter.rb
    ~~~~

For More Information
--------------------

For more information about the Amazon Simple Workflow service and the
Amazon Flow Framework for Ruby, consult the following resources:

-   [AWS Flow Framework for Ruby Developer
    Guide](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/)
-   [AWS Flow Framework for Ruby API
    Reference](https://docs.aws.amazon.com/amazonswf/latest/awsrbflowapi/)
-   [AWS Flow Framework](http://aws.amazon.com/swf/flow/)
-   [Amazon Simple Workflow Service](http://aws.amazon.com/swf/)

