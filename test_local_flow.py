import requests
import time
import sys

# Configuration for local testing
TRANSACTION_URL = "http://localhost:5000"

def test_health():
    print("Checking health of Transaction Service...")
    try:
        resp = requests.get(f"{TRANSACTION_URL}/health")
        if resp.status_code == 200:
            print("✅ Transaction Service is healthy")
            return True
        else:
            print(f"❌ Transaction Service returned {resp.status_code}")
            return False
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return False

def test_flow():
    user_id = "test_user_1"
    
    # 1. Check Initial Balance
    print(f"\n1. Checking balance for {user_id}...")
    resp = requests.get(f"{TRANSACTION_URL}/balance", params={'userId': user_id})
    print(f"Response: {resp.json()}")
    
    # 2. Deposit
    print(f"\n2. Depositing $100...")
    resp = requests.post(f"{TRANSACTION_URL}/deposit", json={'userId': user_id, 'amount': 100})
    print(f"Response: {resp.json()}")
    
    # 3. Check Balance
    print(f"\n3. Checking balance again...")
    resp = requests.get(f"{TRANSACTION_URL}/balance", params={'userId': user_id})
    print(f"Response: {resp.json()}")
    
    # 4. Withdraw
    print(f"\n4. Withdrawing $30...")
    resp = requests.post(f"{TRANSACTION_URL}/withdraw", json={'userId': user_id, 'amount': 30})
    print(f"Response: {resp.json()}")
    
    # 5. Final Balance
    print(f"\n5. Final balance check...")
    resp = requests.get(f"{TRANSACTION_URL}/balance", params={'userId': user_id})
    balance = resp.json().get('balance')
    print(f"Response: {resp.json()}")
    
    if balance == 70:
        print("\n✅ Flow Test Passed: Balance is correct (100 - 30 = 70)")
    else:
        print(f"\n❌ Flow Test Failed: Expected 70, got {balance}")

if __name__ == "__main__":
    if test_health():
        test_flow()
    else:
        print("\nPlease ensure all 3 services are running on ports 5000, 5002, and 5003.")
