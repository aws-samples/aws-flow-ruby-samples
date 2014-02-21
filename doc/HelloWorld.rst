AWS Flow Framework for Ruby: HelloWorld Sample Application
==========================================================

.. include:: includes/helloworld_desc.rst

You can also read the sample walkthrough in the `documentation`_, or view the `getting started video`_, which also
features this sample.

.. include:: includes/prerequisites.rst

Download the Sample
-------------------

Download the sample by clicking the following link:

-  `HelloWorld Sample`_

Once you've downloaded the sample ``.zip``, unarchive it and make note of the location you've expanded the archive into.

Run the Sample
--------------

**To run the HelloWorld sample:**

1. Open a terminal window and change to the ``lib`` directory in the location where you unarchived the sample code. For
   example::

    cd ~/Downloads/HelloWorld/lib

.. step 2 is common to all samples.
.. include:: includes/credential_step.rst

3. Execute the following commands on your command-line::

    ruby hello_world_activity.rb &
    ruby hello_world_workflow.rb &
    ruby hello_world_workflow_starter.rb

   Alternately, you can execute the `run_hello.sh` shell script to run all of these commands at once.

.. In the future, we'll include the "About the Sample Code" section right here...

.. include:: includes/more_info.rst

.. _`HelloWorld Sample`: https://awsdocs.s3.amazonaws.com/swf/1.0/samples/HelloWorld.zip
.. _`documentation`: http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/helloworld.html
.. _`getting started video`: http://www.youtube.com/watch?v=Z_dvXy4AVEE

