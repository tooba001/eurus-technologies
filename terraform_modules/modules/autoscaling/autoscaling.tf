


resource "aws_autoscaling_group" "wordpressautoscaling" {
  launch_template {
    id      =  var.loadbalancer_launch_template_id
    version = "$Latest"
  }

  desired_capacity   = var.desired_capacity      
  min_size           = var.min_size
  max_size           = var.max_size
  vpc_zone_identifier  = var.vpc_zone_identifier
  target_group_arns =  var.target_group_arns_id
  health_check_type   = var.health_check_type
       
}
