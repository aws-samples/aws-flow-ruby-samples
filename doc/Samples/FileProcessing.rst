AWS Flow Framework for Ruby: FileProcessing Sample Application
==============================================================

.. include:: ../includes/Samples_FileProcessing_desc.rst

.. include:: ../includes/prerequisites.rst

To run the FileProcessing sample, you will also need the `rubyzip` Ruby library. To install it, run the following
command:

   gem install rubyzip

.. include:: ../includes/download.rst

Run the Sample
--------------

**To run the FileProcessing sample:**

1. Open a terminal window and change to the ``lib`` directory in the location where you cloned or unarchived the sample
   code. For example::

    cd ~/Downloads/aws-flow-ruby-samples/Samples/FileProcessing/lib

.. step 2 is common to all samples.
.. include:: ../includes/credential_step.rst

3. Execute the following commands on your command-line::

    ruby file_processing_activity_worker.rb &
    ruby file_processing_workflow.rb &
    ruby file_processing_workflow_starter.rb

   Alternately, you can execute the `run_file_processing.sh` shell script to run all of these commands at once.

.. In the future, we'll include the "About the Sample Code" section right here...

.. include:: ../includes/more_info.rst
