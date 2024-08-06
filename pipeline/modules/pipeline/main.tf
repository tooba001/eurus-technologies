
resource "aws_iam_role" "code_builds_role" {
  name = "code_builds_role_1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy" "codebuilds_policy" {
  name = "codebuilds_policy"
  role = aws_iam_role.code_builds_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:GetObject",
          "s3:PutObject",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue",
          "codepipeline:PutJobSuccessResult",
          "codepipeline:PutJobFailureResult",
          "codepipeline:PutActionRevision",
          "codepipeline:PutApprovalResult",
          "sts:AssumeRole"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "ecr:GetAuthorizationToken",
        Resource = "*"
      },
    ]
  })
}

resource "aws_codebuild_project" "my_project" {
  name          = var.codebuild.name
  description   = var.codebuild.description
  build_timeout = var.codebuild.build_timeout
  service_role  = aws_iam_role.code_builds_role.arn
  source {
    type            = var.codebuild.source_type
    location        = var.codebuild.source_location
    buildspec       = var.codebuild.buildspec_file  
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    environment_variable {
      name  = "docker_image"
      value = var.codebuild.Docker_image
    }
    environment_variable {
      name = "ecr_repository"
      value = var.codebuild.repository_uri
    }
}
}

#Code pipeline role 
resource "aws_iam_role" "code_pipelines_role" {
  name = "code_pipelines_role_1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

#Attach necessary policies

resource "aws_iam_role_policy" "codepipelines_policy" {
  name = "codepipelines_policy"
  role = aws_iam_role.code_pipelines_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:*",
          "codebuild:*",
          "ecs:*",
          "ecr:*",
          "iam:PassRole",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_codepipeline" "code_pipeline" {
  name     = var.code-pipeline.name
  role_arn  = aws_iam_role.code_pipelines_role.arn

  artifact_store {
    location = var.code-pipeline.artifact_bucket
    type     = "S3"
  }

  dynamic "stage" {
    for_each = var.code-pipeline.stages
    content {
      name = stage.value.name

      action {
        name            =  stage.value.name
        category        =  stage.value.category
        owner           =  stage.value.owner
        provider        =  stage.value.provider
        version         =  stage.value.version
        configuration   =  stage.value.configuration
        input_artifacts  = stage.value.input_artifacts
        output_artifacts = stage.value.output_artifacts
      }
    }
  }
}
