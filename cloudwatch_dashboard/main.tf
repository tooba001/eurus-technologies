module "SNS" {
    source = "./modules/SNS"
    sns = var.sns
}

module "cloudwatch_dashboards" {
    source = "./modules/cloudwatch"
    dashboard = var.dashboard
    cloudwatch_alarms = var.cloudwatch_alarms
    sns_topic_arn = module.SNS.sns-arn
}
