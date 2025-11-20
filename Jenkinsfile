pipeline {
    agent any

    environment {
        TF_PATH = "terraform"
        ANSIBLE_PATH = "ansible"
        TERRAFORM = "/opt/homebrew/bin/terraform"
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
                    ${TERRAFORM} init -input=false
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                    cd ${TF_PATH}
                    ${TERRAFORM} apply -auto-approve -input=false
                """
            }
        }

        stage('Update Ansible Inventory') {
            steps {
                sh """
                    cd ${TF_PATH}
                    EC2_IP=\$(${TERRAFORM} output -raw ec2_public_ip)

                    cd ../${ANSIBLE_PATH}

                    # Create Ansible Inventory
                    echo "[servers]" > inventory.ini
                    echo "my-ec2 ansible_host=\${EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=${WORKSPACE}/terraform/terrakey ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> inventory.ini
                """
            }
        }

        stage('Configure with Ansible') {
            steps {
                sh """
                    cd ${ANSIBLE_PATH}

                    # Fix private key permissions
                    chmod 600 ${WORKSPACE}/terraform/terrakey

                    # Run playbook
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
