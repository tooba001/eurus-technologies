variable "vpc_config" {
  description = "CIDR block for the VPC"
  type        = object({
    vpc_cidr_block = string
    private_subnet1_cidr_block = string
    private_subnet2_cidr_block = string
    public_subnet1_cidr_block = string
    public_subnet2_cidr_block = string
  })

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_config.vpc_cidr_block)) && can(cidrsubnet(var.vpc_config.vpc_cidr_block, 0, 0))
    error_message = "The VPC CIDR block must be a valid CIDR block, such as 10.0.0.0/16."
  }
}


variable "ingress_rules" {
  description = "List of ingress rules to apply to the security group."
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  description = "List of egress rules to apply to the security group."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "load_balancer_config" {
  description = "Configuration for the Load Balancer, target group, and health check"
  type = list(object({
    load_balancer_name       = string
    target_groups            = list(object({
    target_group_name        = string
    target_group_port        = number
    target_group_protocol    = string
    enable_https             = bool
    certificate_arn          = string
        }))
   health_check = object({
        protocol            = string
        port                = string
        enabled             = bool
        path                = string
        healthy_threshold   = number
        unhealthy_threshold = number
        timeout             = number
        interval            = number
      })
    }))
  }

variable "ecr_repo_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

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

variable "ecs_task_definition" {
  description = "ECS task definition configuration"
  type = object({
    family                   = string
    container_definitions    = string
    #execution_role_arn       = string
    #task_role_arn            = string
    network_mode             = string
    requires_compatibilities = list(string)
    cpu                      = string
    memory                   = string
  })
}


variable "ecs_service" {
  description = "ECS service configuration"
  type = object({
    cluster_name        = string
    service_name        = string
    desired_count       = number
    launch_type         = string
  })
}


# variable "load_balancer" {
#   type = object({
#     container_name = string
#     container_port = number
#   })
# }