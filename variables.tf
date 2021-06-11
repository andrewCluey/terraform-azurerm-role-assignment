variable "custom_role_definition_id" {
  type        = string
  description = "If assigning a custom role, enter the Scoped-ID of the Role Definition here. Conflicts with builtin_role_definition_name."
  default     = null
}

variable "builtin_role_definition_name" {
    type        = any
    description = "If assigning a built in role, enter the name here. If notusing this parameter, then 'custom_role_defintion_id' must be set. "
    default     = null
}

variable "scope_id" {
  type        = string
  description = "The Id of the scope where the role should be assigned. Can be subscription, Management group or Resource group."
}

variable "principal_id" {
  type        = string
  description = "description"
}

