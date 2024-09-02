resource "aws_sns_topic" "sns" {
  name = var.sns.name
}


resource "aws_sns_topic_subscription" "sns_subscription" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = var.sns.protocol
  endpoint  = var.sns.endpoint
}
