
variable "dashboard" {
  type= object({
    name = string
    InstanceId = string
  })
}

variable "cloudwatch_alarms" {
  description = "Map of CloudWatch alarm configurations"
  type = map(object({
    name                  = string
    metric_name           = string
    namespace             = string
    comparison_operator   = string
    evaluation_periods    = number
    period                = number
    statistic             = string
    threshold             = number
    alarm_description     = string
    dimensions            = map(string)
  }))
}

variable "sns" {
  type = object({
    name = string
    protocol = string
    endpoint = string
  })
}