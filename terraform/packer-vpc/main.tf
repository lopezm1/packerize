provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "personal"
}

terraform {
  backend "s3" {
    bucket                  = "terraform-101-tf-storage"
    key                     = "packerize/packer-vpc/terraform.tfstate"
    region                  = "us-east-2"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "personal"
    encrypt                 = true
  }
}

module "vpc" {
  source = "modules/vpc"

  vpc_name = "packerize"
  vpc_cidr_block = "10.0.0.0/16"
  public_subnet_1_cidr_block = "10.0.1.0/24"
}
