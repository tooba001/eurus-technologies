
resource "aws_codebuild_project" "my_project" {
  name          = var.codebuild.name
  description   = var.codebuild.description
  build_timeout = var.codebuild.build_timeout
  service_role  = var.roles_arns["terraform_codebuild_role_abc"]
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

resource "aws_codepipeline" "code_pipeline" {
  name     = var.code-pipeline.name
  role_arn  = var.roles_arns["terraform_codepipeline_role_abc"]

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
