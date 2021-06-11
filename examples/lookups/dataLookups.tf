# Get all available Subscriptions
data "azurerm_subscriptions" "available" {}

# Filter returned Subscriptions data to retrieve the ID of the scoped Subscription using 'Display Name'.
# 
locals {
    sub_name    = "Pay-As-You-Go"
    subs        = data.azurerm_subscriptions.available.subscriptions
    sub_id_list = [
        for x in local.subs : x.id if x.display_name == local.sub_name
    ]
    sub_id = element(local.sub_id_list, 0)
}

# Get the scoped Custom Role data
data "azurerm_role_definition" "custom-byname" {
  name = "CreateRG"
  scope = local.sub_id
}


