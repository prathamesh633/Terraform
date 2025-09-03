# VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.tag}-vpc"
  }
}

#Avalibality Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Subnet 
resource "aws_subnet" "public-subnet" {
  count = length(var.public_subnet_cidr) # will take the length of the list of cidr blocks i.e. 3.
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = element(var.public_subnet_cidr, count.index) # will take the cidr block at the index of the count i.e. 0,1,2.

  tags = {
    Name = "${var.tag}-${element(var.public_subnet_cidr, count.index)}-public"
  }
}
resource "aws_subnet" "private-subnet" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = element(var.private_subnet_cidr, count.index)

  tags = {
    Name = "${var.tag}-${element(var.private_subnet_cidr, count.index)}-private"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.tag}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.tag}-public-rt"
  }
}
# Private Route Table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.tag}-private-rt"
  }
}

#Elastic IP
resource "aws_eip" "eip" {
  domain = "vpc"
}

# NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet[0].id

  tags = {
    Name = "${var.tag}-NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route-table Association
resource "aws_route_table_association" "a" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "b" {
  count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-rt.id
}