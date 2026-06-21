from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import os
import sys

# Add the parent directory to sys.path to allow importing common modules if any
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

app = Flask(__name__)
CORS(app)  # Enable CORS for frontend access

# Configuration
ACCOUNT_SERVICE_URL = os.environ.get('ACCOUNT_SERVICE_URL', 'http://localhost:5002')

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'service': 'transaction-service'}), 200

@app.route('/balance', methods=['GET'])
def get_balance():
    user_id = request.args.get('userId')
    if not user_id:
        return jsonify({'error': 'userId is required'}), 400
        
    try:
        # Forward request to Account Service
        response = requests.get(f"{ACCOUNT_SERVICE_URL}/balance", params={'userId': user_id})
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({'error': 'Account service unreachable', 'details': str(e)}), 503

@app.route('/deposit', methods=['POST'])
def deposit():
    data = request.json
    if not data or 'userId' not in data or 'amount' not in data:
        return jsonify({'error': 'Invalid request data'}), 400
        
    try:
        # Forward request to Account Service
        response = requests.post(f"{ACCOUNT_SERVICE_URL}/deposit", json=data)
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({'error': 'Account service unreachable', 'details': str(e)}), 503

@app.route('/withdraw', methods=['POST'])
def withdraw():
    data = request.json
    if not data or 'userId' not in data or 'amount' not in data:
        return jsonify({'error': 'Invalid request data'}), 400
        
    try:
        # Forward request to Account Service
        response = requests.post(f"{ACCOUNT_SERVICE_URL}/withdraw", json=data)
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({'error': 'Account service unreachable', 'details': str(e)}), 503

if __name__ == '__main__':
    # Run on all interfaces, port 5000 (default for this service)
    app.run(host='0.0.0.0', port=5000)
