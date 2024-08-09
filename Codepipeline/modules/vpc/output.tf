output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# output "subnets_id" {
# value = { for name, subnet in aws_subnet.subnets : name => subnet.id }
# }

output "subnet_ids" {
  value = { for key, subnet in aws_subnet.subnets : key => subnet.id }
}

