output "vpc_public_subnet_1" {
  value = "${module.vpc.vpc_public_subnet_1}"
}

output "sg_web_dmz" {
  value = "${module.vpc.sg_web_dmz}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
