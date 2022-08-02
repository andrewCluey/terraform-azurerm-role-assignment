terraform {
  required_providers {
    # terraform.io/builin/test is an experimental feature to provide native testing in Terraform.
    # This provider is only available when running tests, so you shouldn't be used in non-test modules.
    test = {
      source = "terraform.io/builtin/test"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.10.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# As with all Terraform modules, we can use local values and specific 
# resource blocks for providing data inputs into the test assertions.
# Or, to do any necessary post-processing of the results from the module in preparation for writing test assertions.
resource "azurerm_resource_group" "rg_role_assignment" {
  name     = "rg-test-role-assignment"
  location = "uksouth"
}

data "azuread_user" "example" {
  user_principal_name = "tf_infra@ascsolutions.onmicrosoft.com"
}

locals {
  rg_id               = azurerm_resource_group.rg_role_assignment.id
  returned_scope_list = [azurerm_resource_group.rg_role_assignment.id] # Post processing results. Module output returns a list of assignment Scopes.
  owner_principals    = [data.azuread_user.example.object_id]
}


# Here, we are deploying a simple role assignment using the role_assignment module.
# It will assign the `Owner` role, to the Principals defined in the `local.owner_principals`, 
# at the scope of the new Resource Group.
module "role_assignment" {
# source is always "../.." for test suite configurations,
# because they are placed two sub-directories deep under the main module directory.
  source   = "../../"

  role_definition_name = "Owner"
  scope_id             = local.rg_id
  principal_ids        = local.owner_principals 
}


# The special test_assertions resource type, which belongs
# to the test provider we specified in the providers block, is a temporary
# syntax for writing out explicit test assertions.
resource "test_assertions" "ownr_assignment" {
  # "component" serves as a unique identifier for this particular set of assertions in the test results.
  component = "ownr_assignment"

  # equal and check blocks serve as the test assertions.
  # The labels on these blocks are unique identifiers for the assertions, to allow simpler tracking of changes
  # in success between runs.

  equal "scope" {
    description = "Confirm that the scope of the assignment is what we expect. Uses Output from module."
    got         = module.role_assignment.scope
    want        = local.returned_scope_list
  }

  #check "id" {
  #  description = "Do we get an assignment ID returned in Output?"
  #  condition   = can(regex("valid regex for assignment ID format ????))
  #}
}