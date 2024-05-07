

/*resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "wp-state-bucket"
  acl    = "private"
}*/

/*resource "aws_dynamodb_table" "terraform_lock_table" {
  name           = "terraform-lock-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}*/

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "tests-vpc"
  }
}
#create private subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "private-subnet-1"
  }
}
#create private subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "private-subnet-2"
  }
}
#create public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-subnet-1"
  }
}

#create public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1d"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-subnet-2"
  }
}
# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}
# Create Public Route Table 1
resource "aws_route_table" "public_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table_1"
  }
}

# Create Public Route Table 1
resource "aws_route_table" "public_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table_2"
  }
}


# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
 domain = "vpc"
  //vpc = "true"
}
# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_1.id
}
# Create Private Route Table 1
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table-1"
  }
}

# Create Private Route Table 2
resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table-2"
  }
}

# Associate Public Subnet with Public Route Table 1
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_1.id
}

# Associate Public Subnet with Public Route Table 2
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_2.id
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_2.id
}


resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow inbound traffic on ports 80 and 443"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

}

/*resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.main.id

  
  ingress  {
    from_port   = 22  // SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // Allow inbound SSH traffic from any source (example, you can limit this to specific IP ranges)
  }
  
   ingress {
    from_port   = 80  // HTTP port
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]   // Allow inbound HTTP traffic from any source (example, you can limit this to specific IP ranges)
  }
  
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  // Allow all outbound traffic to any destination
  }
}*/

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web servers"

  vpc_id = aws_vpc.main.id  # Assuming you have a VPC named "main"

  # Define ingress rules to allow incoming traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # Allowing access from anywhere. Adjust as needed.
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allowing access from anywhere. Adjust as needed.
  }

  # Define egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}


resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow inbound traffic from EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]
    }
    
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]

  }
}


resource "aws_db_subnet_group" "wordpresssubnetgroup" {
  name       = "wpsubnetgroup"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  
  tags = {
    Name = "tests-subnet-group"
  }
}

resource "aws_db_instance" "wordpressdb" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  identifier           = "wordpressdb"
  username             = "admin"
  password             = "tooba2001"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.wordpresssubnetgroup.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

#output "rds_endpoint" {
  #value = aws_db_instance.wordpressdb.endpoint
#}

resource "aws_instance" "database_access_instance" {
  ami           = "ami-07caf09b362be10b8"  # Choose appropriate AMI
  instance_type = "t2.micro"      # Choose appropriate instance type
  subnet_id     = aws_subnet.public_subnet_1.id  # Public subnet ID
  key_name      = "tuba-kpr"  # Key pair name for SSH access
  associate_public_ip_address = true
  
  # Security Group
  security_groups = [aws_security_group.web_sg.id]
  
  
   
  # User data (optional)
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
              wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
              sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
              sudo yum install mysql-community-server -y
              sudo systemctl start mysqld
              echo "${aws_db_instance.wordpressdb.endpoint}">>test.txt 
              cat test.txt
              sudo mysql -h "$(awk -F: '{print $1}' <<< "${aws_db_instance.wordpressdb.endpoint}")" -P 3306 -u admin -ptooba2001
              sudo mysql -h "$(awk -F: '{print $1}' <<< "${aws_db_instance.wordpressdb.endpoint}")" -P 3306 -u admin -ptooba2001 -e "CREATE DATABASE wordpress;"
              sudo mysql -h "$(awk -F: '{print $1}' <<< "${aws_db_instance.wordpressdb.endpoint}")" -P 3306 -u admin -ptooba2001 -e "CREATE USER 'wpuser'@'%' IDENTIFIED BY 'green200#Tooba';"
              sudo mysql -h "$(awk -F: '{print $1}' <<< "${aws_db_instance.wordpressdb.endpoint}")" -P 3306 -u admin -ptooba2001 -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"
              sudo mysql -h "$(awk -F: '{print $1}' <<< "${aws_db_instance.wordpressdb.endpoint}")" -P 3306 -u admin -ptooba2001 -e "FLUSH PRIVILEGES;" 
              EOF    
  )

  tags = {
    Name = "DatabaseAccessInstance"
  }
}



resource "aws_lb_target_group" "wptargetgroup" {
  name     = "wordpresss-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  
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
  name               = "wploadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
 ]
  
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




resource "aws_launch_template" "wordpresslaunchtemplate" {
  name_prefix   = "wordpress-"
  image_id      = "ami-07caf09b362be10b8"  # Replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "tuba-kpr"
 

  # Specify the VPC configuration
  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.public_subnet_1.id  # Choose your subnet ID
    security_groups = [aws_security_group.web_sg.id]
  }
  
  
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              sudo yum install -y httpd php php-common php-gd php-mysqli
              sudo systemctl restart httpd
              sudo wget https://wordpress.org/latest.zip
              sudo unzip latest.zip
              sudo cp -r wordpress/* /var/www/html
              sudo chown apache:apache -R /var/www/html
              sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
              sudo sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
              sudo sed -i "s/username_here/wpuser/" /var/www/html/wp-config.php
              sudo sed -i "s/password_here/green200#Tooba/" /var/www/html/wp-config.php
              sed -i "s/localhost/$(awk -F: '{print $1}' <<< "${aws_db_instance.wordpressdb.endpoint}")/" /var/www/html/wp-config.php
              sudo systemctl restart httpd  
              EOF
              )
              
    tags = {
    Name = "terraform-launch-template"
  }        
}

resource "aws_autoscaling_group" "wordpressautoscaling" {
  launch_template {
    id      = aws_launch_template.wordpresslaunchtemplate.id
    version = "$Latest"
  }

  desired_capacity   = 2       
  min_size           = 1
  max_size           = 4
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] 

  target_group_arns = [aws_lb_target_group.wptargetgroup.arn]
  health_check_type   = "EC2"
       
}
























