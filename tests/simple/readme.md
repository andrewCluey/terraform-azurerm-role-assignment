# terraform test

Example of the experimental `test` feature included in the Terraform cli (v1.0+).

## Overview

The terraform test command aims to make it easier to exercise all of your defined test suites at once, and see only the output related to any test failures or errors.

The current experimental incarnation of this command expects to be run from your main module directory. The command requires a specific directory named `tests`.

In this example, we will run `terraform test` from the root of the module repo (where `main.tf`, `outputs.tf` and `variables.tf` reside). The `terraform test` command should not be run from the test directory itself.

Because these test suites are integration tests rather than unit tests, you'll need to set up any credentials files or environment variables needed by the providers your module uses before running terraform test. The test command will, for each suite:

 - Install the providers and any external modules the test configuration depends on.
 - Create an execution plan to create the objects declared in the module.
 - Apply that execution plan to create the objects in the real remote system.
 - Collect all of the test results from the apply step, which would also have "created" the test_assertions resources.
 - Destroy all of the objects recorded in the temporary test state, as if running terraform destroy against the test configuration.

## test_assertions

equal - For example can be used to check the output is an exact match for what you expect. Here, we confirm that the `scope id` returned from the Module output matches the id of the Resource Group where we are assigning the principal.

check - Checks that somehting is 'truthy'. For example, we won't know the assignment ID until after it has been assigned, so we can't use the `equal` test. Instead, we can specify a valid REGEX pattern for an assignment ID and `check` that what is returned from the output matches this pattern.

