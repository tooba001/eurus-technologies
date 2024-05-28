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

variable "target_group_arns_id" {
  type = list(string)
 } 

variable "vpc_zone_identifier" {
  type =  list(string)
}

variable  "rds_endpoint" {
  type = string
} 

variable  "wp_db_password" {
  type = string
} 

variable  "launch_template_name_prefix" {
  type = string
} 

variable  "ami_id" {
  type = string
} 

variable  "instance_type" {
  type = string
} 

variable  "key_pair_name" {
  type = string
} 

variable  "subnet_id" {
  type = string
} 

variable  "security_groups" {
  type = list(string)
} 

variable "webserver_user_data_template" {
  description = "Path to the web server user data template file"
  type        = string
  default     = "templates/webserver_user_data.tpl"  # Specify the path relative to the root directory
}