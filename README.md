💳 ApexLedger: Immutable Financial Ledger & Fraud Analytics Engine
![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
 An end-to-end database engineering project featuring a custom-designed, high-integrity relational schema for a modern FinTech platform backend. It replaces volatile application-layer checks with zero-trust database constraints, implements an absolute write-only transactional ledger, and deploys self-joining time-series queries to expose complex, high-velocity fraud vectors.

💡 System Concept & Architecture
Standard tutorial projects update financial accounts using basic, high-risk UPDATE statements (e.g., SET balance = balance - 100). In production banking environments, changing data in place violates financial regulatory standards.

ApexLedger implements an immutable, write-only transactional ledger. Every transaction is permanently recorded as a historical row. Live user balances are computed chronologically using rolling window functions over indexed data.

The backend infrastructure maps 5 deeply interconnected tables:

users: Customer profiles tracking identity status (KYC_STATUS) and compliance risk profiles.

accounts: Traditional funding links with custom status mapping.

wallets: Digital cash records enforcing atomic balance protections.

transactions: The core immutable transactional ledger.

fraud_logs: Target incident logs for compliance engine triggers.

🛠️ Core Design Decisions & Engineering Highlights
Zero-Trust Hardening: Data integrity is protected at the hardware layer using rigid CHECK constraints (balance≥0.00 and amount>0.00), rendering it mathematically impossible for bugs in frontend software to force a negative balance or an invalid transaction.

Defensive Deletion Layer: Configured explicit ON DELETE RESTRICT foreign key rules across critical profiles. This ensures a customer's profile or active wallet can never be accidentally deleted or orphaned if a historical financial record relies on it.

Query Performance Indexing: Engineered a target indexing strategy on high-velocity transactional foreign keys and timestamps (idx_transactions_timestamp_type). This completely eliminates full-table scans during heavy multi-table joins and sliding-window time calculations.

Velocity Fraud Engine: Developed complex, self-joining time-series queries that isolate potential money-laundering patterns by detecting multiple rapid-fire peer-to-peer transfers originating from the same sender within a strict 60-second window.

Reusable BI View Layers: Abstracted intensive SUM() OVER (PARTITION BY...) rolling calculations into permanent database Views (view_historical_account_ledgers). Downstream reporting dashboards or external apps can extract flawless historical ledgers with a clean, single-line query.

Resilient Mathematical Operations: Integrated proactive NULLIF structural logic within corporate liquidity calculations to safely avoid catastrophic divide-by-zero runtime exceptions during periods of zero transaction volume.

📊 Analytics & BI Dashboards Included
The analytics script automatically builds three distinct operational panels to power live corporate dashboards:

Real-Time Historical Balance Statements: Tracks dynamic, transactional cash flows and historical wallet status per user.

Velocity Threat Monitoring Panel: Instantly exposes high-risk users bypassing traditional application velocity checks.

Executive Platform Performance Check: Evaluates global processing volume, average transaction sizing, and system success percentages.

📈 Tech Stack & Advanced Mechanics
Database Engine: MySQL 8.0+

SQL Mastery: Window Functions (PARTITION BY, SUM OVER), Self-Joins, Time Mechanics (TIMESTAMPDIFF, DATE_ADD), Reusable Views (CREATE OR REPLACE VIEW), Index Optimization (CREATE INDEX), Conditional Aggregations (CASE WHEN), Data Integrity Constraints (CHECK, FOREIGN KEY).

🚀 One-Click Local Deployment
Clone this repository to your machine.

Open apex_ledger.sql inside MySQL Workbench or your preferred SQL terminal interface.

Execute the entire file. The script cleanly builds the database workspace, creates the indexed structures, seeds a multi-week pro
