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

 variable "vpc_security_group_ids" {
  type = list(string)
 }

variable "subnet_id" {
  type = string
}  


 variable "subnet_ids" {
  type = list(string)
 }

 variable  "security_groups" {
  type = list(string)
 }

variable "wp_db_password" {
  description = "wordpress Database password"
  type        = string
  sensitive   = true  # Mark the variable as sensitive
}