pipeline {
    agent any
    stages {
        stage ('Initialize VPC') {
            steps {
                dir ('terraform') {
                    sh '''
                    terraform get
                    terraform init
                    yes | terraform apply
                    export SG_WEB_DMZ="$(terraform output sg_web_dmz)"
                    export VPC_ID="$(terraform output vpc-id)"
                    export VPC_PUBLIC_SUBNET_1="$(terraform output vpc-public-subnet-1)"
                '''
                }
            }
        }

        stage ('Packerize') {
            steps {
                sh 'packer build packer-cis.json'
            }
        }

        stage ('Test') {
            steps {
                sh 'echo "Add test scripts for AMI and VPC deletion here."'
            }
        }
    }
}
