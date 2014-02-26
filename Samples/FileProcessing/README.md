To run the FileProcessing sample, you will also need the rubyzip Ruby
library. To install it, run the following command:

> gem install rubyzip

Run the Sample
==============

**To run the FileProcessing sample:**

1.  Open a terminal window and change to the `lib`{.docutils .literal}
    directory in the location where you unarchived the sample code. For
    example:

~~~~ {.literal-block}
cd ~/Downloads/FileProcessing/lib
~~~~

3.  Execute the following commands on your command-line:

~~~~ {.literal-block}
ruby file_processing_activity_worker.rb &
ruby file_processing_workflow.rb &
ruby file_processing_workflow_starter.rb
~~~~

    Alternately, you can execute the run\_file\_processing.sh shell
    script to run all of these commands at once.


