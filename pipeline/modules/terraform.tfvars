vpc_config = ({
vpc_cidr_block             = "10.0.0.0/16"
private_subnet1_cidr_block = "10.0.1.0/24"
private_subnet2_cidr_block = "10.0.2.0/24"
public_subnet1_cidr_block = "10.0.3.0/24"
public_subnet2_cidr_block = "10.0.4.0/24"
})
# Ingress Rules
ingress_rules = {
  "allow_http" = {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # "allow_ssh" = {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }s
}

# Egress Rulesssss
egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

load_balancer_config = [{
  load_balancer_name     = "load-balancer"
  target_groups = [ {
  target_group_name      = "target-group"
  target_group_port      = 80
  target_group_protocol  = "HTTP"
  enable_https           = false
  certificate_arn        = ""
  } ]
  health_check = {
    protocol            = "HTTP"
    port                = "80"
    enabled             = true
    path                = "/"
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 15
    interval            = 20
  }
}]
ecr_repo_name = "terraform-code-pipeline-repo"
ecs_cluster_name = "terraform-code-pipeline-ecs-cluster"
ecs_task_definition = {
  family = "terraform-ecs-task-family"
  container_definitions = <<DEFINITION
[
  {
    "name": "terraform-container-abc",
    "image": "489994096722.dkr.ecr.us-west-1.amazonaws.com/terraform-code-pipeline-repo:latest",
    "memory": 1024,
    "cpu": 1024,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
     "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/terraform-container-abc",
        "awslogs-region": "us-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
}
ecs_service =({
    cluster_name        = "terraform-code-pipeline-ecs-cluster"
    service_name        = "terraform"
    desired_count       = 1
    launch_type         = "FARGATE"
  })
# load_balancer = ({
#   container_name = "terraform-container"
#   container_port = 80
# # }
codebuild = ({
      name = "Terraform-Code-Build-1"
      description = "Build project for Docker image"
      build_timeout = "5"
      repository_uri = "489994096722.dkr.ecr.us-west-1.amazonaws.com/terraform-code-pipeline-repo"
      Docker_image =   "489994096722.dkr.ecr.us-west-1.amazonaws.com/terraform-code-pipeline-repo"
      source_type = "GITHUB"
      source_location = "https://github.com/tooba001/codepipeline"
      buildspec_file = "buildspec.yml"
    })

# codebuild_role_config = {
#   name = "codebuild_role"
#   assume_role_policy_document = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "codebuild.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       },
#     ]
#   })
# }

code-pipeline = {
  name             = "Terraform-Code-Pipeline-1"
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
    name = "terraform-code-pipeline-ecs-cluster"
    cluster = "terraform-code-pipeline-ecs-service"
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
        ClusterName = "terraform-code-pipeline-ecs-cluster"
        ServiceName = "terraform-code-pipeline-ecs-service"
        FileName    = "imagedefinitions.json"
      }
      input_artifacts  = ["build_output"]
      output_artifacts = []
    }
  ]
}


