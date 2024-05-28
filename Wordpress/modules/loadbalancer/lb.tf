
resource "aws_lb_target_group" "wptargetgroup" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
    health_check {
    protocol               = "HTTP"
    port                   = "80"
    enabled                = true
    path                   = "/"
    healthy_threshold      = 6
    unhealthy_threshold    = 2
    timeout                = 15
    interval               = 20
  }
}


resource "aws_lb" "wploadbalancer" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    =  var.security_groups
  subnets            =  var.subnets
  
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.wploadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wptargetgroup.arn
  }
}

