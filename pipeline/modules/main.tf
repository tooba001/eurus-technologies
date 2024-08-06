module "Vpc" {
  source          =  "./modules/vpc"
 vpc_config = var.vpc_config
}

module "securitygroup" {
  source = "./modules/securitygroups"
  vpc_id = module.Vpc.vpc_id
  ingress_rules = var.ingress_rules
  egress_rules = var.egress_rules
}

module "loadbalancer"{
  source              = "./modules/loadbalancer"
  vpc_id   = module.Vpc.vpc_id
  load_balancer_config = var.load_balancer_config
  security_groups = [module.securitygroup.security_group_id]
  subnets            = [
    module.Vpc.public_subnet_id_1,
    module.Vpc.public_subnet_id_2
  ]
}

module "ECR_Repo" {
  source = "./modules/ECR"
  ecr_repo_name = var.ecr_repo_name
}

module "ECS_Cluster" {
  source = "./modules/ECS"
  ecs_cluster_name = var.ecs_cluster_name
  ecs_task_definition = var.ecs_task_definition
  ecs_service = var.ecs_service
  security_group_ids = [module.securitygroup.security_group_id]
  #target_group_arn = module.loadbalancer.target_group_arn[0]
  subnet_ids = [module.Vpc.public_subnet_id_1, module.Vpc.public_subnet_id_2]
  #load_balancer = var.load_balancer
}

module "code-pipeline" {
  source = "./modules/pipeline"
  codebuild = var.codebuild
  #codebuild_role_config = var.codebuild_role_config
  code-pipeline = var.code-pipeline
}








