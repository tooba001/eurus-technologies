vpc_config = {
  vpc_cidr_block = "10.0.0.0/16"
  subnet_cidr_blocks = {
    private_subnet1 = "10.0.1.0/24"
    private_subnet2 = "10.0.2.0/24"
    public_subnet1  = "10.0.3.0/24"
    public_subnet2  = "10.0.4.0/24"
  }
}

security_group_name = "vpc-securitygroup"

ingress_rules = {
  "http" = {
    description     = "Allow HTTP traffic"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = []
  }

  "ssh" = {
    description     = "Allow SSH traffic"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = []
  }
}

egress_rules = {
  "all_traffic" = {
    description     = "Allow all outbound traffic"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = []
  }
}

load_balancer_config = [
  {
    load_balancer_name = "load-balancer"
    target_groups = [
      {
        target_group_name     = "target-group"
        target_group_port     = 80
        target_group_protocol = "HTTP"
        enable_https          = false
        certificate_arn       = ""
        health_check = [
          {
            protocol            = "HTTP"
            port                = "traffic-port"
            enabled             = true
            path                = "/health"
            healthy_threshold   = 3
            unhealthy_threshold = 2
            timeout             = 5
            interval            = 30
          }
        ]
      }
    ]
  }      
]

ecr_repo_name = "terraform-code-pipeline-repo"
# ecs_config = {
#   cluster_name = "tooba-cluster"
#   task_definitions = [
#     {
#       family                   = "nginix-task-family"
#       container_definitions    = [
#         {
#           name          = "nginix-container-1"
#           image         = "489994096722.dkr.ecr.us-west-1.amazonaws.com/terraform-code-pipeline-repo:latest"
#           memory        = 1024
#           cpu           = 1024
#           essential     = true
#           port_mappings = [
#             {
#               container_port = 80
#               host_port      = 80
#             }
#           ]
#           log_configuration = {
#             log_driver = "awslogs"
#             options = {
#               "awslogs-group"         = "/ecs/terraform-container-abc"
#               "awslogs-region"        = "us-west-1"
#               "awslogs-stream-prefix" = "ecs"
#             }
#           }
#         }
#       ]
#       network_mode             =  "awsvpc"
#       requires_compatibilities = ["FARGATE"]
#       cpu                      = "1024"
#       memory                   = "2048"
#     },
#     {
#       family                   = "wordpress-task-family"
#       container_definitions    = [
#         {
#           name          = "wordpress-container-1"
#           image         = "wordpress:latest"
#           memory        = 1024
#           cpu           = 1024
#           essential     = true
#           port_mappings = [
#             {
#               container_port = 80
#               host_port      = 80
#             }
#           ]
#           log_configuration = {
#             log_driver = "awslogs"
#             options = {
#               "awslogs-group"         = "/ecs/terraform-container-abc"
#               "awslogs-region"        = "us-west-1"
#               "awslogs-stream-prefix" = "ecs"
#             }
#           }
#         }
#       ]
#       network_mode             = "awsvpc"
#       requires_compatibilities = ["FARGATE"]
#       cpu                      = "1024"
#       memory                   = "2048"
#     }
#   ]
#   services = [
#     {
#       service_name = "nginix-service-1"
#       desired_count = 1
#       launch_type = "FARGATE"
#       load_balancer = {
#         target_group_name = "target-group"
#         container_name    = "nginix-container-1"
#         container_port    = 80
#       }
#     },
#     {
#       service_name = "wordpress-service-2"
#       desired_count = 1
#       launch_type = "FARGATE"
#       load_balancer = {
#         target_group_name = "target-group"
#         container_name    = "wordpress-container-1"
#         container_port    = 80
#       }
#     }
#   ]
# }

ecs_config = {
  fargate = {
    cluster_name = "fargate-cluster"
    task_definitions = [
      {
        family                   = "fargate-task-family"
        container_definitions    = [
          {
            name          = "fargate-container-1"
            image         = "489994096722.dkr.ecr.us-west-1.amazonaws.com/terraform-code-pipeline-repo:latest"
            memory        = 1024
            cpu           = 1024
            essential     = true
            port_mappings = [
              {
                container_port = 80
                host_port      = 80
              }
            ]
            log_configuration = {
              log_driver = "awslogs"
              options = {
                "awslogs-group"         = "/ecs/terraform-container-xyz"
                "awslogs-region"        = "us-west-1"
                "awslogs-stream-prefix" = "ecs"
              }
            }
          }
        ]
        network_mode             = "awsvpc"
        requires_compatibilities = ["FARGATE"]
        cpu                      = "1024"
        memory                   = "2048"
      }
    ]
    services = [
      {
        service_name = "fargate-service-1"
        desired_count = 1
        launch_type = "FARGATE"
      #   load_balancer = {
      #     target_group_name = "fargate-target-group"
      #     container_name    = "fargate-container-1"
      #     container_port    = 80
      #   }
       }
    ]
  }
  ec2 = {
    cluster_name = "ec2-cluster"
    task_definitions = [
      {
        family                   = "ec2-task-family"
        container_definitions    = [
          {
            name          = "ec2-container-1"
            image         = "nginix:latest"
            memory        = 1024
            cpu           = 1024
            essential     = true
            port_mappings = [
              {
                container_port = 80
                host_port      = 80
              }
            ]
            log_configuration = {
              log_driver = "awslogs"
              options = {
                "awslogs-group"         = "/ecs/terraform-container-xyz"
                "awslogs-region"        = "us-west-1"
                "awslogs-stream-prefix" = "ecs"
              }
            }
          }
        ]
        network_mode             = "bridge"
        requires_compatibilities = ["EC2"]
        cpu                      = "1024"
        memory                   = "2048"
      }
    ]
    services = [
      {
        service_name = "ec2-service-1"
        desired_count = 1
        launch_type = "EC2"
        load_balancer = {
          target_group_name = "target-group"
          container_name    = "ec2-container-1"
          container_port    = 80
        }
      }
    ]
  }
}

