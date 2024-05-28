
output "target_group_arns" {
  description = "ID of the VPC"
  value       = [aws_lb_target_group.wptargetgroup.id]
}


