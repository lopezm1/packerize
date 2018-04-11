output "vpc-public-subnet-1" {
  value = "${module.vpc.vpc-public-subnet-1}"
}

output "sg_web_dmz" {
  value = "${module.vpc.sg_web_dmz}"
}

output "vpc-id" {
  value = "${module.vpc.vpc-id}"
}
