

resource "aws_db_subnet_group" "wordpresssubnetgroup" {
  name       = "wpsubnetgroup"
  subnet_ids = var.subnet_ids
  
  tags = {
    Name = "tests-subnet-group"
  }
}

resource "aws_db_instance" "wordpressdb" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_type
  identifier           = var.db_name
  username             = var.db_username
  password             =  var.db_password
  parameter_group_name = var.parameter_group_name
  db_subnet_group_name = aws_db_subnet_group.wordpresssubnetgroup.name
  vpc_security_group_ids = var.vpc_security_group_ids
}



data "template_file" "dbuser_data" {
  template = file(var.db_user_data_template)

  vars = {
   rds_endpoint = aws_db_instance.wordpressdb.endpoint
  }

}

resource "aws_instance" "database_access_instance" {
  ami           = var.ami_id # Choose appropriate AMI
  instance_type = var.instance_type      # Choose appropriate instance type
  subnet_id     =  var.subnet_id  # Public subnet ID
  key_name      = var.key_pair_name # Key pair name for SSH access
  associate_public_ip_address = true
  
  # Security Group
  security_groups = var.security_groups
  
  
   
  # User data (optional)
  user_data = base64encode(data.template_file.dbuser_data.rendered)

  tags = {
    Name = "DatabaseAccessInstance"
  }
}
