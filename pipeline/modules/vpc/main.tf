resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.vpc_cidr_block
   
  tags = {
    Name = "tests-vpc"
  }
}

#create private subnet 1

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_config.private_subnet1_cidr_block
  availability_zone  = "us-west-1a"
  
  tags = {
    Name = "private_subnet1"
  }
}

#create private subnet 2

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_config.private_subnet2_cidr_block
  availability_zone = "us-west-1c"
  
  tags = {
    Name = "private_subnet2"
  }
}

#create public subnet 1

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_config.public_subnet1_cidr_block
  availability_zone = "us-west-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet1"
  }
}

#create public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_config.public_subnet2_cidr_block
  availability_zone = "us-west-1c"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet2"
  }
}


# Create Internet Gateway

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main.id
}

# Create Public Route Table 1

resource "aws_route_table" "public_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "public-route-table_1"
  }
}

# Create Public Route Table 2

resource "aws_route_table" "public_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
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