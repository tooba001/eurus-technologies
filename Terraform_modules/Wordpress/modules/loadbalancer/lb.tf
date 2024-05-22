
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

data "template_file" "webserveruser_data" {
  template = file(var.webserver_user_data_template)

   vars = {
    rds_endpoint = var.rds_endpoint
  }


}

resource "aws_launch_template" "wordpresslaunchtemplate" {
  name_prefix   = var.launch_template_name_prefix
  image_id      = var.ami_id  # Replace with your AMI ID
  instance_type = var.instance_type
  key_name      = var.key_pair_name
 

  # Specify the VPC configuration
  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   =  var.subnet_id # Choose your subnet ID
    security_groups = var.security_group
  }

  user_data =  base64encode(data.template_file.webserveruser_data.rendered)
              
    tags = {
    Name = "terraform-launch-template"
  }        
}
