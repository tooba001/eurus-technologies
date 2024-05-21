
/*module "Vpc" {
  source          =  "/home/thinkpad/Desktop/Wordpress/modules/vpc"
  vpc_cidr_block  =  "10.0.0.0/16"
  
}


module "loadbalancer" {
  source              = "/home/thinkpad/Desktop/Wordpress/modules/loadbalancer"
  target_group_name   = "wordpresss-tg"
  load_balancer_name  = "wploadbalancer"
  instance_type       = "t2.micro"
  ami_id              = "ami-02bf8ce06a8ed6092"
  launch_template_name_prefix   = "wordpress-"
  key_pair_name       =  "tuba-kpr-1"
}*/


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