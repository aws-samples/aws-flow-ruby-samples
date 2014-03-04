AWS Flow Framework for Ruby: RetryActivity Recipe
=================================================

.. include:: ../includes/Recipes_RetryActivity_desc.rst

.. include:: ../includes/prerequisites.rst

.. include:: ../includes/download.rst

View the Recipe
---------------

The **RetryActivity** recipe code is fully documented in the *AWS Flow Framework for Ruby Developer Guide*. There are
eight recipes provided:

* `Apply a Retry Policy to All Invocations of an Activity`_
* `Specify a Retry Policy for an Activity Client`_
* `Specify a Retry Policy for a Block of Code`_
* `Specify a Retry Policy for a Specific Invocation of an Activity`_
* `Retry Activities Without Jitter`_
* `Retry Activities with Custom Jitter Logic`_
* `Retry a Synchronous Activity Call with a Custom Retry Policy`_
* `Retry an Asynchronous Activity Call with a Custom Retry Policy`_

Run the Recipe Code
-------------------

**To run the RetryActivity Recipes:**

1. Open a terminal window and change to the ``test`` directory in the location where you have cloned or unarchived the
   sample code. For example::

     cd ~/Downloads/aws-flow-ruby-samples/Recipes/RetryActivity/test

.. step 2 is common to all samples.
.. include:: ../includes/credential_step.rst

3. Execute the following commands on your command-line::

     rspec activity_options_retry_integration_spec.rb
     rspec client_options_retry_integration_spec.rb
     rspec retry_block_options_retry_integration_spec.rb
     rspec on_call_options_retry_integration_spec.rb
     rspec no_jitter_retry_integration_spec.rb
     rspec custom_jitter_retry_workflow.rb
     rspec custom_logic_sync_retry_integration_spec.rb
     rspec custom_logic_async_retry_integration_spec.rb

.. include:: ../includes/more_info.rst

.. _`Apply a Retry Policy to All Invocations of an Activity`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-activity-options.html
.. _`Specify a Retry Policy for an Activity Client`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-client-options.html
.. _`Specify a Retry Policy for a Block of Code`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-block-options.html
.. _`Specify a Retry Policy for a Specific Invocation of an Activity`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-on-call-options.html
.. _`Retry Activities Without Jitter`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-no-jitter.html
.. _`Retry Activities with Custom Jitter Logic`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-custom-jitter.html
.. _`Retry a Synchronous Activity Call with a Custom Retry Policy`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-custom-logic-sync.html
.. _`Retry an Asynchronous Activity Call with a Custom Retry Policy`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-retry-custom-logic-async.html

