data "azurerm_subscriptions" "available" {
}

locals {
  sub_name = "Pay-As-You-Go"
  subs   = data.azurerm_subscriptions.available.subscriptions
  
  sub_id_list = [
    for x in local.subs : x.id if x.display_name == local.sub_name
  ]

  sub_id = element(local.sub_id_list, 0)
}


module "role_assignment" {
  source = "../../"

  scope_id                     = local.sub_id
  builtin_role_definition_name = "Contributor"
  principal_id                 = var.principal_id
}
