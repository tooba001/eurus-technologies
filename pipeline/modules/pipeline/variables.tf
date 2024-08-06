variable "codebuild" {
    description = "codebuild variables"
    type = object({
      name = string
      description = string
      build_timeout = string
      repository_uri = string
      Docker_image = string
      source_type = string
      source_location = string
      buildspec_file = string
    })
}

# variable "codebuild_role_config" {
#   description = "Configuration for the CodeBuild IAM role, including name and assume role policy document"
#   type = object({
#     name                   = string
#     assume_role_policy_document = string
#   })
# }

variable "code-pipeline" {
  description = " variables for code pipeline"
  type = object({
    name = string
    artifact_bucket = string
    github_config = object({
      owner = string
      repo = string
      branch = string
      oauth_token = string
    })
    codebuild = object({
      name = string
    })
    ecs = object({
      name = string
      cluster = string
    })
    stages = list(object({
       name = string
       category = string
       owner = string
       provider = string
       version = string
       configuration = map(string)
       input_artifacts = list(string)
       output_artifacts = list(string)
    }))
  })
}


