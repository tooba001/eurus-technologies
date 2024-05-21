variable "target_group_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "load_balancer_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "ID of the Amazon Machine Image (AMI) to use for the EC2 instances"
  type        = string
  
}


variable "key_pair_name" {
  description = "The name of the key pair to use for EC2 instances"
  type        = string
}

variable "launch_template_name_prefix" {
  description = "Prefix for the launch template name"
  type        = string
}

variable "webserver_user_data_template" {
  description = "Path to the web server user data template file"
  type        = string
  default     = "templates/webserver_user_data.tpl"  # Specify the path relative to the root directory
}

variable "vpc_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
} 

variable "subnets" {
  type = list(string)
} 

variable "rds_endpoint" {
  type = string
}

variable "security_group" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}   