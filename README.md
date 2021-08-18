# terraform-azurerm-role-assignment
Terraform module to assign either a custom or built in role to a resource in Azure.


## Required Arguments

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `scope_id` | `string` | true | The ID of the Subscription, Management Group or Resource group where the role is to be assigned. |
| `principal_ids` | `string` | true | A list of Object IDs definint the User, Group or Service Principal that is to be assigned the role. |
| `role_definition_name` | `string` | true | The name of the role (such as Owner or Contributor) to assign to the principal at the chosen scope.|

## Example deployments
Below are two possible ways to pefform the same task. That being to assign Contributor and Owner rights to a new Resource group.

The first option is the simplest way, in that two separate modules are used. Once to assign the Owner role and the other to assgn the Contributor role.

### Exmaple showing a simpel deployment. Using separate modules for assignign different roles.

```hcl

resource "azurerm_resource_group" "rg_role_assignment" {
  name     = "rg-role-assignment"
  location = "uksouth"
}

locals {
  rg_id                  = azurerm_resource_group.rg_role_assignment.id
  Owner_principals       = ["4c9e9244-id", "4fsfesef-7349-ID"]
  Contributor_principals = ["ObjevctID-4338-86ed-0a3fdc899804", "4IDIDID-7349-DUMMYID-OBJECTf"]

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

```

### Example showing deploying multiple assignments to different scopes with different Roles using for_each at the ```module```.

```hcl

resource "azurerm_resource_group" "rg_role_assignment" {
  name     = "rg-role-assignment"
  location = "uksouth"
}

locals {
  rg_id = azurerm_resource_group.rg_role_assignment.id
  role = {
    "Contributor" = ["ObjevctID-2334-53rd-dummyID", "4IDIDID-7349-DUMMYID-OBJECTf"],
    "Owner"       = ["a63120c8-4338-86es-dummyID"]
  }
}


module "roleAssignment" {
  for_each = local.role
  source   = "../../"

  role_definition_name = each.key
  scope_id             = local.rg_id
  principal_ids        = each.value
}

```