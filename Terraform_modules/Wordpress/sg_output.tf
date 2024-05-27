output "rds_securitygroup_id" {
    value= aws_security_group.rds_sg.id
}

output "lb_securitygroup_id" {
  description = "ID of the VPC"
  value       = aws_security_group.alb_sg.id
}

output "webserver_securitygroup_id" {
  description = "ID of the VPC"
  value       = aws_security_group.web_sg.id
}