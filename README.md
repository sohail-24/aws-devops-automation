# 🚀 AWS DevOps Automation – CI/CD using Jenkins, Terraform & Ansible

This project demonstrates **end-to-end Infrastructure Automation** using a real-world DevOps pipeline.
It provisions AWS infrastructure with Terraform, configures servers with Ansible, and orchestrates everything using Jenkins.

✅ Fully automated
✅ Secure SSH handling
✅ Production-style CI/CD flow
✅ No hardcoded secrets
✅ Real DevOps architecture

---

## 📌 Project Architecture

GitHub (Source Code)
↓
Jenkins Pipeline
↓
Terraform → Provision AWS EC2 + Networking
↓
Auto-generate SSH Key (Runtime)
↓
Ansible → Configure EC2 Server

---

## 🧩 Tech Stack

* AWS EC2 – Infrastructure
* Terraform – Infrastructure as Code
* Ansible – Configuration Management
* Jenkins – CI/CD Orchestration
* GitHub – Source Control
* Ubuntu 24.04 LTS – Target Server

---

## 📂 Repository Structure

aws-devops-automation/
│
├── ansible/
│   ├── roles/
│   ├── setup.yml
│   └── inventory.ini (auto-generated in pipeline)
│
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   └── output.tf
│
├── Jenkinsfile
└── README.md

---

## 🔐 Security Design

* SSH private key is generated dynamically using Terraform
* No keys are stored in GitHub
* Jenkins handles runtime SSH securely
* StrictHostKeyChecking disabled only for automation

---

## ⚙️ How the Pipeline Works

1. Jenkins pulls code from GitHub

2. Terraform provisions:

   * VPC
   * Subnet
   * Security Group
   * EC2 Instance

3. Terraform auto-generates SSH key:
   generated_key.pem

4. Jenkins waits for SSH service

5. Ansible runs playbook to configure EC2

6. Pipeline completes successfully ✅

---

## ✅ Jenkins Pipeline Stages

* Checkout From GitHub
* Terraform Init
* Terraform Apply
* Extract EC2 Public IP
* Wait for SSH
* Generate Ansible Inventory
* Run Ansible Playbook

---

## 🛠 How to Run the Project

### Step 1: Clone Repository

git clone [https://github.com/sohail-24/aws-devops-automation.git](https://github.com/sohail-24/aws-devops-automation.git)

### Step 2: Configure Jenkins

* Create a new pipeline job
* Point it to this GitHub repository
* Use Jenkinsfile from repository

### Step 3: Run Pipeline

Click:
Build Now

Jenkins will handle everything automatically ✅

---

## 💣 Destroy Infrastructure (Manual – Best Practice)

As per DevOps best practice, destroy is not included in the pipeline.

Use terminal inside Jenkins workspace:

cd ~/.jenkins/workspace/my-cicd-pipeline/terraform
terraform destroy -auto-approve

---

## 📸 Sample Result

✔ EC2 Instance Running
✔ Ansible Configured
✔ Jenkins Pipeline Success
✔ SSH Secure Automation

---

## 👨‍💻 Author

Mohammed Sohail
DevOps Engineer | AWS | Terraform | Jenkins | Ansible
Hyderabad, India 🇮🇳

---

## 🎯 What This Project Demonstrates

* Infrastructure as Code
* Secure CI/CD Pipeline
* Fully automated server provisioning
* DevOps best practices
* GitOps workflow
* Production-style automation

---

## 🚀 Future Enhancements

* Add monitoring (Prometheus + Grafana)
* Auto Scaling Group
* Blue/Green Deployment
* Slack notification integration
* Approval-based production deployment

---

## ⭐ Support

If you found this project useful, consider starring the repository ⭐
Feel free to fork and contribute!

---

## ✅ Status

This project is fully operational and verified using real AWS EC2 infrastructure through Jenkins CI/CD automation.
