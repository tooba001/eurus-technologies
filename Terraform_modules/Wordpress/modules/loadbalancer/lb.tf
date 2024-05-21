

/*module "Vpc" {
  source          =  "/home/thinkpad/Desktop/Wordpress/modules/vpc"
  vpc_cidr_block  =  "10.0.0.0/16"
}


module "lbsecuritygroups" {
  source      = "/home/thinkpad/Desktop/Wordpress/modules/loadbalancer_sg"
}

module "websecuritygroups" {
  source      = "/home/thinkpad/Desktop/Wordpress/modules/webserver_sg" 
}

module "databases" {
  source              = "/home/thinkpad/Desktop/Wordpress/modules/database"
  db_instance_type             = "db.t2.micro"
  db_engine  =  "mysql"
  db_engine_version =  "5.7"
  db_name = "wordpressdb"
  db_username = "admin"
  db_password = "tooba2001"
  parameter_group_name = "default.mysql5.7"
  instance_type = "t2.micro"
  ami_id = "ami-02bf8ce06a8ed6092"
  key_pair_name = "tuba-kpr-1"
}*/



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