
resource aws_ecs_cluster"ecs_cluster" {
   name= var.ecs_config.ec2.cluster_name
}
# AMI 
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

# instance  role

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-Instance-Roles"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Attach policy

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# instance profile

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-Instance-Profile-1"
  role = aws_iam_role.ecs_instance_role.name
}



resource "aws_launch_configuration" "ecs_instance" {
  name           = var.ec2_instance.name
  image_id       = data.aws_ami.ecs_optimized.id # ECS-Optimized AMI ID
  instance_type  = var.ec2_instance.instance_type
  key_name       = var.ec2_instance.key_name
  security_groups = var.security_group_ids
  associate_public_ip_address = true
  iam_instance_profile  = aws_iam_instance_profile.ecs_instance_profile.name

   lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = 30
  }



  user_data = <<-EOF
              #!/bin/bash
              echo "ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name}" > /etc/ecs/ecs.config
              sudo yum update -y
              sudo amazon-linux-extras install docker
              sudo service docker start
              sudo systemctl enable docker
              sudo start ecs
              EOF
}



resource "aws_autoscaling_group" "ecs_asg" {
  launch_configuration = aws_launch_configuration.ecs_instance.id
  min_size             = var.autoscaling_group.min_size
  max_size             = var.autoscaling_group.max_size
  desired_capacity     = var.autoscaling_group.desired_capacity
  vpc_zone_identifier  = var.public_subnet_id
  target_group_arns    = [for key, arn in var.target_group_arn : arn]

  tag {
      key                 = "Name"
      value               = "ecs-instance"
      propagate_at_launch = true
  }

}

# ECS Task Definitions
resource "aws_ecs_task_definition" "terraform_task" {
  for_each = { for idx, task_def in var.ecs_config.ec2.task_definitions : idx => task_def }

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
  for_each = { for idx, svc in var.ecs_config.ec2.services : idx => svc }

  name            = each.value.service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.terraform_task[each.key].arn
  desired_count   = each.value.desired_count
  launch_type     = each.value.launch_type
  load_balancer {
    target_group_arn = var.target_group_arn[each.value.load_balancer.target_group_name]
    container_name   = each.value.load_balancer.container_name
    container_port   = each.value.load_balancer.container_port
  }

  force_new_deployment = true
}