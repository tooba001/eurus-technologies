vpc_cidr_block = "10.0.0.0/16"
auto_scaling_group_name = "wordpressautoscaling"
min_size =  1
max_size =  3
desired_capacity = 2
health_check_type =  "EC2"
db_instance_type =  "db.t3.micro"
db_engine =  "mysql"
db_engine_version = "8.0.35"
db_name = "wordpressdb"
db_username = "admin"
parameter_group_name = "default.mysql8.0"
instance_type = "t2.micro"
ami_id = "ami-0bb84b8ffd87024d8"
key_pair_name = "tuba-kpr"
target_group_name = "wordpresss-tg"
load_balancer_name =  "wploadbalancer"
launch_template_name_prefix =  "wordpress-"
lb_ingress_rules = {
  http = {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

