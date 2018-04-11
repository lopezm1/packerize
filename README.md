# Packerize

_Packer version: 1.2.2, Terraform v0.11.5_

Create the bare mininum VPC needed in order to create a new AMI with packer. Destroy the VPC after the AMI was created.

Useful for environments that had their default VPC deleted and only need a small VPC for the lifecycle of packing. 

### **Requirements**

`brew install terraform`
`brew install packer`
Free tier AWS account or access to create a VPC

### **Terraform**
*Manual steps, skip to Jenkinsfile for full automation*

Create the VPC.

Current defaults: 
- S3 bucket name is set to `terraform-101-tf-storage`
- region is set to `us-east-2`
- profile name is set to `personal`
- credentials location is `~/.aws/credentials`

Modify the default account information in the ./main.tf file. `provider` and `backend` must be modified. 

cd into the terraform directory
```sh
cd ./terraform/
terraform get
terraform init
terraform plan
terraform apply
```

### **Packer**

Package your AMI
*Manual steps, skip to Jenkinsfile for full automation*

cd into the terraform directory
```sh
cd ./terraform/
export SG_WEB_DMZ="$(terraform output sg_web_dmz)"
export VPC_ID="$(terraform output vpc-id)"
export VPC_PUBLIC_SUBNET_1="$(terraform output vpc-public-subnet-1)"

```
Head back to root directory. 
`packer build packer-cis.json`
```

### **Jenkinsfile**

Will automate everything above for you. 

Create a pipeline in your existing Jenkins box.

Make sure you have:
- terraform installed
- packer installed
