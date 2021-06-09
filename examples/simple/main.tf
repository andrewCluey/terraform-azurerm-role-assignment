

module "role_assignment" {
    source = "../../"

    scope_id                    = "/subscriptions/7df4fea2-d719-4abe-890b-37cd0298be98"
    builtin_role_definition_name = "Contributor"
    principal_id                = "4c9e9244-319f-497c-b6f7-399bc80c559e"
    
}
