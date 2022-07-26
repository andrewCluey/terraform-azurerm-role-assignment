output "role_assignments" {
    value = azurerm_role_assignment.role_assignment
    description = <<EOD
    Displays the full output of the role assignment in a map format.
    EXAMPLE:
    all_role_assignments = {
        "assignCustomRole" = {
            "role_assignments" = {
                "ewarfers-4reab-9e70-876yg98y87g" = {
                "condition" = ""
                "condition_version" = ""
                "delegated_managed_identity_resource_id" = ""
                "description" = ""
                "id" = "/subscriptions/dsfcsdfs-be98-7tgt/providers/Microsoft.Authorization/roleAssignments/6t876tg-78yige"
                "name" = "123-abc-45-6789-12ab-d120-aabuig"
                "principal_id" = "ewarfers-4reab-9e70-876yg98y87"
                "principal_type" = "User"
                "role_definition_id" = "/subscriptions/dsfcsdfs-be98-7tgt/providers/Microsoft.Authorization/987687tg-1c0d-1234-abcde-o98y97g"
                "role_definition_name" = "customeader"
                "scope" = "/subscriptions/dsfcsdfs-be98-7tgt"
                "skip_service_principal_aad_check" = false
                "timeouts" = null /* object */
      }
    }
  }
EOD
}


#output "assignment_id" {
#  description = "The ID of the Role Assignment"
#  value       = azurerm_role_assignment.role_assignment[each.key].id
#}

output "scope" {
  description = "The scope at which the role assignment is to be assigned."
  value = [for k in azurerm_role_assignment.role_assignment : k.scope ]
}
