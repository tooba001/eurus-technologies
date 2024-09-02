resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = var.dashboard.name

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width = 24,
        height = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.dashboard.InstanceId],
            ["AWS/EC2", "MemoryUtilization", "InstanceId", var.dashboard.InstanceId]
          ],
          period = 300,
          stat   = "Average",
          region = "us-west-2", # Update with your region
          title  = "EC2 Instance CPU and Memory Utilization"
        }
      }
    ]
  })
}

# set alarms

resource "aws_cloudwatch_metric_alarm" "alarms" {
  for_each = var.cloudwatch_alarms

  alarm_name          = each.value.name
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.alarm_description
  alarm_actions       = [var.sns_topic_arn]
  dimensions          = each.value.dimensions
}

