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
                    ${TERRAFORM} init
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                    sh """
                        cd ${TF_PATH}
                        ${TERRAFORM} apply -auto-approve
                    """
            }
        }

        stage('Update Ansible Inventory') {
            steps {
                sh """
                    cd ${TF_PATH}
                    EC2_IP=\$(${TERRAFORM} output -raw ec2_public_ip)

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

