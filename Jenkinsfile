pipeline {
    agent any

    environment {
        TF_PATH = "terraform"
        ANSIBLE_PATH = "ansible"
        PRIVATE_KEY = "terrakey.pem"
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
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
                    echo "my-ec2 ansible_host=\${EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=../terraform/\${PRIVATE_KEY}" >> inventory.ini
                """
            }
        }

        stage('Wait for EC2 SSH Ready') {
            steps {
                sh """
                    echo "Waiting for SSH on EC2 instance..."
                    
                    cd ${TF_PATH}
                    EC2_IP=\$(terraform output -raw ec2_public_ip)

                    for i in {1..10}; do
                        echo "Try #\$i: Checking SSH..."
                        ssh -o StrictHostKeyChecking=no -i \${PRIVATE_KEY} ubuntu@\$EC2_IP 'echo SSH OK' && break
                        echo "Retrying in 10 seconds..."
                        sleep 10
                    done
                """
            }
        }

        stage('Configure with Ansible') {
            steps {
                sh """
                    cd ${ANSIBLE_PATH}
                    chmod 600 ../terraform/\${PRIVATE_KEY}
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

