AWS Flow Framework for Ruby: RetryActivity Recipe
=================================================

The **RetryActivity** recipes show how to:

-   apply a retry policy to *all invocations of an activity*
-   specify a retry policy for an *activity client*, a *block of code*,
    or for a *specific invocation of an activity*
-   retry activities *without jitter*, or with *custom jitter logic*
-   retry activities with *custom retry policies*

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

View the Recipe
---------------

The **RetryActivity** recipe code is fully documented in the *AWS Flow
Framework for Ruby Developer Guide*. There are eight recipes provided:

-   [Apply a Retry Policy to All Invocations of an
    Activity](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-activity-options.html)
-   [Specify a Retry Policy for an Activity
    Client](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-client-options.html)
-   [Specify a Retry Policy for a Block of
    Code](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-block-options.html)
-   [Specify a Retry Policy for a Specific Invocation of an
    Activity](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-on-call-options.html)
-   [Retry Activities Without
    Jitter](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-no-jitter.html)
-   [Retry Activities with Custom Jitter
    Logic](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-custom-jitter.html)
-   [Retry a Synchronous Activity Call with a Custom Retry
    Policy](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-custom-logic-sync.html)
-   [Retry an Asynchronous Activity Call with a Custom Retry
    Policy](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-custom-logic-async.html)

Run the Recipe Code
-------------------

**To run the RetryActivity Recipes:**

1.  Open a terminal window and change to the `test`{.docutils .literal}
    directory in the location where you have cloned or unarchived the
    sample code. For example:

    ~~~~
    cd ~/Downloads/aws-flow-ruby-samples/Recipes/RetryActivity/test
    ~~~~

2.  Create a file in the directory called `credentials.cfg`{.docutils
    .literal} and enter the following text, replacing the strings
    "insert ... access key here" with your AWS Access Key ID and your
    Secret Access Key.:

    ~~~~
    ---
    :access_key_id: "insert access key here"
    :secret_access_key: "insert secret access key here"
    ~~~~

3.  Execute the following commands on your command-line:

    ~~~~
    rspec activity_options_retry_integration_spec.rb
    rspec client_options_retry_integration_spec.rb
    rspec retry_block_options_retry_integration_spec.rb
    rspec on_call_options_retry_integration_spec.rb
    rspec no_jitter_retry_integration_spec.rb
    rspec custom_jitter_retry_workflow.rb
    rspec custom_logic_sync_retry_integration_spec.rb
    rspec custom_logic_async_retry_integration_spec.rb
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

