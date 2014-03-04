AWS Flow Framework for Ruby: HandleError Recipe
===============================================

.. include:: ../includes/Recipes_HandleError_desc.rst

.. include:: ../includes/prerequisites.rst

.. include:: ../includes/download.rst

View the Recipe
---------------

The *HandleError* recipe code is fully documented in the *AWS Flow Framework for Ruby Developer Guide*. There are two
recipes provided:

- `Respond to Exceptions in Asynchronous Activities Depending on Exception Type`_
- `Handle Exceptions in Asynchronous Activities and Perform Cleanup`_

Run the Recipe Code
-------------------

**To run the HandleError Recipes:**

1. Open a terminal window and change to the ``test`` directory in the location where you have cloned or unarchived the
   sample code. For example::

     cd ~/Downloads/aws-flow-ruby-samples/Recipes/HandleError/test

.. step 2 is common to all samples.
.. include:: ../includes/credential_step.rst

3. Execute the following commands on your command-line::

     rspec handle_error_integration_spec.rb
     rspec clean_up_resource_integration_spec.rb

.. include:: ../includes/more_info.rst

.. _`Respond to Exceptions in Asynchronous Activities Depending on Exception Type`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-exceptions-handle-error.html
.. _`Handle Exceptions in Asynchronous Activities and Perform Cleanup`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-exceptions-cleanup.html
