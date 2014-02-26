You can also read the sample walkthrough in the
[documentation](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/helloworld.html),
or view the [getting started
video](http://www.youtube.com/watch?v=Z_dvXy4AVEE), which also features
this sample.

Run the Sample
==============

**To run the HelloWorld sample:**

1.  Open a terminal window and change to the `lib`{.docutils .literal}
    directory in the location where you unarchived the sample code. For
    example:

~~~~ {.literal-block}
cd ~/Downloads/HelloWorld/lib
~~~~

3.  Execute the following commands on your command-line:

~~~~ {.literal-block}
ruby hello_world_activity.rb &
ruby hello_world_workflow.rb &
ruby hello_world_workflow_starter.rb
~~~~

    Alternately, you can execute the run\_hello.sh shell script to run
    all of these commands at once.


