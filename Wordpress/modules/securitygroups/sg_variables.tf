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

/*variable "security_groups_config" {
  description = "Map of security group configurations"
  type = map(object({
    name          = string
    description   = string
    ingress_rules = list(object({
      description    = string
      from_port      = number
      to_port        = number
      protocol       = string
      cidr_blocks    = optional(list(string), [])
      security_groups = optional(list(string), [])
    }))
    egress_rules = list(object({
      description    = string
      from_port      = number
      to_port        = number
      protocol       = string
      cidr_blocks    = optional(list(string), [])
      security_groups = optional(list(string), [])
    }))
  }))
}*/



