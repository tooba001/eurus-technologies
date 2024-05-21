variable "auto_scaling_group_name" {
  description = "Name of the Auto Scaling group"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling group"
  type        = number
}

variable "max_size" {
  description = "Minimum number of instances in the Auto Scaling group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling group"
  type        = number
}

variable "health_check_type" {
  description = "Type of health check to use for instances in the Auto Scaling group"
  type        = string
}

variable  "loadbalancer_launch_template_id" {
  type = string
} 

variable "target_group_arns_id" {
  type = list(string)
 } 

variable "vpc_zone_identifier" {
  type =  list(string)
}