

resource "azurerm_resource_group" "rg_role_assignment" {
  name     = "rg-role-assignment"
  location = "uksouth"
}

locals {
  rg_id = azurerm_resource_group.rg_role_assignment.id
  role = {
    "Contributor" = ["4c9e924ID", "4b08d52eID2"],
    "Owner"       = ["a63120c8-ID3"]
  }
}


module "roleAssignment" {
  for_each = local.role
  source   = "../../"

  role_definition_name = each.key
  scope_id             = local.rg_id
  principal_ids        = each.value
}
