# variable "ecs_config" {
#   description = "Configuration for ECS cluster, task definitions, services, and load balancer"
#   type = object({
#     cluster_name = string
#     task_definitions = list(object({
#       family                   = string
#       container_definitions    = list(object({
#         name          = string
#         image         = string
#         memory        = number
#         cpu           = number
#         essential     = bool
#         port_mappings = list(object({
#           container_port = number
#           host_port      = number
#         }))
#         log_configuration = object({
#           log_driver = string
#           options    = map(string)
#         })
#       }))
#       network_mode             = string
#       requires_compatibilities = list(string)
#       cpu                      = string
#       memory                   = string
#     }))
#     services = list(object({
#       service_name = string
#       desired_count = number
#       launch_type = string
#       # load_balancer = object({
#       #   target_group_name = string
#       #   container_name = string
#       #   container_port = number
#       # })
#     }))
#   })
# }


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

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "iam_roles_arns" {
    type = map(string)
}

# variable "target_group_arn" {
#   type = map(string)
# }