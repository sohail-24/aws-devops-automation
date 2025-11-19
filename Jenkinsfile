pipeline {
    agent any

    environment {
        TF_PATH = "terraform"
        ANSIBLE_PATH = "ansible"
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/sohail-24/aws-devops-automation.git'
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
                    echo "my-ec2 ansible_host=\${EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=../terraform/terrakey" >> inventory.ini
                """
            }
        }

        stage('Configure with Ansible') {
            steps {
                sh """
                    cd ${ANSIBLE_PATH}
                    chmod 600 ../terraform/terrakey
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

