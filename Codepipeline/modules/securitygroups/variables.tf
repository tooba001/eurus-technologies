variable "vpc_id" {
   type = string
}

variable "ingress_rules" {
  description = "Map of ingress rules for the  security group"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))

}


variable "egress_rules" {
  description = "Map of egress rules for the security group"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))

}

variable "security_group_name" {
  type = string
}