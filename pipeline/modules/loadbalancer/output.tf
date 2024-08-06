output "target_group_arn" {
    value = [for key, targetgroup in aws_lb_target_group.targetgroup : targetgroup.arn]
}

