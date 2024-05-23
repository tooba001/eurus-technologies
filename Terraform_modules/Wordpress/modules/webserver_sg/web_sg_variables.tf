variable "web_ingress_rules" {
  description = "Map of ingress rules for the load balancer security group"
  type = map(object({
    description      =     string
    from_port        =     number
    to_port          =     number
    protocol         =     string
    cidr_blocks      =     list(string)
    security_groups  =     list(string)
  }))

}

variable "vpc_id" {
  type = string
}  