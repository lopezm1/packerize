data "aws_availability_zones" "all" {}

#--------------------------------------------------------------
# VPC
#--------------------------------------------------------------

resource "aws_vpc" "basic_vpc" {
  cidr_block                       = "${var.vpc_cidr_block}"
  assign_generated_ipv6_cidr_block = true
  instance_tenancy                 = "default"

  tags {
    Name = "${var.vpc_name}-vpc"
  }
}

#--------------------------------------------------------------
# Subnets
#--------------------------------------------------------------

resource "aws_subnet" "vpc_public_subnet_1" {
  cidr_block              = "${var.public_subnet_1_cidr_block}"
  availability_zone       = "${data.aws_availability_zones.all.names[0]}"
  vpc_id                  = "${aws_vpc.basic_vpc.id}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.public_subnet_1_cidr_block} - ${data.aws_availability_zones.all.names[0]}"
  }
}

resource "aws_subnet" "vpc_private_subnet_1" {
  cidr_block = "${var.private_subnet_1_cidr_block}"
  availability_zone = "${data.aws_availability_zones.all.names[1]}"
  vpc_id = "${aws_vpc.basic_vpc.id}"

  tags {
    Name = "${var.private_subnet_1_cidr_block} - ${data.aws_availability_zones.all.names[1]}"
  }
}


#--------------------------------------------------------------
# Gateways
#--------------------------------------------------------------

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = "${aws_vpc.basic_vpc.id}"

  tags {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_nat_gateway" "vpc_nat_gateway" {
  allocation_id = "${aws_eip.nat_gateway_eip.id}"
  subnet_id = "${aws_subnet.vpc_public_subnet_1.id}"
}

#--------------------------------------------------------------
# Route Tables
#--------------------------------------------------------------

resource "aws_route_table" "vpc_public_route_table" {
  vpc_id = "${aws_vpc.basic_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc_igw.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.vpc_igw.id}"
  }

  tags {
    Name = "${var.vpc_name}-public-table"
  }
}

resource "aws_route_table" "vpc_private_route_table" {
  vpc_id = "${aws_vpc.basic_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.vpc_nat_gateway.id}"
  }

  tags {
    Name = "${var.vpc_name}-private-table"
  }
}

#--------------------------------------------------------------
# Subnet Associations
#--------------------------------------------------------------

resource "aws_route_table_association" "public_subnet_1_assoc" {
  route_table_id = "${aws_route_table.vpc_public_route_table.id}"
  subnet_id      = "${aws_subnet.vpc_public_subnet_1.id}"
}

resource "aws_route_table_association" "private_subnet_1_assoc" {
  route_table_id = "${aws_route_table.vpc_private_route_table.id}"
  subnet_id = "${aws_subnet.vpc_private_subnet_1.id}"
}

#--------------------------------------------------------------
# Security Groups
#--------------------------------------------------------------

resource "aws_security_group" "sg_web_dmz" {
  name   = "sg_web_dmz"
  vpc_id = "${aws_vpc.basic_vpc.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sg_web_dmz"
  }
}

resource "aws_security_group" "sg_internal_network" {
  name = "sg_internal_network"
  vpc_id = "${aws_vpc.basic_vpc.id}"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_1_cidr_block}"]
  }

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_1_cidr_block}"]
  }

  ingress {
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_1_cidr_block}"]
  }

  # Allows you to ping your server
  ingress {
    from_port = "8"
    to_port = "0"
    protocol    = "icmp"
    cidr_blocks = ["${var.public_subnet_1_cidr_block}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sg_internal_network"
  }
}

#--------------------------------------------------------------
# EIPs
#--------------------------------------------------------------

resource "aws_eip" "nat_gateway_eip" {
}
