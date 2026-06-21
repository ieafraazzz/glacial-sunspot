# Terraform Deployment Guide

This guide explains how to deploy the **Secure Banking Microservices Architecture** using the provided Terraform scripts.

## Prerequisites
1. **AWS CLI** installed and configured with your credentials.
2. **Terraform** installed (v1.0+).
3. An **EC2 Key Pair** created in your AWS region (e.g., `my-key-pair`).

## Deployment Steps

### 1. Initialize Terraform
Navigate to the `terraform` directory:
```bash
cd terraform
terraform init
```

### 2. Plan the Deployment
Run the plan command to see what resources will be created. You must provide your SSH key name.
```bash
terraform plan -var="key_name=YOUR_KEY_PAIR_NAME"
```

### 3. Apply the Configuration
Deploy the infrastructure.
```bash
terraform apply -var="key_name=YOUR_KEY_PAIR_NAME" -auto-approve
```

### 4. Post-Deployment Setup
After Terraform completes, it will output the IPs of your instances.
1. **SSH into the instances** (Transaction, Account, Backup) using your private key.
   ```bash
   ssh -i /path/to/key.pem ec2-user@<PUBLIC_IP>  # Transaction Service
   # For private instances, you must SSH from the Transaction Service (Bastion)
   ```
2. **Copy the Application Code**:
   Since the instances are created with dependencies installed but without the code, you need to copy the `services/` folder to each instance.
   
   **Option A: SCP (easiest for Public instance)**
   ```bash
   scp -i key.pem -r ../services/transaction_service ec2-user@<TRANSACTION_IP>:~/app
   ```
   
   **Option B: Git Clone (if you push code to GitHub)**
   On each instance:
   ```bash
   git clone <YOUR_REPO_URL>
   cd <YOUR_REPO>/services/<service_name>
   python3 app.py
   ```

### 5. Running the Services
On each instance, run the Python application:
- **Transaction Service**: `python3 app/app.py` (Port 5000)
- **Account Service**: `python3 app/app.py` (Port 5002)
- **Backup Service**: `python3 app/app.py` (Port 5003)

## Cleanup
To destroy all resources:
```bash
terraform destroy -var="key_name=YOUR_KEY_PAIR_NAME" -auto-approve
```
