variable "target_group_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "load_balancer_name" {
  description = "Name of the Application Load Balancer"
  type        = string
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


 

