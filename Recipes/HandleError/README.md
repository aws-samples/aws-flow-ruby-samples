The **HandleError** code provides recipes to *respond to exceptions in
asynchronous activities depending on exception type* and to *handle
exceptions in asynchronous activities and perform cleanup*.

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

View the Recipe
===============

The **HandleError** recipe code is fully documented in the *AWS Flow
Framework for Ruby Developer Guide*. There are two recipes provided:

-   [Respond to Exceptions in Asynchronous Activities Depending on
    Exception
    Type](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-exceptions-handle-error.html)
-   [Handle Exceptions in Asynchronous Activities and Perform
    Cleanup](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-exceptions-cleanup.html)

Run the Recipe Code
===================

**To run the HandleError Recipes:**

1.  Open a terminal window and change to the `test`{.docutils .literal}
    directory in the location where you have cloned or unarchived the
    sample code. For example:

    ~~~~ {.literal-block}
    cd ~/Downloads/aws-flow-ruby-samples/Recipes/HandleError/test
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
    rspec handle_error_integration_spec.rb
    rspec clean_up_resource_integration_spec.rb
    ~~~~

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

