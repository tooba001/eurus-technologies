# Ensure the log group exists
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/terraform-container-abc"
  retention_in_days = 14
}

resource aws_ecs_cluster"ecs_cluster" {
   name= var.ecs_cluster_name
}

# Define IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ECS_TaskExecution_Roles_1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# Attach ECS Task Execution Role Policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Define IAM Role for ECS Task
resource "aws_iam_role" "ecs_task_role" {
  name = "ECS_Task_Roles_1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AdministratorAccess Policy to ECS Task Role
resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "ecs_logs_policy" {
  name        = "ECS_logs_policy_1"
  description = "Allows ECS tasks to create log groups and streams, and put log events."
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_logs_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_logs_policy.arn
}



resource "aws_ecs_task_definition" "terraform_task" {
  family                   = var.ecs_task_definition.family
  container_definitions    = var.ecs_task_definition.container_definitions
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = var.ecs_task_definition.network_mode
  requires_compatibilities = var.ecs_task_definition.requires_compatibilities
  cpu                      = var.ecs_task_definition.cpu
  memory                   = var.ecs_task_definition.memory
}

resource "aws_ecs_service" "my_service" {
  name            = var.ecs_service.service_name
  cluster         = var.ecs_service.cluster_name
  task_definition = aws_ecs_task_definition.terraform_task.arn
  desired_count   = var.ecs_service.desired_count
  launch_type     = var.ecs_service.launch_type
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }
  force_new_deployment = true
}





