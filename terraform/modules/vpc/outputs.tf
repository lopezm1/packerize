output "vpc-public-subnet-1" {
  value = "${aws_subnet.vpc-public-subnet-1.id}"
}

output "sg_web_dmz" {
  value = "${aws_security_group.sg_web_dmz.id}"
}

output "vpc-id" {
  value = "${aws_vpc.sample-cloud-vpc.id}"
}
