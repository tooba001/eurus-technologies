variable "vpc_config" {
  description = "Configuration for the VPC and its subnets"
  type = object({
    vpc_cidr_block           = string
    private_subnet1_cidr_block = string
    private_subnet2_cidr_block = string
    public_subnet1_cidr_block  = string
    public_subnet2_cidr_block  = string
  })

  validation {
    condition = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_config.vpc_cidr_block)) && can(cidrnetmask(var.vpc_config.vpc_cidr_block))
    error_message = "The VPC CIDR block must be a valid CIDR block, such as 10.0.0.0/16."
  }
}
