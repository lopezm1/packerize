provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "personal"
}

terraform {
  backend "s3" {
    bucket                  = "terraform-101-tf-storage"
    key                     = "packerize/packer-codebuild/terraform.tfstate"
    region                  = "us-east-2"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "personal"
    encrypt                 = true
  }
}


data "terraform_remote_state" "packer_vpc" {
  backend = "s3"
  config {
    bucket                  = "terraform-101-tf-storage"
    key                     = "packerize/packer-vpc/terraform.tfstate"
    region                  = "us-east-2"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "personal"
    encrypt                 = true
  }
}

#--------------------------------------------------------------
# Packerize CodeBuild Project
#--------------------------------------------------------------

resource "aws_codebuild_project" "packerize_codebuild" {
  name         = "Packerize_build"
  description  = "Automate AMI patching with Packer and Terraform"
  build_timeout      = "5"
  service_role = "${aws_iam_role.packerize_service_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/nodejs:6.3.1"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "VPC_ID"
      "value" = "${data.terraform_remote_state.packer_vpc.vpc_id}"
    }

    environment_variable {
      "name"  = "SG_WEB_DMZ"
      "value" = "${data.terraform_remote_state.packer_vpc.sg_web_dmz}"
    }

    environment_variable {
      "name"  = "VPC_PUBLIC_SUBNET_1"
      "value" = "${data.terraform_remote_state.packer_vpc.vpc_public_subnet_1}"
    }
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/lopezm1/packerize"
  }

  tags {
    "Name" = "Packerize_build"
  }
}