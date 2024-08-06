
variable "vpc_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
} 

variable "subnets" {
  type = list(string)
} 


variable "load_balancer_config" {
  description = "Configuration for the Load Balancer, target group, and health check"
  type = list(object({
    load_balancer_name       = string
    target_groups            = list(object({
    target_group_name        = string
    target_group_port        = number
    target_group_protocol    = string
    enable_https             = bool
    certificate_arn          = string
        }))
   health_check = object({
        protocol            = string
        port                = string
        enabled             = bool
        path                = string
        healthy_threshold   = number
        unhealthy_threshold = number
        timeout             = number
        interval            = number
      })
    }))
  }