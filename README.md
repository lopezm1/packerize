# Packerize

_Packer version: 1.2.2, Terraform v0.11.5_

Create a VPC and CodeBuild project with the bare minimum needed in order to create a new AMI with packer.

Only uses the VPC for the lifecycle of packing. Useful for environments that have their default VPC deleted.

### **Requirements**

-  Free tier AWS account or access to create a VPC

### **Terraform**

Creates the VPC and CodeBuild Project.

Current defaults are set in the Terraform Project:
- S3 bucket name is set to `terraform-101-tf-storage`
- region is set to `us-east-2`
- profile name is set to `personal`
- credentials location is `~/.aws/credentials`

Modify the default account information in terraform/packer-vpc/main.tf and terraform/packer-codebuild/main.tf . `provider` and `backend` must be modified.

cd into the terraform directory in order to create the VPC and CodeBuild project

```sh
cd ./terraform/
/opt/bin/terraform get
/opt/bin/terraform init
/opt/bin/terraform plan
/opt/bin/terraform apply
```

Log into the AWS Console and execute a build.


_This documentation to be improved._