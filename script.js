/**
 * ===========================================================
 * Secure Banking Portal - JavaScript
 * Multi-VPC Banking Microservices Architecture
 * ===========================================================
 * 
 * This script handles all frontend interactions and API
 * communication with the backend Transaction Service.
 * 
 * IMPORTANT: The frontend does NOT store any data.
 * All data persistence is handled by the backend API.
 * ===========================================================
 */

// ===========================================================
// CONFIGURATION
// ===========================================================
/**
 * Backend API Base URL
 * Replace <TRANSACTION_SERVICE_PUBLIC_IP> with your EC2 instance's
 * public IP address where the Transaction Service is running.
 * 
 * Example: const API_BASE_URL = "http://54.123.45.67:5000";
 */
const API_BASE_URL = "http://YOUR_EC2_PUBLIC_IP:5000";

// ===========================================================
// DOM ELEMENTS
// ===========================================================
const userIdInput = document.getElementById('userId');
const amountInput = document.getElementById('amount');
const checkBalanceBtn = document.getElementById('checkBalanceBtn');
const depositBtn = document.getElementById('depositBtn');
const withdrawBtn = document.getElementById('withdrawBtn');
const clearResponseBtn = document.getElementById('clearResponseBtn');
const balanceAmount = document.getElementById('balanceAmount');
const responseDisplay = document.getElementById('responseDisplay');
const loadingOverlay = document.getElementById('loadingOverlay');
const connectionStatus = document.getElementById('connectionStatus');

// ===========================================================
// SVG ICONS FOR RESPONSE MESSAGES
// ===========================================================
const ICONS = {
    success: `<svg viewBox="0 0 24 24" fill="none"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M22 4L12 14.01l-3-3" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>`,
    error: `<svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/><path d="M15 9l-6 6M9 9l6 6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>`,
    info: `<svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/><path d="M12 16v-4M12 8h.01" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>`
};

// ===========================================================
// UTILITY FUNCTIONS
// ===========================================================

/**
 * Show loading overlay during API requests
 */
function showLoading() {
    loadingOverlay.classList.add('active');
}

/**
 * Hide loading overlay after API requests complete
 */
function hideLoading() {
    loadingOverlay.classList.remove('active');
}

/**
 * Update the connection status indicator
 * @param {string} status - 'connected', 'error', or 'connecting'
 */
function updateConnectionStatus(status) {
    const statusText = connectionStatus.querySelector('.status-text');
    connectionStatus.classList.remove('connected', 'error');

    switch (status) {
        case 'connected':
            connectionStatus.classList.add('connected');
            statusText.textContent = 'Connected';
            break;
        case 'error':
            connectionStatus.classList.add('error');
            statusText.textContent = 'Disconnected';
            break;
        default:
            statusText.textContent = 'Connecting...';
    }
}

/**
 * Display a message in the response area
 * @param {string} message - The message to display
 * @param {string} type - 'success', 'error', or 'info'
 */
function displayMessage(message, type = 'info') {
    // Remove placeholder if exists
    const placeholder = responseDisplay.querySelector('.response-placeholder');
    if (placeholder) {
        placeholder.remove();
    }

    // Create message element
    const messageEl = document.createElement('div');
    messageEl.className = `response-message ${type}`;
    messageEl.innerHTML = `${ICONS[type]}<span>${message}</span>`;

    // Add timestamp
    const timestamp = new Date().toLocaleTimeString();
    messageEl.innerHTML += `<small style="margin-left: auto; opacity: 0.7; font-size: 0.75rem;">${timestamp}</small>`;

    // Prepend to show newest first
    responseDisplay.insertBefore(messageEl, responseDisplay.firstChild);

    // Scroll to top to show new message
    responseDisplay.scrollTop = 0;
}

/**
 * Clear all messages from response display
 */
function clearMessages() {
    responseDisplay.innerHTML = `
        <div class="response-placeholder">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                <path d="M12 16V12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                <circle cx="12" cy="8" r="1" fill="currentColor"/>
            </svg>
            <p>Transaction responses will appear here</p>
        </div>
    `;
}

/**
 * Update the balance display
 * @param {number|string} balance - The balance to display
 */
function updateBalance(balance) {
    if (typeof balance === 'number') {
        balanceAmount.textContent = balance.toFixed(2);
    } else {
        balanceAmount.textContent = balance;
    }
}

/**
 * Validate user inputs before making API requests
 * @param {boolean} requireAmount - Whether amount field is required
 * @returns {object|null} - Returns {userId, amount} or null if invalid
 */
function validateInputs(requireAmount = false) {
    const userId = userIdInput.value.trim();
    const amount = parseFloat(amountInput.value);

    // Validate User ID
    if (!userId) {
        displayMessage('Please enter a valid User ID', 'error');
        userIdInput.focus();
        return null;
    }

    // Validate Amount if required
    if (requireAmount) {
        if (isNaN(amount) || amount <= 0) {
            displayMessage('Please enter a valid positive amount', 'error');
            amountInput.focus();
            return null;
        }
    }

    return { userId, amount };
}

