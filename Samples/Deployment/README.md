The *Deployment* sample illustrates the deployment of a set of
application components through a workflow. A YAML configuration file is
used to describe the application stack. The workflow takes this
description as input and simulates the deployment of the components
specified in it.

Prerequisites
=============

The *AWS Flow Framework for Ruby* is required, which can be obtained and
installed using the information here:

-   [https://aws.amazon.com/swf/flow/](https://aws.amazon.com/swf/flow/)

If you already have [Ruby](https://www.ruby-lang.org/) and
[RubyGems](http://rubygems.org/) installed, you can install the
framework by opening a terminal window and typing:

~~~~ {.literal-block}
gem install aws-flow
~~~~

For more information about setting up the AWS Flow Framework for Ruby,
see [Installing the AWS Flow Framework for
Ruby](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/installing.html)
in the *AWS Flow Framework for Ruby Developer Guide*.

Downloading the Sample Code
===========================

To view or download the code for all of the AWS Flow Framework for Ruby
recipes and samples, go to:

-   [https://github.com/awslabs/aws-flow-ruby-samples](https://github.com/awslabs/aws-flow-ruby-samples)

Run the Sample
==============

**To run the Deployment sample:**

1.  Open a terminal window and change to the `lib`{.docutils .literal}
    directory in the location where you cloned or unarchived the sample
    code. For example:

    ~~~~ {.literal-block}
    cd ~/Downloads/aws-flow-ruby-samples/Samples/Deployment/lib
    ~~~~

2.  Create a file in the directory called `credentials.cfg`{.docutils
    .literal} and enter the following text, replacing the strings
    "insert ... access key here" with your AWS Access Key ID and your
    Secret Access Key.:

    ~~~~ {.literal-block}
    ---
    :access_key_id: "insert access key here"
    :secret_access_key: "insert secret access key here"
    ~~~~

3.  Execute the following commands on your command-line:

    ~~~~ {.literal-block}
    ruby deployment_activity.rb &
    ruby deployment_workflow.rb &
    ruby deployment_workflow_starter.rb
    ~~~~

    Alternately, you can execute the run\_deployment.sh script to run
    all of these commands at once.

For More Information
====================

For more information about the Amazon Simple Workflow service and the
Amazon Flow Framework for Ruby, consult the following resources:

-   [AWS Flow Framework for Ruby Developer
    Guide](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/)
-   [AWS Flow Framework for Ruby API
    Reference](https://docs.aws.amazon.com/amazonswf/latest/awsrbflowapi/)
-   [AWS Flow Framework](http://aws.amazon.com/swf/flow/)
-   [Amazon Simple Workflow Service](http://aws.amazon.com/swf/)

