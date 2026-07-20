💳 ApexLedger: Immutable Financial Ledger & Fraud Analytics Engine

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)



An end-to-end database engineering project featuring a custom-designed, high-integrity relational schema for a modern FinTech platform backend. It replaces volatile application-layer checks with zero-trust database constraints, implements an absolute write-only transactional ledger, and deploys self-joining time-series queries to expose complex, high-velocity fraud vectors.

📊 Core Technical Specifications
Database Component	Implementation Detail	Architecture Goal
Engine Configuration	MySQL 8.0+ Relational Schema	Enterprise Stability & Compliance
Core Core Entities	5 Interconnected Tables	Fully Relational Transactional Flow
Data Integrity Layer	Hardware CHECK & FOREIGN KEY Guardrails	Application-Agnostic Zero-Trust Security
Optimization Layer	Target B-Tree Indexes on High-Velocity Columns	Elimination of Full-Table Scans
Analytics Layer	Partitioned Window Functions & Self-Joins	Live Executive BI & Threat Profiling

💡 System Design: Inside the Ledger
Standard tutorial projects update financial accounts using basic, high-risk UPDATE statements (e.g., SET balance = balance - 100). In production banking environments, changing data in place violates financial regulatory standards.

ApexLedger implements a strict immutable, write-only transactional ledger. Every transaction is permanently recorded as a historical row. Live user balances are computed chronologically using rolling window functions over indexed data.


[External Funding Source] ──> [Immutable Ledger Entry] ──> [Indexed Views] ──> [Dashboard Panel]
                                      │
                                      └───> [Velocity Analytics Scan] ───> [Fraud Logs Trigger]
The 5-Table Architectural Framework
users: Customer profiles tracking identity status (KYC_STATUS) and compliance risk profiles.

accounts: Traditional funding links with custom status mapping.

wallets: Digital cash records enforcing atomic balance protections.

transactions: The core immutable transactional ledger tracking fund movements.

fraud_logs: Target incident logs for compliance engine triggers.

🛠️ Core Engineering Highlights
🔒 Zero-Trust Hardening: Data integrity is protected at the hardware layer using rigid CHECK constraints (balance≥0.00 and amount>0.00), rendering it mathematically impossible for bugs in frontend software to force a negative balance or an invalid transaction.

1
Establish Referential Integrity
Data Layer
Configured explicit ON DELETE RESTRICT rules across critical foreign keys, ensuring historical transactional data can never be orphaned or corrupted by accidental profile deletions.

2
Deploy Target Performance Indexes
Optimization Layer
Engineered B-Tree indexes on high-velocity transactional columns and timestamps (idx_transactions_timestamp_type) to optimize complex multi-table joins and keep queries highly performant under production scaling.

3
Isolate Behavioral Anomalies
Analytics Layer
Developed self-joining time-series queries that isolate potential money-laundering patterns by tracking multiple rapid-fire peer-to-peer transfers originating from the same sender within a strict 60-second window.

4
Abstract via Reusable Views
Reporting Layer
Abstracted intensive rolling calculations into permanent database Views (view_historical_account_ledgers), allowing downstream BI tools or application frameworks to pull immaculate running balances with a clean, single-line query.


📈 Live BI Dashboard Panels Included
The analytics engine automatically populates three operational panels to power live compliance and performance dashboards:
Real-Time Historical Balance Statements: Tracks dynamic, transactional cash flows and historical wallet status per user via partitioned window mechanics.
Velocity Threat Monitoring Panel: Instantly exposes high-risk users bypassing traditional application velocity checks using time-series intervals.
Executive Platform Performance Check: Evaluates global processing volume, average transaction sizing, and system success percentages using safe NULLIF structural logic.

🚀 One-Click Local Deployment
Clone this repository to your local machine.
Open apex_ledger.sql inside MySQL Workbench or your preferred SQL terminal interface.
Execute the entire file. The script cleanly builds the workspace, generates indexed relationships, seeds a multi-week production mock data matrix, and outputs the live analytical dashboard panels instantly.
