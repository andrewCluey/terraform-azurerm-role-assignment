# terraform-azurerm-role-assignment
Terraform module to assign either a custom or built in role to a resource in Azure.


## Required Arguments

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `scope_id` | `string` | true | The ID of the Subscription, Management Group or Resource group where the role is to be assigned. |
| `principal_ids` | `string` | true | A list of Object IDs that define the User, Group or Service Principal to be assigned the role at the given scope. Module will iterate over each item, creating each assignment separately. |
| `role_definition_name` | `string` | true | The name of the role (such as Owner or Contributor) to assign to the principal at the given scope.|
| `skip_service_principal_aad_check` | 'bool' | false | Ignores the AAD check for Service Principals. Useful if creating a new SPN as part of the deployment (Replication lag). |

## Example deployments
Below are two possible ways to perform the same task. Specifically, to assign Contributor and Owner rights to a new Resource group.

The first option is the simplest way, where each Role Assignment at a specific scope has its own module block. One to assign the Owner role and the other to assign the Contributor role.

The second example uses the `for_each` expression to perform the same role assignments but with only one module block. Here, we loop through a map object that defines all the different roles to assign at the scope (in this case a Resource group). In the `role` map object, we supply a list of principal IDs (objectID) that will be assigned the role. While slightly more complex to write initially, it does mean assigning new roles in the future is simpler as you would only need to edit the `locals` block with a new list within the map. For example:

initial deployment
```
locals {
  role = {
    "Reader" = ["ObjevctID-2334-53rd-dummyID", "4IDIDID-7349-DUMMYID-OBJECTf"],
    "Owner"       = ["a63120c8-4338-86es-dummyID"]
  }
}
```

Adding a new role assignment
```
locals {
  role = {
    "Reader"      = ["ObjevctID-2334-53rd-dummyID", "4IDIDID-7349-DUMMYID-OBJECTf"],
    "Owner"       = ["a63120c8-4338-86es-dummyID"],
    "Contributor" = ["exRoleId456-8ygds-CntrAcc355-1234", "another-Obj3ctID-f0r-CntrAcc355"]
  }
}
```

### Example showing a simple deployment. Using separate modules for assigning different roles at the same scope (Resource Group is shown here but could be any valid Azure resource).

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


module "owner_assignment" {
  source   = "../../"

  role_definition_name = "Owner"
  scope_id             = local.rg_id
  principal_ids        = local.Owner_principals
}

module "contributor_assignment" {
  source   = "../../"

  role_definition_name = "Contributor"
  scope_id             = local.rg_id
  principal_ids        = local.Contributor_principals
}

```

### Example showing a deployment of different Roles, to different principals, at the same scope using `for_each` at the `module`.

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


module "role_assignment" {
  for_each = local.role
  source   = "../../"

  role_definition_name = each.key
  scope_id             = local.rg_id
  principal_ids        = each.value
}

```


## testing

Several tests have been written for this module using the experimenal Terraform feature `terraform test`. These are currently simple in nature, and using just the terraformn output from a deployment of the module to ensure that the module does what it says on the tin. These can be found in ./tests directory.


