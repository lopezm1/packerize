pipeline {
    agent any
    stages {
        stage ('Initialize VPC') {
            steps {
                dir ('terraform') {
                    sh '''
                    /opt/bin/terraform get
                    /opt/bin/terraform init
                    yes | /opt/bin/terraform apply
                    export SG_WEB_DMZ="$(/opt/bin/terraform output sg_web_dmz)"
                    export VPC_ID="$(/opt/bin/terraform output vpc-id)"
                    export VPC_PUBLIC_SUBNET_1="$(/opt/bin/terraform output vpc-public-subnet-1)"
                '''
                }
            }
        }

        stage ('Packerize') {
            steps {
                sh '/opt/bin/packer build packer-cis.json'
            }
        }

        stage ('Test') {
            steps {
                sh 'echo "Add test scripts for AMI and VPC deletion here."'
            }
        }
    }
}
