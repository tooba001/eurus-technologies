variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_cidr_block)) && can(cidrnetmask(var.vpc_cidr_block))
    error_message = "The VPC CIDR block must be a valid CIDR block, such as 10.0.0.0/16."
  }
}





