pipeline {
    agent any

    environment {
        TF_PATH = "terraform"
        ANSIBLE_PATH = "ansible"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/your-repo/aws-devops-automation.git'
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

