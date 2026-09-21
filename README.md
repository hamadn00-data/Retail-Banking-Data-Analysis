# Retail Banking Data Analysis

An end-to-end retail banking data analysis project using **Python, SQL, and Power BI** to explore customers, bank accounts, transactions, channels, balances, and loan portfolios.

## 📌 Project Overview

This project analyzes a retail banking dataset through a complete data analytics workflow:

**Data Cleaning → Exploratory Data Analysis → Statistical Analysis → SQL Analysis → Power BI Dashboard**

The objective is to transform raw banking data into meaningful insights that can support analysis of account activity, transaction behavior, customer distribution, balances, and loan portfolios.

---

## 🎯 Business Objectives

The project focuses on answering questions such as:

- How are accounts distributed across account types?
- What is the distribution of active and inactive accounts?
- Which transaction types generate the highest transaction amounts?
- How does transaction activity vary across channels?
- How are account balances distributed across states?
- Which states have higher loan exposure?
- How do loan amount, interest rate, and loan term relate to each other?
- How does transaction activity change over time?
- Which customers maintain multiple accounts?
- Are there transactions associated with accounts that do not exist in the account table?

---

## 🗂️ Dataset

The project contains four related datasets:

| Dataset | Description |
|---|---|
| `customer_profiles.csv` | Customer information and location |
| `bank_accounts.csv` | Account details, balances, and loan information |
| `account_transactions.csv` | Transaction-level banking activity |
| `transaction_codes.csv` | Transaction code reference information |

### Dataset Relationships

```text
Customer Profiles
        │
        │ customer_id
        ▼
Bank Accounts
        │
        │ account_id
        ▼
Account Transactions
        │
        │ transaction_code
        ▼
Transaction Codes
