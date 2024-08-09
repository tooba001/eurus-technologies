# Ensure the log group exists
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/terraform-container-xyz"
  retention_in_days = 14
}

resource aws_ecs_cluster"ecs_cluster" {
   name= var.ecs_config.fargate.cluster_name
}


# ECS Task Definitions
resource "aws_ecs_task_definition" "terraform_task" {
  for_each = { for idx, task_def in var.ecs_config.fargate.task_definitions : idx => task_def }

  family                   = each.value.family
  container_definitions    =  jsonencode([
    for container in each.value.container_definitions : {
      name          = container.name
      image         = container.image
      memory        = container.memory
      cpu           = container.cpu
      essential     = container.essential
      portMappings = [
        for port_mapping in container.port_mappings : {
          containerPort = port_mapping.container_port
          hostPort      = port_mapping.host_port
        }
      ]
      logConfiguration = {
        logDriver = container.log_configuration.log_driver
        options   = container.log_configuration.options
      }
    }
  ])
  execution_role_arn       = var.iam_roles_arns["terraform_ecs_task_execution_role_abc"]
  task_role_arn            = var.iam_roles_arns["terraform_ecs_task_role_abc"]
  network_mode             = each.value.network_mode
  requires_compatibilities = each.value.requires_compatibilities
  cpu                      = each.value.cpu
  memory                   = each.value.memory

}

# ECS Services
resource "aws_ecs_service" "my_service" {
  for_each = { for idx, svc in var.ecs_config.fargate.services : idx => svc }

  name            = each.value.service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.terraform_task[each.key].arn
  desired_count   = each.value.desired_count
  launch_type     = each.value.launch_type
  # load_balancer {
  #   target_group_arn = var.target_group_arn[each.value.load_balancer.target_group_name]
  #   container_name   = each.value.load_balancer.container_name
  #   container_port   = each.value.load_balancer.container_port
  # }
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }
  force_new_deployment = true
}





