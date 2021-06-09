module "role_assignment" {
    source = "../../"

    scope_id                     = var.subscriptions
    builtin_role_definition_name = "Contributor"
    principal_id                 = var.principal_id
}
