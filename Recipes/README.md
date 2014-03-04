AWS Flow Framework for Ruby Recipes
===================================

This directory contains the AWS Flow Framework for Ruby *Recipes*.

The recipes provide examples of code that you can use to implement
common workflow patterns. Each of the recipes is described in detail in
the [AWS Flow Framework for Ruby Developer
Guide](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/recipes.html).

The following recipes are provided:

Branch
------

The **Branch** code provides a recipe to *execute a
dynamically-determined number of activities concurrently*.

Code + info: [Recipes/Branch](Recipes/Branch/)

ChildWorkflow
-------------

The **ChildWorkflow** code provides a recipe to *start a child workflow
inside a workflow execution*.

Code + info: [Recipes/ChildWorkflow](Recipes/ChildWorkflow/)

Choice
------

The **Choice** recipes show how to use a choice to *execute one of
several activities*, or to *execute multiple activities from a larger
group*.

Code + info: [Recipes/Choice](Recipes/Choice/)

ConditionalLoop
---------------

The **ConditionalLoop** code provides a recipe to *execute a
dynamically-determined number of activities concurrently*.

Code + info: [Recipes/ConditionalLoop](Recipes/ConditionalLoop/)

HandleError
-----------

The **HandleError** code provides recipes to *respond to exceptions in
asynchronous activities depending on exception type* and to *handle
exceptions in asynchronous activities and perform cleanup*.

Code + info: [Recipes/HandleError](Recipes/HandleError/)

HumanTask
---------

The **HumanTask** code provides a recipe to *Complete an Activity Task
Manually*.

Code + info: [Recipes/HumanTask](Recipes/HumanTask/)

PickFirstBranch
---------------

The **PickFirstBranch** code provides a recipe to *execute multiple
activities concurrently and pick the fastest*.

Code + info: [Recipes/PickFirstBranch](Recipes/PickFirstBranch/)

RetryActivity
-------------

The **RetryActivity** recipes show how to:

-   apply a retry policy to *all invocations of an activity*
-   specify a retry policy for an *activity client*, a *block of code*,
    or for a *specific invocation of an activity*
-   retry activities *without jitter*, or with *custom jitter logic*
-   retry activities with *custom retry policies*

Code + info: [Recipes/RetryActivity](Recipes/RetryActivity/)

WaitForSignal
-------------

The **WaitForSignal** code provides a recipe to *wait for an external
signal and take a different code path if the signal is received*.

Code + info: [Recipes/WaitForSignal](Recipes/WaitForSignal/)
