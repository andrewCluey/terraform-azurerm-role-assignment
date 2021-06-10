locals {
 custom_role  = var.custom_role_definition_id == null ? false:true
 builtin_role = var.builtin_role_definition_name == null ? false:true
}

resource "azurerm_role_assignment" "custom" {
    count = local.custom_role ? 1:0

    name                 = var.name
    scope                = var.scope_id 
    role_definition_id   = var.custom_role_definition_id 
    principal_id         = var.principal_id
}

resource "azurerm_role_assignment" "built_in" {
    count = local.builtin_role ? 1:0

    name                 = var.name
    scope                = var.scope_id 
    role_definition_name = var.builtin_role_definition_name
    principal_id         = var.principal_id
    
}


