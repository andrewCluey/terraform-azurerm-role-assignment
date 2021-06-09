variable "custom_role_definition_id" {
  type        = string
  description = "description"
  default     = null
}

variable "builtin_role_definition_name" {
    type        = any
    description = "description"
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

