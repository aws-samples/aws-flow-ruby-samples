AWS Flow Framework for Ruby: Booking Sample Application
=======================================================

The *Booking* sample demonstrates a
[synchronization](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-synchronization)
workflow pattern. It waits for two activities to complete: a car
reservation and airline reservation. When both activities complete, it
sends a confirmation. All activities are performed asynchronously.

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

Run the Sample
--------------

**To run the Booking sample:**

1.  Open a terminal window and change to the `lib`
    directory in the location where you cloned or unarchived the sample
    code. For example:

    ~~~~
    cd ~/Downloads/aws-flow-ruby-samples/Samples/Booking/lib
    ~~~~

2.  Create a file in the directory called `credentials.cfg`
 and enter the following text, replacing the strings
    "insert ... access key here" with your AWS Access Key ID and your
    Secret Access Key.:

    ~~~~
    ---
    :access_key_id: "insert access key here"
    :secret_access_key: "insert secret access key here"
    ~~~~

3.  Execute the following commands on your command-line:

    ~~~~
    ruby booking_activity.rb &
    ruby booking_workflow.rb &
    ruby booking_workflow_starter.rb
    ~~~~

    Alternately, you can execute the run\_booking.sh shell script to run
    all of these commands at once.

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

