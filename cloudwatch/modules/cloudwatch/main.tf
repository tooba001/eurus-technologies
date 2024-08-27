resource "aws_cloudwatch_event_rule" "lambda_trigger_rule" {
  name                = "lambda_trigger_rule"
  description         = "Trigger Lambda function based on schedule"
  schedule_expression = var.lambda_trigger_config.schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.lambda_trigger_rule.name
  arn  = var.lambda_trigger_config.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_trigger_config.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_trigger_rule.arn
}



