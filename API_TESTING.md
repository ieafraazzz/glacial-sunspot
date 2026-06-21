# API Testing Steps (Curl & Postman)

You can use these commands to test your deployed services. Replace `<PUBLIC_IP>` with the public IP of your **Transaction Service** EC2 instance.

## 1. Health Check
Verify the service is running.
```bash
curl -X GET http://<PUBLIC_IP>:5000/health
```
**Expected Response:**
```json
{"service": "transaction-service", "status": "healthy"}
```

## 2. Check Balance (Initial)
Check the balance for a new user.
```bash
curl -X GET "http://<PUBLIC_IP>:5000/balance?userId=testuser1"
```
**Expected Response:**
```json
{"balance": 0.0, "userId": "testuser1"}
```

## 3. Deposit Money
Deposit funds into the account.
```bash
curl -X POST http://<PUBLIC_IP>:5000/deposit \
  -H "Content-Type: application/json" \
  -d '{"userId": "testuser1", "amount": 500}'
```
**Expected Response:**
```json
{"message": "Deposit successful", "newBalance": 500.0}
```

## 4. Withdraw Money
Withdraw funds from the account.
```bash
curl -X POST http://<PUBLIC_IP>:5000/withdraw \
  -H "Content-Type: application/json" \
  -d '{"userId": "testuser1", "amount": 200}'
```
**Expected Response:**
```json
{"message": "Withdrawal successful", "newBalance": 300.0}
```

## 5. Verify Backup (Internal)
*Note: This cannot be tested from outside. Access your Backup Service EC2 via SSH and check the logs.*
```bash
ssh -i key.pem ec2-user@<BACKUP_IP>
cat transaction_logs.txt
```
**Expected Output:** JSON lines showing the Deposit and Withdraw transactions.
