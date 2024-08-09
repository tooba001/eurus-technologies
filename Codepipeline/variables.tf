variable "vpc_config" {
  description = "Configuration for the VPC and its subnets"
  type = object({
    vpc_cidr_block             = string
    subnet_cidr_blocks         = map(string)  # A map of subnet names to CIDR blocks
  })

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_config.vpc_cidr_block)) && can(cidrnetmask(var.vpc_config.vpc_cidr_block))
    error_message = "The VPC CIDR block must be a valid CIDR block, such as 10.0.0.0/16."
  }
}


variable "ingress_rules" {
  description = "Map of ingress rules for the  security group"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))

}


variable "egress_rules" {
  description = "Map of egress rules for the security group"
  type        = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))

}
variable "load_balancer_config" {
  description = "Configuration for the Load Balancer, target group, and health check"
  type = list(object({
    load_balancer_name = string
    target_groups = list(object({
      target_group_name     = string
      target_group_port     = number
      target_group_protocol = string
      enable_https          = bool
      certificate_arn       = string
      health_check = list(object({
        protocol            = string
        port                = string
        enabled             = bool
        path                = string
        healthy_threshold   = number
        unhealthy_threshold = number
        timeout             = number
        interval            = number
      }))
    }))
  }))
}

variable "ecr_repo_name" {
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


variable "ecs_config" {
  description = "Configuration for ECS cluster, task definitions, services, and load balancer"
  type = object({
    fargate = object({
      cluster_name = string
      task_definitions = list(object({
        family                   = string
        container_definitions    = list(object({
          name          = string
          image         = string
          memory        = number
          cpu           = number
          essential     = bool
          port_mappings = list(object({
            container_port = number
            host_port      = number
          }))
          log_configuration = object({
            log_driver = string
            options    = map(string)
          })
        }))
        network_mode             = string
        requires_compatibilities = list(string)
        cpu                      = string
        memory                   = string
      }))
      services = list(object({
        service_name = string
        desired_count = number
        launch_type = string
        # load_balancer = object({
        #   target_group_name = string
        #   container_name    = string
        #   container_port    = number
        # })
      }))
    })
    ec2 = object({
      cluster_name = string
      task_definitions = list(object({
        family                   = string
        container_definitions    = list(object({
          name          = string
          image         = string
          memory        = number
          cpu           = number
          essential     = bool
          port_mappings = list(object({
            container_port = number
            host_port      = number
          }))
          log_configuration = object({
            log_driver = string
            options    = map(string)
          })
        }))
        network_mode             = string
        requires_compatibilities = list(string)
        cpu                      = string
        memory                   = string
      }))
      services = list(object({
        service_name = string
        desired_count = number
        launch_type = string
        load_balancer = object({
          target_group_name = string
          container_name    = string
          container_port    = number
        })
      }))
    })
  })
}

variable "iam_roles_config" {
  description = "Configuration for IAM roles and their policies"
  type = list(object({
    role_name             = string
    assume_role_policy    = string
    policy_name           = string
    policy_description    = string
    policy_statements     = list(object({
      effect   = string
      actions  = list(string)
      resources = list(string)
    }))
  }))
}

variable "ec2_instance" {
    type = object({
      name = string
      image_id = string
      instance_type = string
      key_name = string
    })
}

variable "autoscaling_group" {
    type =object({
      min_size = number
      max_size = number
      desired_capacity = number
    })
}

variable "security_group_name" {
  type = string
}