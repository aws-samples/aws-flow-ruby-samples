AWS Flow Framework for Ruby: Periodic Sample Application
========================================================

.. include::../includes/Samples_Periodic_desc.rst

.. include::../includes/prerequisites.rst

.. include::../includes/download.rst

Run the Sample
--------------

**To run the Periodic sample:**

1. Open a terminal window and change to the ``lib`` directory in the location where you unarchived the sample code. For
   example::

    cd ~/Downloads/Periodic/lib

.. step 2 is common to all samples.
.. include::../includes/credential_step.rst

3. Execute the following commands on your command-line::

    ruby error_reporting_activity.rb &
    ruby periodic_activity.rb &
    ruby periodic_workflow.rb &
    ruby periodic_workflow_starter.rb

   Alternately, you can execute the `run_periodic.sh` shell script to run all of these commands at once.

.. In the future, we'll include the "About the Sample Code" section right here...

.. include::../includes/more_info.rst

