resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.vpc_cidr_block
   
  tags = {
    Name = "tests-vpc"
  }
}
resource "aws_subnet" "subnets" {
  for_each = var.vpc_config.subnet_cidr_blocks

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = lookup(
    {
      "private_subnet1" = "us-west-1a",
      "private_subnet2" = "us-west-1c",
      "public_subnet1"  = "us-west-1a",
      "public_subnet2"  = "us-west-1c",
    },
    each.key,
    "us-west-1a"
  )

  tags = {
    Name = each.key
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
  subnet_id     = aws_subnet.subnets["public_subnet1"].id
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
  subnet_id      = aws_subnet.subnets["public_subnet1"].id
  route_table_id = aws_route_table.public_1.id
}

# Associate Public Subnet with Public Route Table 2
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.subnets["public_subnet2"].id
  route_table_id = aws_route_table.public_2.id
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.subnets["private_subnet1"].id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.subnets["private_subnet2"].id
  route_table_id = aws_route_table.private_2.id
}