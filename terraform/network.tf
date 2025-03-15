resource "aws_vpc" "nnote" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "nnote" {
  vpc_id = aws_vpc.nnote.id

  tags = {
    Name = "nnote_igw"
  }
}

resource "aws_subnet" "s1" {
  vpc_id            = aws_vpc.nnote.id
  cidr_block        = var.s1_cidr
  availability_zone = var.s1_az

  tags = {
    Name = "nnote_vpc_s1"
  }
}

resource "aws_subnet" "s2" {
  vpc_id            = aws_vpc.nnote.id
  cidr_block        = var.s2_cidr
  availability_zone = var.s2_az

  tags = {
    Name = "nnote_vpc_s2"
  }
}

resource "aws_route_table" "nnote" {
  vpc_id = aws_vpc.nnote.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nnote.id
  }

  tags = {
    Name = "nnote_rt"
  }

  depends_on = [aws_internet_gateway.nnote]
}

resource "aws_route_table_association" "assoc1" {
  route_table_id = aws_route_table.nnote.id
  subnet_id      = aws_subnet.s1.id
}

resource "aws_route_table_association" "assoc2" {
  route_table_id = aws_route_table.nnote.id
  subnet_id      = aws_subnet.s2.id
}