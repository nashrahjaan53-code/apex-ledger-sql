create database apex_ledger;
use apex_ledger;
create table users(
user_id int AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) unique NOT NULL,
    kyc_status ENUM('PENDING', 'VERIFIED', 'REJECTED') DEFAULT 'PENDING',
    risk_profile ENUM('LOW', 'MEDIUM', 'HIGH') DEFAULT 'LOW',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);
CREATE TABLE accounts(
account_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
account_type ENUM('CHECKING', 'SAVINGS', 'BUSINESS') NOT NULL,
bank_name VARCHAR(100) NOT NULL,
account_number VARCHAR(20) UNIQUE NOT NULL,
account_status ENUM ('ACTIVE', 'SUSPENDED') DEFAULT 'ACTIVE',
 FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);
CREATE TABLE wallets(
wallet_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
currency VARCHAR(3) DEFAULT 'USD',
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    CONSTRAINT chk_positive_balance CHECK (balance >= 0.00)
);
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_wallet_id INT, -- NULL means external bank deposit
    receiver_wallet_id INT, -- NULL means external bank withdrawal
    amount DECIMAL(15, 2) NOT NULL,
    transaction_type ENUM('DEPOSIT', 'WITHDRAWAL', 'PEER_TO_PEER', 'MERCHANT') NOT NULL,
    status ENUM('SUCCESS', 'FAILED', 'FLAGGED') DEFAULT 'SUCCESS',
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_positive_amount CHECK (amount > 0.00),
    FOREIGN KEY (sender_wallet_id) REFERENCES wallets(wallet_id),
    FOREIGN KEY (receiver_wallet_id) REFERENCES wallets(wallet_id)
);
CREATE TABLE fraud_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    rule_triggered VARCHAR(100) NOT NULL,
    severity ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL,
    investigation_status ENUM('OPEN', 'CLEARED', 'CONFIRMED_FRAUD') DEFAULT 'OPEN',
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);
INSERT INTO users(full_name,email, kyc_status,risk_profile) VALUES
('Alice Smith', 'alice@email.com', 'VERIFIED', 'LOW'),
('Bob Jones', 'bob@email.com', 'VERIFIED', 'MEDIUM'),
('Charlie Brown', 'charlie@email.com', 'PENDING', 'HIGH'),
('Diana Prince', 'diana@email.com', 'VERIFIED', 'LOW'),
('Evan Wright', 'evan@email.com', 'REJECTED', 'HIGH');
INSERT INTO wallets(user_id, balance) VALUES
(1, 4500.00),
(2, 120.00),
(3, 15000.00),
(4, 750.00);
INSERT INTO transactions (sender_wallet_id, receiver_wallet_id, amount, transaction_type, status, timestamp) VALUES
(NULL, 1, 5000.00, 'DEPOSIT', 'SUCCESS', '2026-07-01 09:00:00'),
(NULL, 2, 1200.00, 'DEPOSIT', 'SUCCESS', '2026-07-01 09:15:00'),
(NULL, 3, 25000.00, 'DEPOSIT', 'SUCCESS', '2026-07-02 10:00:00'),
(1, 2, 450.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-02 14:20:00'),
(2, 4, 350.00, 'MERCHANT', 'SUCCESS', '2026-07-02 16:45:00'),
(3, 1, 5000.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-03 11:00:00'),
(1, NULL, 1200.00, 'WITHDRAWAL', 'SUCCESS', '2026-07-03 15:30:00'),
(2, NULL, 1500.00, 'WITHDRAWAL', 'FAILED', '2026-07-03 15:32:00'), 
(3, 1, 2500.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-08 14:00:00'),
(3, 2, 2500.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-08 14:00:15'),
(3, 4, 2500.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-08 14:00:40'),
(4, 1, 150.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-09 09:30:00'),
(1, 4, 85.50, 'MERCHANT', 'SUCCESS', '2026-07-09 18:22:00'),
(2, 3, 90.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-10 12:00:00'),
(NULL, 4, 3000.00, 'DEPOSIT', 'SUCCESS', '2026-07-12 08:45:00'),
(4, 2, 1200.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-12 13:10:00'),
(1, 4, 2450.00, 'PEER_TO_PEER', 'FLAGGED', '2026-07-14 17:05:00'),
(2, NULL, 400.00, 'WITHDRAWAL', 'SUCCESS', '2026-07-15 10:30:00'),
(3, 4, 600.00, 'MERCHANT', 'SUCCESS', '2026-07-16 19:15:00'),
(4, 1, 320.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-17 11:40:00'),
(1, 2, 15.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-18 08:00:00'),
(1, 3, 45.00, 'MERCHANT', 'SUCCESS', '2026-07-18 08:05:00'),
(2, 4, 120.00, 'MERCHANT', 'SUCCESS', '2026-07-18 09:12:00'),
(4, 3, 550.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-18 14:30:00'),
(3, NULL, 1000.00, 'WITHDRAWAL', 'SUCCESS', '2026-07-19 16:00:00'),
(2, 1, 250.00, 'PEER_TO_PEER', 'SUCCESS', '2026-07-20 10:00:00'),
(4, 2, 85.00, 'MERCHANT', 'SUCCESS', '2026-07-20 13:15:00');

SELECT 
    t.transaction_id,
    t.timestamp,
    u.full_name AS user_name,
    t.transaction_type,
    CASE 
        WHEN t.sender_wallet_id = w.wallet_id THEN -t.amount
        WHEN t.receiver_wallet_id = w.wallet_id THEN t.amount
    END AS net_amount,
    SUM(CASE 
        WHEN t.sender_wallet_id = w.wallet_id THEN -t.amount
        WHEN t.receiver_wallet_id = w.wallet_id THEN t.amount
    END) OVER (PARTITION BY w.wallet_id ORDER BY t.timestamp, t.transaction_id) AS running_wallet_balance
FROM transactions t
JOIN wallets w ON w.wallet_id IN (t.sender_wallet_id, t.receiver_wallet_id)
JOIN users u ON w.user_id = u.user_id
WHERE t.status = 'SUCCESS'
ORDER BY u.full_name, t.timestamp;

SELECT 
    t1.transaction_id AS original_tx_id,
    u.full_name AS sender_name,
    t1.amount AS initial_amount,
    t2.transaction_id AS rapid_followup_tx_id,
    t2.amount AS secondary_amount,
    TIMESTAMPDIFF(SECOND, t1.timestamp, t2.timestamp) AS seconds_between_transactions
FROM transactions t1
JOIN transactions t2 
    ON t1.sender_wallet_id = t2.sender_wallet_id 
    AND t1.transaction_id < t2.transaction_id
JOIN wallets w ON t1.sender_wallet_id = w.wallet_id
JOIN users u ON w.user_id = u.user_id
WHERE t1.transaction_type = 'PEER_TO_PEER'
  AND t2.transaction_type = 'PEER_TO_PEER'
  AND t2.timestamp >= t1.timestamp 
  AND t2.timestamp <= DATE_ADD(t1.timestamp, INTERVAL 60 SECOND)
ORDER BY t1.timestamp;

SELECT 
    COUNT(transaction_id) AS total_processed_transactions,
    COALESCE(SUM(CASE WHEN status = 'SUCCESS' THEN amount END), 0.00) AS total_successful_volume,
    ROUND(AVG(CASE WHEN status = 'SUCCESS' THEN amount END), 2) AS average_transaction_value,
    ROUND(
        (COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END) * 100.0) / 
        NULLIF(COUNT(transaction_id), 0), 
        2
    ) AS system_success_rate_percentage
FROM transactions;


