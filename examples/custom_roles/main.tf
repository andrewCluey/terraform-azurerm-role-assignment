# Get the current Subscription
data "azurerm_subscription" "current" {}

# Define the Role assignments.
# Module will loop through each of the defined assignments in the local block below. 
# Assigning the role defined in `role_definition_name` at the chosen scope, to the defined `principal_id`.
locals {
  sub_id = data.azurerm_subscription.current.id
  assignments = {
    customSub = {
      scope                = local.sub_id
      role_definition_name = "Contributor"
      principal_ids         = ["b86811e4-gkjgjg-jhkuh"]
    },
    assignCustomRole = {
      scope                = local.sub_id
      role_definition_name = "customreader"
      principal_ids        = ["gkjgjg-cce6-9e70-2y687tiuyg"]
    }
  }
}

module "role_assignment" {
  for_each = local.assignments
  source   = "andrewCluey/role-assignment/azurerm"
  version  = "1.1.0"

  scope_id             = each.value.scope
  principal_ids        = each.value.principal_ids
  role_definition_name = lookup(each.value, "role_definition_name", null)
}

