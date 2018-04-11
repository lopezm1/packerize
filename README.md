# Packerize

_Packer version: 1.2.2, Terraform v0.11.5_

Create a VPC with the bare minimum needed in order to create a new AMI with packer. Destroy the VPC after the AMI has been created.

Useful for environments that have their default VPC deleted. Only uses the VPC for the lifecycle of packing.

### **Requirements**

- `brew install terraform`
- `brew install packer`
-  Free tier AWS account or access to create a VPC

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
/opt/bin/terraform get
/opt/bin/terraform init
/opt/bin/terraform plan
/opt/bin/terraform apply
```

### **Packer**
*Manual steps, skip to Jenkinsfile for full automation*

Package your AMI.

cd into the terraform directory
```sh
cd ./terraform/
export SG_WEB_DMZ="$(terraform output sg_web_dmz)"
export VPC_ID="$(terraform output vpc-id)"
export VPC_PUBLIC_SUBNET_1="$(terraform output vpc-public-subnet-1)"

```
Head back to root directory. 

`/opt/bin/packer build packer-cis.json`

### **Jenkinsfile**

Will automate everything above for you. 

Create a pipeline in your existing Jenkins box.

Make sure you have:
- terraform installed
- packer installed

`curl https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip --output terraform.zip`
`unzip terraform.zip`
