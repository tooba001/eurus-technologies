module "Vpc" {
  source          =  "./modules/vpc"
  vpc_cidr_block  =  "10.0.0.0/16"

}

   
module "lbsecuritygroups" {
  source      = "./modules/loadbalancer_sg" 
  vpc_id      =  module.Vpc.vpc_id
  lb_ingress_rules = local.lb_ingress_rules
  lb_egress_rules  = local.lb_egress_rules

}
module "dbsecuritygroups" {
  source      = "./modules/db_sg" 
  vpc_id      = module.Vpc.vpc_id
  db_ingress_rules = local.db_ingress_rules

  
}
module "websecuritygroups" {
  source      = "./modules/webserver_sg" 
  vpc_id      = module.Vpc.vpc_id
  web_ingress_rules = local.web_ingress_rules
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
  vpc_security_group_ids = [module.dbsecuritygroups.rds_securitygroup_id]
  subnet_ids = [module.Vpc.private_subnet_id_1, module.Vpc.private_subnet_id_2]
  security_groups = [module.websecuritygroups.webserver_securitygroup_id]
  wp_db_password = var.wp_db_password
  
}
module "LoadBalancer" {
  source              = "./modules/loadbalancer"
  vpc_id   = module.Vpc.vpc_id
  target_group_name   = var.target_group_name
  load_balancer_name  = var.load_balancer_name
  instance_type       = var.instance_type
  ami_id              = var.ami_id
  launch_template_name_prefix   = var.launch_template_name_prefix
  key_pair_name       =  var.key_pair_name
  security_groups     = [module.lbsecuritygroups.lb_securitygroup_id]
  subnets            = [
    module.Vpc.public_subnet_id_1,
    module.Vpc.public_subnet_id_2
 ]
 rds_endpoint = module.databases.rds_endpoint
 security_group = [module.websecuritygroups.webserver_securitygroup_id]
 subnet_id                   = module.Vpc.public_subnet_id_1 
 db_password = var.db_password
 wp_db_password = var.wp_db_password
}


module "Autoscalings" {
  source                     = "./modules/autoscaling"
  auto_scaling_group_name    =  "wordpressautoscaling"
  min_size                   =       1
  max_size                   =       3
  desired_capacity           =       2
  health_check_type          =      "EC2"
  loadbalancer_launch_template_id = module.LoadBalancer.launch_template_id
  target_group_arns_id = module.LoadBalancer.target_group_arns     
  vpc_zone_identifier  = [module.Vpc.public_subnet_id_1, module.Vpc.public_subnet_id_2]
}