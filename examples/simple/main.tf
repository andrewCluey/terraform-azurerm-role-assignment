

resource "azurerm_resource_group" "rg_role_assignment" {
  name     = "rg-role-assignment"
  location = "uksouth"
}

locals {
  rg_id                  = azurerm_resource_group.rg_role_assignment.id
  Owner_principals       = ["4c9eID1", "4b08d52e-ID2"]
  Contributor_principals = ["a63120c8-ID3"]

}


module "Owner_roleAssignment" {
  source   = "../../"

  role_definition_name = "Owner"
  scope_id             = local.rg_id
  principal_ids        = local.Owner_principals
}

module "Contributor_roleAssignment" {
  source   = "../../"

  role_definition_name = "Contributor"
  scope_id             = local.rg_id
  principal_ids        = local.Contributor_principals
}