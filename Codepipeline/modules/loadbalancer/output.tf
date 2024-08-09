output "target_group_arn" {
    value = { for tg in aws_lb_target_group.targetgroup : tg.name => tg.arn }
}

