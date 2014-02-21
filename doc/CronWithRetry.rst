AWS Flow Framework for Ruby: CronWithRetry Sample Application
=============================================================

.. include:: includes/cronwithretry_desc.rst

.. include:: includes/prerequisites.rst

Download the Sample
-------------------

Download the sample by clicking the following link:

- `CronWithRetry Sample`_

Once you've downloaded the sample ``.zip``, unarchive it and make note of the location you've expanded the archive into.

Run the Sample
--------------

**To run the CronWithRetry sample:**

1. Open a terminal window and change to the ``lib`` directory in the location where you unarchived the sample code. For
   example::

    cd ~/Downloads/CronWithRetry/lib

.. step 2 is common to all samples.
.. include:: includes/credential_step.rst

3. Execute the following commands on your command-line::

    ruby cron_with_retry_activity.rb &
    ruby cron_with_retry_workflow.rb &
    ruby cron_with_retry_workflow_starter.rb

   Alternately, you can execute the `run_cron.sh` script to run all of these commands at once.

.. In the future, we'll include the "About the Sample Code" section right here...

.. include:: includes/more_info.rst
.. _`CronWithRetry Sample`: https://awsdocs.s3.amazonaws.com/swf/1.0/samples/CronWithRetry.zip

