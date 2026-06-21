from flask import Flask, request, jsonify
import requests
import json
import os
import threading

app = Flask(__name__)

# Configuration
BACKUP_SERVICE_URL = os.environ.get('BACKUP_SERVICE_URL', 'http://localhost:5003')
DATA_FILE = 'accounts.json'
lock = threading.Lock()

def load_accounts():
    if not os.path.exists(DATA_FILE):
        return {}
    try:
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    except Exception:
        return {}

def save_accounts(accounts):
    with open(DATA_FILE, 'w') as f:
        json.dump(accounts, f, indent=4)

def log_transaction(transaction_data):
    """Send transaction log to Backup Service asynchronously"""
    def _send():
        try:
            requests.post(f"{BACKUP_SERVICE_URL}/log", json=transaction_data, timeout=2)
        except Exception as e:
            print(f"Failed to send log to backup service: {e}")
    
    # Run in a separate thread to not block the response
    threading.Thread(target=_send).start()

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'service': 'account-service'}), 200

@app.route('/balance', methods=['GET'])
def get_balance():
    user_id = request.args.get('userId')
    if not user_id:
        return jsonify({'error': 'userId is required'}), 400
        
    with lock:
        accounts = load_accounts()
        balance = accounts.get(user_id, 0.0)
        
    return jsonify({'userId': user_id, 'balance': balance}), 200

@app.route('/deposit', methods=['POST'])
def deposit():
    data = request.json
    user_id = data.get('userId')
    amount = data.get('amount')
    
    if not user_id or amount is None or amount <= 0:
        return jsonify({'error': 'Invalid input'}), 400
        
    with lock:
        accounts = load_accounts()
        current_balance = accounts.get(user_id, 0.0)
        new_balance = current_balance + amount
        accounts[user_id] = new_balance
        save_accounts(accounts)
    
    # Log transaction
    log_transaction({
        'type': 'DEPOSIT',
        'userId': user_id,
        'amount': amount,
        'finalBalance': new_balance
    })
    
    return jsonify({'message': 'Deposit successful', 'newBalance': new_balance}), 200

@app.route('/withdraw', methods=['POST'])
def withdraw():
    data = request.json
    user_id = data.get('userId')
    amount = data.get('amount')
    
    if not user_id or amount is None or amount <= 0:
        return jsonify({'error': 'Invalid input'}), 400
        
    with lock:
        accounts = load_accounts()
        current_balance = accounts.get(user_id, 0.0)
        
        if current_balance < amount:
            return jsonify({'error': 'Insufficient funds'}), 400
            
        new_balance = current_balance - amount
        accounts[user_id] = new_balance
        save_accounts(accounts)
    
    # Log transaction
    log_transaction({
        'type': 'WITHDRAW',
        'userId': user_id,
        'amount': amount,
        'finalBalance': new_balance
    })
    
    return jsonify({'message': 'Withdrawal successful', 'newBalance': new_balance}), 200

if __name__ == '__main__':
    # Run on all interfaces, port 5002 (default for this service)
    app.run(host='0.0.0.0', port=5002)
