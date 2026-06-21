# Secure Banking Microservices Architecture

## Project Overview
This project demonstrates a secure, banking-style backend system built on **AWS** using a **Microservices Architecture**. It features strict network isolation using **VPC Peering**, public/private subnet separation, and secure communication protocols. The system allows users to perform transactions (Balance Check, Deposit, Withdraw) via a frontend, while processing sensitive logic and backups in isolated private networks.

## Architecture

```mermaid
graph TD
    User((User)) -->|HTTP Request| Website[S3 Static Website]
    Website -->|API Call :5000| TransService[Transaction Service<br/>(Public Subnet - VPC 1)]
    
    subgraph "VPC 1: Main Banking Network"
        TransService -->|Internal API :5002| AcctService[Account Service<br/>(Private Subnet)]
    end
    
    subgraph "VPC 2: Disaster Recovery Network"
        BackupService[Backup Service<br/>(Private Subnet)]
    end
    
    AcctService -->|VPC Peering Loop :5003| BackupService
    
    style TransService fill:#f9f,stroke:#333,stroke-width:2px
    style AcctService fill:#bbf,stroke:#333,stroke-width:2px
    style BackupService fill:#bfb,stroke:#333,stroke-width:2px
```

## Key Features
- **Network Isolation**: Uses two separate VPCs (Main & Backup) connected via **VPC Peering**.
- **Public/Private Separation**: 
  - **Transaction Service**: Publicly accessible (Validation Layer).
  - **Account Service**: Completely isolated in a private subnet (Core Logic).
  - **Backup Service**: Isolated in a separate DR VPC (Data Retention).
- **Security-First Design**: Communication between services happens only over private IP addresses.
- **Data Persistence**: Uses a file-based storage simulation (JSON) without external databases to keep the architecture portable and self-contained.

## Microservices Breakdown
1. **Transaction Service** (Python Flask): Interface for the frontend. Handles request validation and routing.
2. **Account Service** (Python Flask): The "Brain". Manages account balances and transaction logic.
3. **Backup Service** (Python Flask): The "Vault". Receives and stores immutable transaction logs from the Account Service.

## Deployment Instructions
Detailed step-by-step AWS deployment instructions can be found in the [AWS Setup Guide](AWS_SETUP_GUIDE.md).

## Local Development
To run this project locally for testing:
1. **Install dependencies**:
   ```bash
   pip install flask flask-cors requests
   ```
2. **Run the services** in separate terminals:
   - Terminal 1: `python services/transaction_service/app.py` (Port 5000)
   - Terminal 2: `python services/account_service/app.py` (Port 5002)
   - Terminal 3: `python services/backup_service/app.py` (Port 5003)
3. **Test the flow**:
   ```bash
   python test_local_flow.py
   ```
