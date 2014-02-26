Configure the Sample
====================

This sample requires a little bit of configuration. Open the
`split_merge_config.yml`{.docutils .literal} file and edit the following
line:

~~~~ {.literal-block}
SplitMerge.Input.BucketName: swf-private-beta-samples
~~~~

Replace the value `swf-private-beta-samples`{.docutils .literal} with an
S3 bucket name associated with your AWS account. For more information
about how to create S3 buckets, see the [Amazon S3 Getting Started
Guide](http://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html)

Run the Sample
==============

**To run the SplitMerge sample:**

1.  Open a terminal window and change to the `lib`{.docutils .literal}
    directory in the location where you unarchived the sample code. For
    example:

~~~~ {.literal-block}
cd ~/Downloads/SplitMerge/lib
~~~~

3.  Execute the following commands on your command-line:

~~~~ {.literal-block}
ruby average_calculator_activity.rb &
ruby average_calculator_workflow.rb &
ruby average_calculator_workflow_starter.rb
~~~~

    Alternately, you can execute the run\_split\_merge.sh shell script
    to run all of these commands at once.


