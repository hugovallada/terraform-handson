locals {
  public-subnets  = ["10.0.0.0/24", "10.0.10.0/24"]
  private-subnets = ["10.0.1.0/24", "10.0.11.0/24"]
}

resource "aws_vpc" "vpc-chat" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc-name
  }
}

data "aws_availability_zones" "avz" {}

resource "aws_subnet" "vpc-chat-public-subnet" {
  vpc_id            = aws_vpc.vpc-chat.id
  count             = length(local.public-subnets)
  cidr_block        = local.public-subnets[count.index]
  availability_zone = data.aws_availability_zones.avz.names[count.index]
  tags = {
    Name = "spring-chat-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "vpc-chat-private-subnet" {
  vpc_id            = aws_vpc.vpc-chat.id
  count             = length(local.public-subnets)
  cidr_block        = local.private-subnets[count.index]
  availability_zone = data.aws_availability_zones.avz.names[count.index]
}

resource "aws_internet_gateway" "chat-gw" {
  vpc_id = aws_vpc.vpc-chat.id
}

resource "aws_eip" "chat-eip" {
  count = length(local.private-subnets)
  vpc   = true
}

resource "aws_nat_gateway" "chat-nat-gw" {
  count         = length(local.private-subnets)
  subnet_id     = aws_subnet.vpc-chat-private-subnet[count.index].id
  allocation_id = aws_eip.chat-eip[count.index].id
}

resource "aws_route_table" "chat-route-table-public-subnet" {
  vpc_id = aws_vpc.vpc-chat.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.chat-gw.id
  }
  tags = {
    Name = "chat-route-table"
  }
}

resource "aws_route_table" "chat-route-table-private-subnet" {
  vpc_id = aws_vpc.vpc-chat.id
  count  = length(local.private-subnets)
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.chat-nat-gw[count.index].id
  }
}

resource "aws_route_table_association" "chat-route-table-to-public-subnet" {
  count          = length(local.public-subnets)
  route_table_id = aws_route_table.chat-route-table-public-subnet.id
  subnet_id      = aws_subnet.vpc-chat-public-subnet[count.index].id
}

resource "aws_route_table_association" "chat-route-table-to-private-subnet" {
  count          = length(local.public-subnets)
  route_table_id = aws_route_table.chat-route-table-private-subnet[count.index].id
  subnet_id      = aws_subnet.vpc-chat-private-subnet[count.index].id
}

