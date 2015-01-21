require 'aws/decider'

# Use the AWS::Flow#start method to invoke the HelloWorld.say_hello activity and
# pass the input to it
AWS::Flow.start("HelloWorld.say_hello", { name: "AWS Flow Framework for Ruby"})
