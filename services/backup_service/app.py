from flask import Flask, request, jsonify
import json
from datetime import datetime
import os

app = Flask(__name__)

# Configuration
LOG_FILE = 'transaction_logs.txt'

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'service': 'backup-service'}), 200

@app.route('/log', methods=['POST'])
def log_transaction():
    data = request.json
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    timestamp = datetime.now().isoformat()
    log_entry = {
        'timestamp': timestamp,
        'data': data
    }
    
    try:
        with open(LOG_FILE, 'a') as f:
            f.write(json.dumps(log_entry) + '\n')
            
        return jsonify({'status': 'logged'}), 201
    except Exception as e:
        return jsonify({'error': 'Failed to write log', 'details': str(e)}), 500

if __name__ == '__main__':
    # Run on all interfaces, port 5003 (default for this service)
    app.run(host='0.0.0.0', port=5003)