// ===========================================================
// API COMMUNICATION FUNCTIONS
// ===========================================================

/**
 * Check account balance via GET /balance endpoint
 * 
 * API Endpoint: GET /balance?userId={userId}
 * Response format: { balance: number }
 */
async function checkBalance() {
    const inputs = validateInputs(false);
    if (!inputs) return;

    showLoading();

    try {
        // Make GET request to balance endpoint
        const response = await fetch(`${API_BASE_URL}/balance?userId=${encodeURIComponent(inputs.userId)}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json'
            }
        });

        const data = await response.json();

        if (response.ok) {
            // Update balance display with returned value
            updateBalance(data.balance);
            displayMessage(`Balance retrieved successfully for user: ${inputs.userId}`, 'success');
            updateConnectionStatus('connected');
        } else {
            // Handle error response from server
            displayMessage(data.message || data.error || 'Failed to retrieve balance', 'error');
            updateConnectionStatus('error');
        }
    } catch (error) {
        // Handle network errors
        console.error('Balance check failed:', error);
        displayMessage(`Connection error: Unable to reach the server. Please check if the Transaction Service is running.`, 'error');
        updateConnectionStatus('error');
    } finally {
        hideLoading();
    }
}

/**
 * Deposit amount via POST /deposit endpoint
 * 
 * API Endpoint: POST /deposit
 * Request body: { userId: string, amount: number }
 * Response format: { message: string, newBalance: number }
 */
async function deposit() {
    const inputs = validateInputs(true);
    if (!inputs) return;

    showLoading();

    try {
        // Make POST request to deposit endpoint
        const response = await fetch(`${API_BASE_URL}/deposit`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({
                userId: inputs.userId,
                amount: inputs.amount
            })
        });

        const data = await response.json();

        if (response.ok) {
            // Update balance and show success message
            if (data.newBalance !== undefined) {
                updateBalance(data.newBalance);
            }
            displayMessage(`Successfully deposited $${inputs.amount.toFixed(2)} to account: ${inputs.userId}`, 'success');
            updateConnectionStatus('connected');
            // Clear amount input after successful transaction
            amountInput.value = '';
        } else {
            // Handle error response from server
            displayMessage(data.message || data.error || 'Deposit failed', 'error');
        }
    } catch (error) {
        // Handle network errors
        console.error('Deposit failed:', error);
        displayMessage(`Connection error: Unable to reach the server. Please check if the Transaction Service is running.`, 'error');
        updateConnectionStatus('error');
    } finally {
        hideLoading();
    }
}

/**
 * Withdraw amount via POST /withdraw endpoint
 * 
 * API Endpoint: POST /withdraw
 * Request body: { userId: string, amount: number }
 * Response format: { message: string, newBalance: number }
 */
async function withdraw() {
    const inputs = validateInputs(true);
    if (!inputs) return;

    showLoading();

    try {
        // Make POST request to withdraw endpoint
        const response = await fetch(`${API_BASE_URL}/withdraw`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({
                userId: inputs.userId,
                amount: inputs.amount
            })
        });

        const data = await response.json();

        if (response.ok) {
            // Update balance and show success message
            if (data.newBalance !== undefined) {
                updateBalance(data.newBalance);
            }
            displayMessage(`Successfully withdrew $${inputs.amount.toFixed(2)} from account: ${inputs.userId}`, 'success');
            updateConnectionStatus('connected');
            // Clear amount input after successful transaction
            amountInput.value = '';
        } else {
            // Handle error responses (e.g., insufficient balance)
            displayMessage(data.message || data.error || 'Withdrawal failed', 'error');
        }
    } catch (error) {
        // Handle network errors
        console.error('Withdrawal failed:', error);
        displayMessage(`Connection error: Unable to reach the server. Please check if the Transaction Service is running.`, 'error');
        updateConnectionStatus('error');
    } finally {
        hideLoading();
    }
}

// ===========================================================
// EVENT LISTENERS
// ===========================================================

// Button click handlers
checkBalanceBtn.addEventListener('click', checkBalance);
depositBtn.addEventListener('click', deposit);
withdrawBtn.addEventListener('click', withdraw);
clearResponseBtn.addEventListener('click', clearMessages);

// Allow Enter key to submit from input fields
userIdInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        amountInput.focus();
    }
});

amountInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        // Default to check balance if no amount, otherwise deposit
        if (amountInput.value) {
            deposit();
        } else {
            checkBalance();
        }
    }
});

// ===========================================================
// INITIALIZATION
// ===========================================================

/**
 * Initialize the application on page load
 */
function init() {
    console.log('Secure Banking Portal initialized');
    console.log(`API Base URL: ${API_BASE_URL}`);

    // Display initial info message
    displayMessage('Welcome to Secure Banking Portal. Enter your User ID to get started.', 'info');

    // Set connection status to connecting (will update on first API call)
    updateConnectionStatus('connecting');
}

// Run initialization when DOM is ready
document.addEventListener('DOMContentLoaded', init);
