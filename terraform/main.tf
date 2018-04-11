provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "personal"
}

terraform {
  backend "s3" {
    bucket                  = "terraform-101-tf-storage"
    key                     = "packerize/terraform.tfstate"
    region                  = "us-east-2"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "personal"
    encrypt                 = true
  }
}

module "vpc" {
  source = "modules/vpc"
}
