AWS Flow Framework for Ruby: SplitMerge Sample Application
==========================================================

.. include:: includes/splitmerge_desc.rst

.. include:: includes/prerequisites.rst

Download the Sample
-------------------

Download the sample by clicking the following link:

-  `SplitMerge Sample`_

Once you've downloaded the sample ``.zip``, unarchive it and make note of the location you've expanded the archive into.

Configure the Sample
--------------------

This sample requires a little bit of configuration. Open the ``split_merge_config.yml`` file and edit the following
line::

  SplitMerge.Input.BucketName: swf-private-beta-samples

Replace the value ``swf-private-beta-samples`` with an S3 bucket name associated with your AWS account. For more
information about how to create S3 buckets, see the `Amazon S3 Getting Started Guide`_

Run the Sample
--------------

**To run the SplitMerge sample:**

1. Open a terminal window and change to the ``lib`` directory in the location where you unarchived the sample code. For
   example::

    cd ~/Downloads/SplitMerge/lib

.. step 2 is common to all samples.
.. include:: includes/credential_step.rst

3. Execute the following commands on your command-line::

    ruby average_calculator_activity.rb &
    ruby average_calculator_workflow.rb &
    ruby average_calculator_workflow_starter.rb

   Alternately, you can execute the `run_split_merge.sh` shell script to run all of these commands at once.

.. In the future, we'll include the "About the Sample Code" section right here...

.. include:: includes/more_info.rst

.. _`SplitMerge Sample`: https://awsdocs.s3.amazonaws.com/swf/1.0/samples/SplitMerge.zip
.. _`Amazon S3 Getting Started Guide`: http://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html
