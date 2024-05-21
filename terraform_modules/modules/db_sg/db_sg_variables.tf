
variable "db_ingress_rules" {
  description = "Map of ingress rules for the rds  security group"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    security_groups = list(string)
  }))
}

variable "vpc_id" {
  type = string
} 

