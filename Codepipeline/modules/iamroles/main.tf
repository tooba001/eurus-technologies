# Define IAM Role f
resource "aws_iam_role" "iam_roles" {
  for_each =  { for role in var.iam_roles_config : role.role_name  => role }
  name = each.value.role_name
  assume_role_policy = each.value.assume_role_policy
}


# IAM Policy
resource "aws_iam_policy" "iam_policies" {
  for_each    = { for role in var.iam_roles_config : role.policy_name => role }
  name        = each.value.policy_name
  description = each.value.policy_description
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      for statement in each.value.policy_statements : {
        Effect   = statement.effect
        Action   = statement.actions
        Resource = statement.resources
      }
    ]
  })
}

# Attach  Policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
for_each =   {for roles_policy in var.iam_roles_config : roles_policy.policy_name => roles_policy}
  role       =  aws_iam_role.iam_roles[each.value.role_name].name
  policy_arn =  aws_iam_policy.iam_policies[each.value.policy_name].arn
}

