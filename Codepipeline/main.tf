module "Vpc" {
  source          =  "./modules/vpc"
 vpc_config = var.vpc_config
}



module "securitygroup" {
  source = "./modules/securitygroups"
  vpc_id = module.Vpc.vpc_id
  ingress_rules = var.ingress_rules
  egress_rules = var.egress_rules
  security_group_name = var.security_group_name
}

module "loadbalancer"{
  source              = "./modules/loadbalancer"
  vpc_id   = module.Vpc.vpc_id
  load_balancer_config = var.load_balancer_config
  security_groups = [module.securitygroup.security_group_id]
  subnets            = [
    module.Vpc.subnet_ids["public_subnet1"],
    module.Vpc.subnet_ids["public_subnet2"]
  ]
}

module "iam_role" {
  source = "./modules/iamroles"
  iam_roles_config = var.iam_roles_config
}

module "ECR_Repo" {
  source = "./modules/ECR"
  ecr_repo_name = var.ecr_repo_name
}

module "Fargate_Cluster" {
  source = "./modules/ECS"
  ecs_config = var.ecs_config
  security_group_ids = [module.securitygroup.security_group_id]
  subnet_ids = [
    module.Vpc.subnet_ids["public_subnet1"],
    module.Vpc.subnet_ids["public_subnet2"]
  ]
  iam_roles_arns = module.iam_role.roles_arn
  #target_group_arn = module.loadbalancer.target_group_arn
}

module "EC2_cluster" {
  source = "./modules/EC2"
  ecs_config = var.ecs_config
  security_group_ids = [module.securitygroup.security_group_id]
  iam_roles_arns = module.iam_role.roles_arn
  target_group_arn = module.loadbalancer.target_group_arn
  ec2_instance = var.ec2_instance
  autoscaling_group = var.autoscaling_group
  public_subnet_id = [module.Vpc.subnet_ids["public_subnet1"]]
}


module "code-pipeline" {
  source = "./modules/pipeline"
  codebuild = var.codebuild
  code-pipeline = var.code-pipeline
  roles_arns = module.iam_role.roles_arn
}




















