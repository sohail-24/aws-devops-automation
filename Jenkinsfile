pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout From GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/YOUR-USERNAME/YOUR-REPO.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh """
                cd terraform
                terraform init
                """
            }
        }

        stage('Terraform Apply Using Jenkins Credential Key') {
            steps {
                sshagent(['terra-key']) {
                    sh """
                    cd terraform
                    terraform apply -auto-approve
                    """
                }
            }
        }

        stage('Extract EC2 Public IP From Terraform') {
            steps {
                script {
                    env.EC2_IP = sh(
                        script: "cd terraform && terraform output -raw ec2_public_ip",
                        returnStdout: true
                    ).trim()

                    echo "EC2 Public IP = ${env.EC2_IP}"
                }
            }
        }

        stage('Generate Ansible Inventory File') {
            steps {
                sh """
                echo "[servers]" > ansible/inventory.ini
                echo "my-ec2 ansible_host=${EC2_IP} ansible_user=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ansible/inventory.ini
                """
            }
        }

        stage('Run Ansible Playbook With Jenkins SSH Key') {
            steps {
                sshagent(['terra-key']) {
                    sh """
                    cd ansible
                    ansible-playbook setup.yml -i inventory.ini
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline Completed Successfully!"
        }
        failure {
            echo "Pipeline Failed!"
        }
    }
}

