# 1 create custom vpc with CIDR "10.0.0.0/16"

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block_value["my_vpc_cidr"]
  tags = {
    Name = "${var.vpc_name}"
  }
}

# 2 INTERNET GATEWAYS
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_internet_gateway"
  }
}

#creating elastic IP
resource "aws_eip" "elasticIP" {
  domain = "vpc"
  tags = {
    Name = "elasticIP"
  }
}

#Creating NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.elasticIP.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "nat-gateway"
  }
}

# 3 public-subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.cidr_block_value["public-subnet"]
  availability_zone       = var.availability_zone_value
  map_public_ip_on_launch = true # tfsec:ignore:aws-ec2-no-public-ip-subnet
  tags = {
    Name = "public-subnet-1"
  }
}

# 4 private-subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.cidr_block_value["private-subnet"]
  availability_zone       = var.availability_zone_value
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-1"
  }
}



# 5 terraform aws create route table and add public route,connecting to igw 
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.cidr_block_value["public-route"]
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }
  tags = {
    Name = "public-route-table"
  }
}

# 6 Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {

  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

# 9 security group 

#tfsec:ignore:aws-ec2-no-public-ingress-sgr 
resource "aws_security_group" "my-security-group" {
  name   = "my-Security-Group"
  description = "Security group for inbound and outbound traffic"
  vpc_id = aws_vpc.my_vpc.id
  dynamic "ingress" {
    for_each    = var.ingress_ports
    content{
    description = "Allow inbound traffic for ssh and http "
    from_port   = ingress.value.from_port
    to_port     = ingress.value.to_port
    protocol    = ingress.value.protocol
    cidr_blocks = ingress.value.cidr_blocks
  
    }

  }
  
  dynamic "egress" {
    for_each = var.egress_port
    content {
    description = "Allow outbound for all traffic "
    from_port   = egress.value.from_port
    to_port     = egress.value.to_port
    protocol    = egress.value.protocol
    cidr_blocks = egress.value.cidr_blocks #tfsec:ignore:aws-ec2-no-public-egress-sgr
    }
  
  }
  tags = {
    Name = "my-SecurityGroup"
  }
}

# 7 create nat route table and add private route 
resource "aws_route_table" "nat-route-table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.cidr_block_value["nat-route"]
    gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = "nat-route-table"
  }
}

# 8 associate private subnet to route table to enable internet access
resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.nat-route-table.id
}
 
