module "cloudwatch_event_triggered" {
    source = "./modules/cloudwatch"
    lambda_trigger_config = var.lambda_trigger_config
}