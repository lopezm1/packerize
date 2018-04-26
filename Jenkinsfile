pipeline {
    agent any
    parameters {
        choice(
                name: 'REGION',
                choices: "us-east-2\nus-west-2",
                description: 'SSM Region' )
    }

    environment {
        SECRET_ACCESS_KEY = '$(aws ssm get-parameters --region $REGION --names /jenkins/nonprod/iam-role-secret --query Parameters[0].Value --with-decryption | sed \'s/"//g\')'
        ACCESS_KEY_ID = '$(aws ssm get-parameters --region $REGION --names /jenkins/nonprod/iam-role-key --query Parameters[0].Value --with-decryption | sed \'s/"//g\')'
    }

    stages {
        stage ('Create VPC & Packerize') {
            steps {
                dir('terraform'){
                    sh """
                    export AWS_SECRET_ACCESS_KEY=${env.SECRET_ACCESS_KEY}
                    export AWS_ACCESS_KEY_ID=${env.ACCESS_KEY_ID}
                    export AWS_DEFAULT_REGION=${REGION}
                    /opt/bin/terraform --version
                    /opt/bin/terraform init
                    /opt/bin/terraform plan --out=plan.out
                    export VPC_ID=$(terraform output vpc_id)
                    export VPC_PUBLIC_SUBNET_1=$(terraform output vpc_public_subnet_1)
                    export SG_WEB_DMZ=$(terraform output sg_web_dmz)
                    /opt/bin/packer build ../packer-cis.json
                    """
                }
            }
        }

        stage ('Delete VPC') {
            steps {
                dir ('terraform') {
                    sh """
                    export AWS_SECRET_ACCESS_KEY=${env.SECRET_ACCESS_KEY}
                    export AWS_ACCESS_KEY_ID=${env.ACCESS_KEY_ID}
                    export AWS_DEFAULT_REGION=${REGION}
                    /opt/bin/terraform destroy --force
                """
                }
            }
        }

        stage ('Test') {
            steps {
                sh 'echo "Add test scripts for AMI and VPC deletion here."'
            }
        }
    }
}
