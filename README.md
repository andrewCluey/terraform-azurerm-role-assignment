# terraform-azurerm-role-assignment
Terraform module to assign either a custom or built in role to a resource in Azure.


## Required Arguments

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `scope_id` | `string` | true | The ID of the Subscription, Management Group or Resource group where the role is to be assigned. |
| `principal_id` | `string` | true | The Object ID of the User, Group or Service Principal that is to be assigned the role. |
| `builtin_role_definition_name` | `string` | false | The name of the built in role (such as Owner or Contributor) to assign to the principal at the chosen scope. If this is not used, then ```custom_role_defintion_id``` must be used. |
| `custom_role_definition_id` | `string` | false | The ID of the custom role that is to be assigned to the principal at the chosen scope. If this is not used, then ```builtin_role_defintion_name``` must be used instead. |


## Example deployments

### custom role assigned to a subscription with Display Name of 'Production'
```
data "azurerm_subscriptions" "available" {}

locals {
    sub_name = "Production"
    subs     = data.azurerm_subscriptions.available.subscriptions
    sub_id   = [
        for x in local.subs : x.subscription_id if x.display_name == local.sub_name
    ]
}

module "role_assignment" {
    source = "../../"

    scope_id                     = local.sub_id
    builtin_role_definition_name = "Contributor"
    principal_id                 = "4c9xxxx-22xxx-123e-d3f4-399dc34s964d" 
}
```
