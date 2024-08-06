variable "ecs_cluster_name" {
    type = string
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

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

# variable "target_group_arn" {
#   type = string
# }

# variable "load_balancer" {
#   type = object({
#     container_name = string
#     container_port = number
#   })
# }

