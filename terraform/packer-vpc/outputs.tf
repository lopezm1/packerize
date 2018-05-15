output "vpc_public_subnet_1" {
  value = "${module.vpc.vpc_public_subnet_1}"
}

output "vpc_private_subnet_1" {
  value = "${module.vpc.vpc_private_subnet_1}"
}

output "sg_web_dmz" {
  value = "${module.vpc.sg_web_dmz}"
}

output "sg_internal_network" {
  value = "${module.vpc.sg_internal_network}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
