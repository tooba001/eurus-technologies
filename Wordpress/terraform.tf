module "Vpc" {
  source          =  "./modules/vpc"
  vpc_cidr_block  =  var.vpc_cidr_block

}

module "securitygroup_alb" {
  source       = "./modules/securitygroups"
  vpc_id       = module.Vpc.vpc_id
  security_group_name = "alb-security-group"
  ingress_rules = local.lb_ingress_rules
  egress_rules = local.lb_egress_rules
}




module "securitygroup_rds" {
  source       = "./modules/securitygroups"
  vpc_id       = module.Vpc.vpc_id
  security_group_name = "rds-security-group"
  ingress_rules = local.db_ingress_rules
  egress_rules = local.db_egress_rules
}

module "securitygroup_web" {
  source       = "./modules/securitygroups"
  vpc_id       = module.Vpc.vpc_id
  security_group_name = "web-security-group"
  ingress_rules = local.web_ingress_rules
  egress_rules = local.web_egress_rules
}
  
module "databases" {
  source              = "./modules/database"
  db_instance_type             = var.db_instance_type
  db_engine  =  var.db_engine
  db_engine_version =  var.db_engine_version
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  parameter_group_name = var.parameter_group_name
  instance_type = var.instance_type
  ami_id = var.ami_id
  key_pair_name = var.key_pair_name
  subnet_id     = module.Vpc.public_subnet_id_1 
  vpc_security_group_ids = [module.securitygroup_rds.securitygroup_id]
  subnet_ids = [module.Vpc.private_subnet_id_1, module.Vpc.private_subnet_id_2]
  security_groups = [module.securitygroup_web.securitygroup_id]
  wp_db_password = var.wp_db_password
  
}
module "LoadBalancer" {
  source              = "./modules/loadbalancer"
  vpc_id   = module.Vpc.vpc_id
  target_group_name   = var.target_group_name
  load_balancer_name  = var.load_balancer_name
  security_groups     = [module.securitygroup_alb.securitygroup_id]
  subnets            = [
    module.Vpc.public_subnet_id_1,
    module.Vpc.public_subnet_id_2
 ]
}

module "Autoscalings" {
  source                     = "./modules/autoscaling"
  auto_scaling_group_name    =  "wordpressautoscaling"
  min_size                   =       1
  max_size                   =       3
  desired_capacity           =       2
  health_check_type          =      "EC2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_pair_name       =  var.key_pair_name
  launch_template_name_prefix   = var.launch_template_name_prefix
  target_group_arns_id = module.LoadBalancer.target_group_arns     
  vpc_zone_identifier  = [module.Vpc.public_subnet_id_1, module.Vpc.public_subnet_id_2]
  rds_endpoint = module.databases.rds_endpoint
  wp_db_password = var.wp_db_password
  subnet_id                   = module.Vpc.public_subnet_id_1 
  security_groups = [module.securitygroup_web.securitygroup_id]
}


