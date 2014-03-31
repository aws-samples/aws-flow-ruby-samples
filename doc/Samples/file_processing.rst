AWS Flow Framework for Ruby: FileProcessing Sample Application
==============================================================

.. include:: ../includes/Samples_file_processing_desc.rst

.. include:: ../includes/prerequisites.rst

To run the FileProcessing sample, you will need the ``rubyzip`` Ruby library. To install it, run the following
command::

    gem install rubyzip

You will also need to modify the file ``file_processing_utils.rb``, changing the value of ``TARGET_BUCKET`` to an Amazon
S3 bucket name that is owned by your account.

.. include:: ../includes/download.rst

Run the Sample
--------------

**To run the FileProcessing sample:**

.. include:: ../includes/sample_run_step_1_desc.rst

::
    cd ~/Downloads/aws-flow-ruby-samples/Samples/file_processing/lib

.. include:: ../includes/credential_step.rst

.. include:: ../includes/sample_run_step_3_desc.rst

::
    ruby file_processing_activity_worker.rb

    ruby file_processing_workflow.rb

    ruby file_processing_workflow_starter.rb

.. include:: ../includes/more_info.rst
