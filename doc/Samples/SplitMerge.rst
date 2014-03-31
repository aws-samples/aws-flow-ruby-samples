AWS Flow Framework for Ruby: SplitMerge Sample Application
==========================================================

.. include:: ../includes/Samples_SplitMerge_desc.rst

.. include:: ../includes/prerequisites.rst

.. include:: ../includes/download.rst

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

.. include:: ../includes/sample_run_step_1_desc.rst

    cd ~/Downloads/aws-flow-ruby-samples/Samples/SplitMerge/lib

.. include:: ../includes/credential_step.rst

.. include:: ../includes/sample_run_step_3_desc.rst

    ruby average_calculator_activity.rb

    ruby average_calculator_workflow.rb

    ruby average_calculator_workflow_starter.rb

.. include:: ../includes/more_info.rst

.. _`Amazon S3 Getting Started Guide`: http://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html
