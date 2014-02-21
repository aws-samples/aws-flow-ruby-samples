AWS Flow Framework for Ruby: Deployment Sample Application
==========================================================

.. include:: includes/deployment_desc.rst

.. include:: includes/prerequisites.rst

Download the Sample
-------------------

Download the sample by clicking the following link:

- `Deployment Sample`_

Once you've downloaded the sample ``.zip``, unarchive it and make note of the location you've expanded the archive into.

Run the Sample
--------------

**To run the Deployment sample:**

1. Open a terminal window and change to the ``lib`` directory in the location where you unarchived the sample code. For
   example::

    cd ~/Downloads/Deployment/lib

.. step 2 is common to all samples.
.. include:: includes/credential_step.rst

3. Execute the following commands on your command-line::

    ruby deployment_activity.rb &
    ruby deployment_workflow.rb &
    ruby deployment_workflow_starter.rb

   Alternately, you can execute the `run_deployment.sh` script to run all of these commands at once.

.. In the future, we'll include the "About the Sample Code" section right here...

.. include:: includes/more_info.rst
.. _`Deployment Sample`: https://awsdocs.s3.amazonaws.com/swf/1.0/samples/Deployment.zip

