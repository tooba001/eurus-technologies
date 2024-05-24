
data "template_file" "webserveruser_data" {
  template = file(var.webserver_user_data_template)

   vars = {
    rds_endpoint = var.rds_endpoint
    wp_db_password = var.wp_db_password
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
    security_groups = var.security_groups
  }


  user_data =  base64encode(data.template_file.webserveruser_data.rendered)
              
    tags = {
    Name = "terraform-launch-template"
  }        
}


resource "aws_autoscaling_group" "wordpressautoscaling" {
  launch_template {
    id      =  aws_launch_template.wordpresslaunchtemplate.id
    version = "$Latest"
  }

  desired_capacity   = var.desired_capacity      
  min_size           = var.min_size
  max_size           = var.max_size
  vpc_zone_identifier  = var.vpc_zone_identifier
  target_group_arns =  var.target_group_arns_id
  health_check_type   = var.health_check_type
       
}