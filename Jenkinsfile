pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout From GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/sohail-24/aws-devops-automation.git'
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

        stage('Terraform Apply') {
            steps {
                sh """
                cd terraform
                terraform apply -auto-approve
                """
            }
        }

        stage('Extract EC2 Public IP') {
            steps {
                script {
                    env.EC2_IP = sh(
                        script: "cd terraform && terraform output -raw ec2_public_ip",
                        returnStdout: true
                    ).trim()

                    echo "EC2 Public IP = ${EC2_IP}"
                }
            }
        }

        stage('Wait For SSH') {
            steps {
                script {
                    sh """
                    echo "Waiting for SSH to be ready on ${EC2_IP}..."
                    for i in {1..30}; do
                      nc -zv ${EC2_IP} 22 && echo "✅ SSH is Ready" && exit 0
                      echo "SSH not ready yet... retrying in 10s"
                      sleep 10
                    done
                    echo "❌ SSH did not become ready"
                    exit 1
                    """
                }
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                sh """
                echo "[servers]" > ansible/inventory.ini
                echo "my-ec2 ansible_host=${EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=\$WORKSPACE/terraform/generated_key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ansible/inventory.ini
                """
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                sh """
                cd ansible
                ansible-playbook setup.yml -i inventory.ini
                """
            }
        }
    }

    post {
        success {
            echo "✅ PIPELINE COMPLETED SUCCESSFULLY"
        }
        failure {
            echo "❌ PIPELINE FAILED - CHECK LOGS"
        }
    }
}
