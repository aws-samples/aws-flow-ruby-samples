The *FileProcessing* sample demonstrates a media processing use case.
The workflow downloads a file from an Amazon S3 bucket, creates a
`.zip`{.docutils .literal} file and uploads that `.zip`{.docutils
.literal} file back to Amazon S3. The task routing feature in Amazon SWF
is illustrated in this sample.

Prerequisites
=============

The *AWS Flow Framework for Ruby* is required, which can be obtained and
installed using the information here:

-   [https://aws.amazon.com/swf/flow/](https://aws.amazon.com/swf/flow/)

If you already have [Ruby](https://www.ruby-lang.org/) and
[RubyGems](http://rubygems.org/) installed, you can install the
framework by opening a terminal window and typing:

~~~~ {.literal-block}
gem install aws-flow
~~~~

For more information about setting up the AWS Flow Framework for Ruby,
see [Installing the AWS Flow Framework for
Ruby](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/installing.html)
in the *AWS Flow Framework for Ruby Developer Guide*.

To run the FileProcessing sample, you will also need the rubyzip Ruby
library. To install it, run the following command:

> gem install rubyzip

Downloading the Sample Code
===========================

You can get the sample code in two easy ways:

-   Clone the project with either HTTPS or SSH authentication.

    HTTPS::
      ~ git clone
        [https://github.com/awslabs/aws-flow-ruby-samples.git](https://github.com/awslabs/aws-flow-ruby-samples.git)

    SSH::
      ~ git clone
        [git@github.com](mailto:git@github.com):awslabs/aws-flow-ruby-samples.git

-   Download the entire repository as a .zip file, using:

    [https://github.com/awslabs/aws-flow-ruby-samples/archive/master.zip](https://github.com/awslabs/aws-flow-ruby-samples/archive/master.zip)

Run the Sample
==============

**To run the FileProcessing sample:**

1.  Open a terminal window and change to the `lib`{.docutils .literal}
    directory in the location where you unarchived the sample code. For
    example:

~~~~ {.literal-block}
cd ~/Downloads/FileProcessing/lib
~~~~

2.  Create a file in the `lib`{.docutils .literal} directory called
    `credentials.cfg`{.docutils .literal} and enter the following text,
    replacing the strings "insert ... access key here" with your AWS
    Access Key ID and your Secret Access Key.:

~~~~ {.literal-block}
---
:access_key_id: "insert access key here"
:secret_access_key: "insert secret access key here"
~~~~

3.  Execute the following commands on your command-line:

~~~~ {.literal-block}
ruby file_processing_activity_worker.rb &
ruby file_processing_workflow.rb &
ruby file_processing_workflow_starter.rb
~~~~

    Alternately, you can execute the run\_file\_processing.sh shell
    script to run all of these commands at once.

For More Information
====================

For more information about the Amazon Simple Workflow service and the
Amazon Flow Framework for Ruby, consult the following resources:

-   [AWS Flow Framework for Ruby Developer
    Guide](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/)
-   [AWS Flow Framework for Ruby API
    Reference](https://docs.aws.amazon.com/amazonswf/latest/awsrbflowapi/)
-   [AWS Flow Framework](http://aws.amazon.com/swf/flow/)
-   [Amazon Simple Workflow Service](http://aws.amazon.com/swf/)

