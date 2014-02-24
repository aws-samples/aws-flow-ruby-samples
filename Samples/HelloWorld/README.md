The *HelloWorld* sample uses a very simple workflow that calls an activity to print Hello World. It shows basic usage of the framework, including implementing activities and workflow coordination logic and building workers to run the workflow and activities.

You can also read the sample walkthrough in the [documentation](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/helloworld.html), or view the [getting started video](http://www.youtube.com/watch?v=Z_dvXy4AVEE), which also features this sample.

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

-   [HelloWorld Sample](https://awsdocs.s3.amazonaws.com/swf/1.0/samples/HelloWorld.zip)

Once you've downloaded the sample `.zip`, unarchive it and make note of the location you've expanded the archive into.

Run the Sample
==============

**To run the HelloWorld sample:**

1.  Open a terminal window and change to the `lib` directory in the location where you unarchived the sample code. For example:

    ~~~~ {.literal-block}
    cd ~/Downloads/HelloWorld/lib
    ~~~~

1.  Create a file in the `lib` directory called `credentials.cfg` and enter the following text, replacing the strings "insert ... access key here" with your AWS Access Key ID and your Secret Access Key.:

    ~~~~ {.literal-block}
    ---
    :access_key_id: "insert access key here"
    :secret_access_key: "insert secret access key here"
    ~~~~

2.  Execute the following commands on your command-line:

    ~~~~ {.literal-block}
    ruby hello_world_activity.rb &
    ruby hello_world_workflow.rb &
    ruby hello_world_workflow_starter.rb
    ~~~~

    Alternately, you can execute the run\_hello.sh shell script to run all of these commands at once.

For More Information
====================

For more information about the Amazon Simple Workflow service and the Amazon Flow Framework for Ruby, consult the following resources:

-   [AWS Flow Framework for Ruby Developer Guide](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/)
-   [AWS Flow Framework for Ruby API Reference](https://docs.aws.amazon.com/amazonswf/latest/awsrbflowapi/)
-   [AWS Flow Framework](http://aws.amazon.com/swf/flow/)
-   [Amazon Simple Workflow Service](http://aws.amazon.com/swf/)

