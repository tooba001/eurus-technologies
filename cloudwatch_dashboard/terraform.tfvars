
dashboard = {
    name = "tooba-dashboard"
    InstanceId = "i-01a2cc00e4dd3e212"
}

cloudwatch_alarms = {
  cpu_alarm = {
    name                  = "HighCPUUsage"
    metric_name           = "CPUUtilization"
    namespace             = "AWS/EC2"
    comparison_operator   = "GreaterThanThreshold"
    evaluation_periods    = 2
    period                = 300
    statistic             = "Average"
    threshold             = 50
    alarm_description     = "This metric monitors CPU utilization"
    dimensions = {
      InstanceId = "i-01a2cc00e4dd3e212"  
    }
  }
  memory_alarm = {
    name                  = "HighMemoryUsage"
    metric_name           = "MemoryUtilization"
    namespace             = "AWS/EC2"
    comparison_operator   = "GreaterThanThreshold"
    evaluation_periods    = 2
    period                = 300
    statistic             = "Average"
    threshold             = 50
    alarm_description     = "This metric monitors memory utilization"
    dimensions = {
      InstanceId = "i-01a2cc00e4dd3e212" 
    }
  }
}
sns = {
    name = "tooba-sns"
    protocol = "email"
    endpoint = "toobabalooch20012001@gmail.com"
}