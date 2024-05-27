variable "vpc_id" {
  type = string
} 

variable "lb_ingress_rules" {
  description = "Map of ingress rules for the load balancer security group"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

}

variable "lb_egress_rules" {
  description = "Map of egress rules for the security group"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

}

variable "db_ingress_rules" {
  description = "Map of ingress rules for the rds  security group"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = list(string)
  }))
}
