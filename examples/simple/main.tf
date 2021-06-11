data "azurerm_subscription" "current" {
}


module "role_assignment" {
  source = "../../"

  scope_id                     = data.azurerm_subscription.current.id
  builtin_role_definition_name = "Contributor"
  principal_id                 = var.principal_id
}
