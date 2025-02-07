variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_cidr_block)) && can(cidrsubnet(var.vpc_cidr_block, 0, 0))
    error_message = "The VPC CIDR block must be a valid CIDR block, such as 10.0.0.0/16."
  }
}


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

variable "db_instance_type" {
  description = "The instance type for the database"
  type        = string
}

variable "db_engine" {
  description = "The database engine (e.g., mysql, postgresql)"
  type        = string
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for accessing the database"
  type        = string
}


variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true  # Mark the variable as sensitive
}

variable "parameter_group_name" {
  description = "Name of the parameter group for the database"
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

variable "db_user_data_template" {
  description = "Path to the web server user data template file"
  type        = string
  default     = "templates/rds_user_data.tpl"  # Specify the path relative to the root directory
}

variable "target_group_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "load_balancer_name" {
  description = "Name of the Application Load Balancer"
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



variable "wp_db_password" {
  description = "wordpress Database password"
  type        = string
  sensitive   = true  # Mark the variable as sensitive
}

variable "lb_ingress_rules" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}