codebuild = ({
      name = "Terraform-Code-Build-xyz"
      description = "Build project for Docker image"
      build_timeout = "5"
      repository_uri = "489994096722.dkr.ecr.us-west-1.amazonaws.com/terraform-code-pipeline-repo"
      Docker_image =   "489994096722.dkr.ecr.us-west-1.amazonaws.com/terraform-code-pipeline-repo"
      source_type = "GITHUB"
      source_location = "https://github.com/tooba001/codepipeline"
      buildspec_file = "buildspec.yml"
    })


code-pipeline = {
  name             = "Terraform-Code-Pipeline-xyz"
  artifact_bucket  = "tooba-bucket"
  
  github_config = {
    owner       = "tooba001"
    repo        = "codepipeline"
    branch      = "main"
    oauth_token = "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"
  }

  codebuild = {
    name = "terraform-codebuild-project"
  }

  ecs = {
    name =    "fargate-service-1"
    cluster = "fargate-cluster"
  }

  stages = [
    {
      name            = "Source"
      category        = "Source"
      owner           = "ThirdParty"
      provider        = "GitHub"
      version         = "1"
      action_name     = "GitHubSource"
      configuration   = {
        Owner      = "tooba001"
        Repo       = "codepipeline"
        Branch     = "main"
        OAuthToken = "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"
      }
      input_artifacts  = []
      output_artifacts = ["source_output"]
    },
    {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      action_name     = "Build"
      configuration   = {
        ProjectName = "terraform-codebuild"
      }
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
    },
    {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      action_name     = "Deploy"
      configuration   = {
        ClusterName = "fargate-cluster"
        ServiceName = "fargate-service-1"
        FileName    = "imagedefinitions.json"
      }
      input_artifacts  = ["build_output"]
      output_artifacts = []
    }
  ]
}



iam_roles_config = [
    {
      role_name          = "terraform_codebuild_role_abc"
      assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
      policy_name        = "terraform_codebuild_policy_1"
      policy_description = "Common policy for CodeBuild, ECS Task Role, ECS Task Execution Role, and CodePipeline"
      policy_statements  = [
        {
          effect   = "Allow"
          actions  = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "s3:*", "ecr:*", "ssm:GetParameters", "secretsmanager:GetSecretValue", "codepipeline:*", "codedeploy:*", "codebuild:*", "ecs:*", "iam:PassRole"]
          resources = ["*"]
        }
      ]
    },
    {
      role_name          = "terraform_ecs_task_role_abc"
      assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
      policy_name        = "terraform_ecs_task_policy_1"
      policy_description = "Common policy for CodeBuild, ECS Task Role, ECS Task Execution Role, and CodePipeline"
      policy_statements  = [
        {
          effect   = "Allow"
          actions  = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "s3:*", "ecr:*", "ssm:GetParameters", "secretsmanager:GetSecretValue", "codepipeline:*", "codedeploy:*", "codebuild:*", "ecs:*", "iam:PassRole"]
          resources = ["*"]
        }
      ]
    },
    {
      role_name          = "terraform_ecs_task_execution_role_abc"
      assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
      policy_name        = "terraform_ecs_task_execution_policy_1"
      policy_description = "Common policy for CodeBuild, ECS Task Role, ECS Task Execution Role, and CodePipeline"
      policy_statements  = [
        {
          effect   = "Allow"
          actions  = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "s3:*", "ecr:*", "ssm:GetParameters", "secretsmanager:GetSecretValue", "codepipeline:*", "codedeploy:*", "codebuild:*", "ecs:*", "iam:PassRole"]
          resources = ["*"]
        }
      ]
    },
    {
      role_name          = "terraform_codepipeline_role_abc"
      assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
      policy_name        = "terraform_codepipeline_policy_1"
      policy_description = "Common policy for CodeBuild, ECS Task Role, ECS Task Execution Role, and CodePipeline"
      policy_statements  = [
        {
          effect   = "Allow"
          actions  = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "s3:*", "ecr:*", "ssm:GetParameters", "secretsmanager:GetSecretValue", "codepipeline:*", "codedeploy:*", "codebuild:*", "ecs:*", "iam:PassRole"]
          resources = ["*"]
        }
      ]
    }
  ]

ec2_instance = {
  name = "ecs_instance_xyz_1234567"
  image_id =  "ami-0fda60cefceeaa4d3"
  instance_type = "t2.micro"
  key_name = "tooba-kpr-1"
}

autoscaling_group ={
    min_size = 1
    max_size = 1
    desired_capacity = 1
}



