pipeline {
    agent any

    environment {
        TF_PATH = "terraform"
        ANSIBLE_PATH = "ansible"
        KEY_ID = "terraform-key"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/sohail-24/aws-devops-automation.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh """
                    cd ${TF_PATH}
                    terraform init
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                    cd ${TF_PATH}
                    terraform apply -auto-approve
                """
            }
        }

        stage('Update Ansible Inventory') {
            steps {
                sh """
                    cd ${TF_PATH}
                    EC2_IP=\$(terraform output -raw ec2_public_ip)

                    cd ../${ANSIBLE_PATH}
                    echo "[servers]" > inventory.ini
                    echo "my-ec2 ansible_host=\${EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/tmp/terraform-key.pem" >> inventory.ini
                """
            }
        }

        stage('Copy SSH Key to Workspace') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "${KEY_ID}", keyFileVariable: 'SSH_KEY')]) {
                    sh "cp \$SSH_KEY /tmp/terraform-key.pem"
                    sh "chmod 600 /tmp/terraform-key.pem"
                }
            }
        }

        stage('Wait for EC2 SSH Ready') {
            steps {
                sh '''
                    EC2_IP=$(terraform -chdir=terraform output -raw ec2_public_ip)
                    echo "Waiting for SSH..."

                    for i in {1..12}; do
                        ssh -o StrictHostKeyChecking=no -i /tmp/terraform-key.pem ubuntu@$EC2_IP "echo SSH OK" && break
                        echo "Retrying in 10s..."
                        sleep 10
                    done
                '''
            }
        }

        stage('Configure with Ansible') {
            steps {
                sh """
                    cd ${ANSIBLE_PATH}
                    ansible-playbook -i inventory.ini setup.yml
                """
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

