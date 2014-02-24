AWS Flow Framework for Ruby: Booking Sample Application
=======================================================

.. include:: includes/booking_desc.rst

.. include:: includes/prerequisites.rst

Download the Sample
-------------------

Download the sample by clicking the following link:

- `Booking Sample`_

Once you've downloaded the sample ``.zip``, unarchive it and make note of the location you've expanded the archive into.

Run the Sample
--------------

**To run the Booking sample:**

1. Open a terminal window and change to the ``lib`` directory in the location where you unarchived the sample code. For
   example::

    cd ~/Downloads/Booking/lib

.. step 2 is common to all samples.
.. include:: includes/credential_step.rst

3. Execute the following commands on your command-line::

    ruby booking_activity.rb &
    ruby booking_workflow.rb &
    ruby booking_workflow_starter.rb

   Alternately, you can execute the `run_booking.sh` shell script to run all of these commands at once.

.. In the future, we'll include the "About the Sample Code" section right here...

.. include:: includes/more_info.rst

.. _`Booking Sample`: https://awsdocs.s3.amazonaws.com/swf/1.0/samples/Booking.zip

