# Define the Role assignments.
# Module will loop through each one, assigning the chosen role, at the chosen scope, to the user, group or Service Principal.
locals {
  assignments = {
    customSub = {
      scope                        = local.sub_id
      custom_role_definition_id    = data.azurerm_role_definition.custom-byname.id
      principal_id                 = "058fb07d-69ac-4572-8351-4ace6ab0929b"
    },
    builtInMg = {
      scope                        = "/providers/Microsoft.Management/managementGroups/dev"
      builtin_role_definition_name = "Reader"
      principal_id                 = "058fb07d-69ac-4572-8351-4ace6ab0929b"
    }
  }
}


module "role-assignment" {
  for_each = local.assignments
  source   = "andrewCluey/role-assignment/azurerm"
  version  = "0.1.1"

  scope_id                     = each.value.scope
  principal_id                 = each.value.principal_id
  builtin_role_definition_name = lookup(each.value, "builtin_role_definition_name", null)
  custom_role_definition_id    = lookup(each.value, "custom_role_definition_id", null)
}

