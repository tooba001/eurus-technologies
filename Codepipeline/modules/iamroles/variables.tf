
variable "iam_roles_config" {
  description = "Configuration for IAM roles and their policies"
  type = list(object({
    role_name             = string
    assume_role_policy    = string
    policy_name           = string
    policy_description    = string
    policy_statements     = list(object({
      effect   = string
      actions  = list(string)
      resources = list(string)
    }))
  }))
}

