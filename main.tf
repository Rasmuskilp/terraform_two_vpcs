#set a provider
provider "aws" {
  region = "eu-west-1"
}
# create vpc
resource "aws_vpc" "one_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
  Name = var.Name1
  }
}
resource "aws_vpc" "two_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
  Name = var.Name2
  }
}
#create a subnet
resource "aws_subnet" "one_subnet" {
  vpc_id = "${aws_vpc.one_vpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  tags = {
  Name = var.Name1
  }
}
resource "aws_subnet" "two_subnet" {
  vpc_id = "${aws_vpc.two_vpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
  tags = {
  Name = var.Name2
  }
}
#aws security group creation
resource "aws_security_group" "sg_one" {
  name = "eng48-rasmus-vpc-one"
  description = "Allow :80 & :22 inbound traffic"
  vpc_id = "${aws_vpc.one_vpc.id}"
  tags = {
  Name = var.Name1
  }
  ingress {
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "sg_two" {
  name = "eng48-rasmus-vpc-two"
  description = "Allow :80 & :22 inbound traffic"
  vpc_id = "${aws_vpc.two_vpc.id}"
  tags = {
  Name = var.Name2
  }
  ingress {
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}
#Route table
resource "aws_route_table" "one_route" {
vpc_id = aws_vpc.one_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.one_gateway.id
    }
  tags = {
  Name = var.Name1
  }
}
resource "aws_route_table" "two_route" {
vpc_id = aws_vpc.two_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.two_gateway.id
    }
  tags = {
  Name = var.Name2
  }
}
# Route table associations
resource "aws_route_table_association" "one_assoc" {
subnet_id = aws_subnet.one_subnet.id
route_table_id = aws_route_table.one_route.id

}
resource "aws_route_table_association" "two_assoc" {
subnet_id = aws_subnet.two_subnet.id
route_table_id = aws_route_table.two_route.id

}
# security
resource "aws_internet_gateway" "one_gateway" {
vpc_id = aws_vpc.one_vpc.id
tags = {
Name = var.Name1
}
}
resource "aws_internet_gateway" "two_gateway" {
vpc_id = aws_vpc.two_vpc.id
tags = {
Name = var.Name2
}
}
