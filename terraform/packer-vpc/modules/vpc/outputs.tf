output "vpc_public_subnet_1" {
  value = "${aws_subnet.vpc_public_subnet_1.id}"
}

output "sg_web_dmz" {
  value = "${aws_security_group.sg_web_dmz.id}"
}

output "vpc_id" {
  value = "${aws_vpc.basic_vpc.id}"
}
