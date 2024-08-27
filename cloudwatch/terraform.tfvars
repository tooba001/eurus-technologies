lambda_trigger_config = {
  lambda_function_name = "rman-event-triggered"
  lambda_function_arn = "arn:aws:lambda:us-west-1:489994096722:function:rman-event-triggered"
  schedule_expression = "cron(0 9 * * ? *)"
}