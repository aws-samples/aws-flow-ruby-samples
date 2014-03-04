AWS Flow Framework for Ruby: PickFirstBranch Recipe
===================================================

.. include:: ../includes/Recipes_PickFirstBranch_desc.rst

.. include:: ../includes/prerequisites.rst

.. include:: ../includes/download.rst

View the Recipe
---------------

The **PickFirstBranch** recipe code is fully documented in the *AWS Flow Framework for Ruby Developer Guide*:

- `Execute Multiple Activities Concurrently and Pick the Fastest`_

Run the Recipe Code
-------------------

**To run the PickFirstBranch Recipe:**

1. Open a terminal window and change to the ``test`` directory in the location where you have cloned or unarchived the
   sample code. For example::

     cd ~/Downloads/aws-flow-ruby-samples/Recipes/PickFirstBranch/test

.. step 2 is common to all samples.
.. include:: ../includes/credential_step.rst

3. Execute the following command on your command-line::

     rspec pick_first_branch_integration_spec.rb

.. include:: ../includes/more_info.rst

.. _`Execute Multiple Activities Concurrently and Pick the Fastest`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes-concurrent-fastest.html


