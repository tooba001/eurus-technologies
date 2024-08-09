output "roles_arn"{
   value = { for name, role in aws_iam_role.iam_roles : name => role.arn }
}


