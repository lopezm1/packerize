data "aws_availability_zones" "all" {}

resource "aws_vpc" "sample-cloud-vpc" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  instance_tenancy                 = "default"

  tags {
    Name = "sample-cloud-vpc"
  }
}

resource "aws_subnet" "vpc-public-subnet-1" {
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${data.aws_availability_zones.all.names[0]}"
  vpc_id                  = "${aws_vpc.sample-cloud-vpc.id}"
  map_public_ip_on_launch = true

  tags {
    Name = "10.0.1.0 - ${data.aws_availability_zones.all.names[0]}"
  }
}

resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = "${aws_vpc.sample-cloud-vpc.id}"

  tags {
    Name = "sample-cloud-igw"
  }
}

resource "aws_route_table" "vpc-public-route-table" {
  vpc_id = "${aws_vpc.sample-cloud-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc-igw.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.vpc-igw.id}"
  }

  tags {
    Name = "sample-cloud-public-table"
  }
}

resource "aws_route_table_association" "public-subnet-1-assoc" {
  route_table_id = "${aws_route_table.vpc-public-route-table.id}"
  subnet_id      = "${aws_subnet.vpc-public-subnet-1.id}"
}

resource "aws_security_group" "sg_web_dmz" {
  name   = "sg_web_dmz"
  vpc_id = "${aws_vpc.sample-cloud-vpc.id}"

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
