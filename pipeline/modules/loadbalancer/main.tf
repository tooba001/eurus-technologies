resource "aws_lb_target_group" "targetgroup" {
  for_each = { for tg in var.load_balancer_config[0].target_groups : tg.target_group_name => tg }
  name     = each.value.target_group_name
  port     = each.value.target_group_port
  protocol = each.value.target_group_protocol
  vpc_id   = var.vpc_id

  
    health_check {
    protocol               = var.load_balancer_config[0].health_check.protocol
    port                   = var.load_balancer_config[0].health_check.port
    enabled                = var.load_balancer_config[0].health_check.enabled
    path                   = var.load_balancer_config[0].health_check.path
    healthy_threshold      = var.load_balancer_config[0].health_check.healthy_threshold
    unhealthy_threshold    = var.load_balancer_config[0].health_check.unhealthy_threshold
    timeout                = var.load_balancer_config[0].health_check.timeout
    interval               = var.load_balancer_config[0].health_check.interval
  }
}

resource "aws_lb" "loadbalancer" {
  name               = var.load_balancer_config[0].load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    =  var.security_groups
  subnets            =  var.subnets
  
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = var.load_balancer_config[0].target_groups[0].enable_https ? 443 : 80
  protocol          = var.load_balancer_config[0].target_groups[0].enable_https ? "HTTPS" : "HTTP"
  ssl_policy        = var.load_balancer_config[0].target_groups[0].enable_https ? "ELBSecurityPolicy-2016-08" : null
  certificate_arn   = var.load_balancer_config[0].target_groups[0].enable_https ? var.load_balancer_config[0].certificate_arn : null

  dynamic "default_action" {
    for_each = aws_lb_target_group.targetgroup
    content {
      type = "forward"
      forward {
        target_group {
          arn    = default_action.value.arn
          weight = 1
        }
      }
    }
  }
}