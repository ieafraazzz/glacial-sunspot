# Resume Description

## **Project: Secure Multi-VPC Banking Microservices Architecture**

**Role:** Cloud Architect & DevOps Engineer
**Tech Stack:** AWS (VPC, EC2, S3, IAM), Python (Flask), VPC Peering, Networking, Security Groups

**Description:**
Designed and implemented a secure, fault-tolerant banking backend infrastructure simulating real-world financial systems capabilities. The project focused on strict network isolation and security compliance using AWS cloud-native features.

**Key Achievements:**
- **Architected a Multi-VPC Solution:** Created a segmented network architecture with a split between Public (Frontend/API) and Private (Core Logic/Backup) subnets to minimize attack surface.
- **Implemented VPC Peering:** Established secure, low-latency cross-VPC communication between the Primary Banking VPC and the Disaster Recovery (Backup) VPC without exposing traffic to the public internet.
- **Developed RESTful Microservices:** Built three decoupled Python Flask microservices (Transaction, Account, Backup) handling distinct business domains, ensuring validation and processing separation.
- **Enhanced Security Posture:** Configured granular Security Groups and Route Tables to enforce a "Least Privilege" network access creation model, restricting internal service communication to specific private IP ranges.
- **Cost-Optimized Deployment:** Leveraged AWS Free Tier resources (t2.micro, S3 Static Hosting) to deliver a production-grade architecture prototype with zero infrastructure cost.

**Key Skills Demonstrated:**
- AWS Networking (CIDR planning, Route Tables, Internet Gateways)
- Microservices Pattern Implementation
- Flask API Development & Integration
- Infrastructure Security (Network ACLs, Security Groups)
- Cross-VPC Communication Management
