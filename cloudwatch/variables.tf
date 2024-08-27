variable "lambda_trigger_config" {
  description = "Configuration for Lambda trigger including function name, ARN, and schedule"
  type = object({
    lambda_function_name  = string
    lambda_function_arn   = string
    schedule_expression   = string
  })
}

