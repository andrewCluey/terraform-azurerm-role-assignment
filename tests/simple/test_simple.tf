terraform {
  required_providers {
    # Because we're currently using a built-in provider as
    # a substitute for dedicated Terraform language syntax
    # for now, test suite modules must always declare a
    # dependency on this provider. This provider is only
    # available when running tests, so you shouldn't use it
    # in non-test modules.
    test = {
      source = "terraform.io/builtin/test"
    }

    module "simple_role_assignment" {
        source = "../.."
    }
  }
}