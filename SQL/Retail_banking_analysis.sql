Create table account_transaction (
transaction_id Varchar(100),
account_id Varchar(100),
linked_transaction_id Varchar(100),
created_time Timestamp,
transaction_type Varchar(50),
transaction_code Varchar(50),
amount float,
channel Varchar(50)
);
Select * from account_transaction;

Create table bank_accounts (
account_id Varchar(100),
customer_id Varchar(100),
account_type Varchar(50),
creation_date Timestamp,
account_status Varchar(50),
balance float,
loan_amount float,
term_months int,
interest_rate float
);

Select * from bank_accounts;

Create table customer_profiles (
customer_id Varchar(100),
national_id Varchar(100),
birth_date Timestamp,
city Varchar(50),
state Varchar(50)
);

Select * from customer_profiles;

---- 1. Total customers ----
Select count(Distinct customer_id) as Total_customers
from customer_profiles;

---- 2. Account distribution ----
Select account_type, count(Distinct account_id) as total_accounts
from bank_accounts
group by account_type
order by total_accounts desc;

---- 3. Account status analysis ----
Select account_status, count(Distinct account_id) as total_accounts,
sum(balance) as total_balance,
Avg(balance) as Average_balance
from bank_accounts
group by account_status;

---- 4. Transaction analysis by type ----
Select transaction_type, count(Distinct transaction_id) as total_transactions,
sum(amount) as total_amount,
Avg(amount) as average_amount,
max(amount) as maximum_amount
from account_transaction
group by transaction_type;

---- 5. Transaction analysis by channel ----
Select channel, count(Distinct transaction_id) as total_transactions,
sum(amount) as total_amount,
Avg(amount) as average_amount,
max(amount) as maximum_amount
from account_transaction
group by channel;

---- 6. Transaction type + channel ----
Select transaction_type, channel, count(Distinct transaction_id) as total_transactions,
sum(amount) as total_amount,
Avg(amount) as average_amount,
max(amount) as maximum_amount
from account_transaction
group by transaction_type, channel
order by total_transactions desc;

---- 7. Customer + account analysis ----
Select cp.state, b.account_type, b.account_status,
count(Distinct account_id) as total_account,
sum(b.balance) as total_balance,
avg(b.balance) as average_balance
from customer_profiles as cp
join
bank_accounts as b
on cp.customer_id = b.customer_id
group by cp.state, b.account_type, b.account_status
order by total_balance desc;

---- 8. Balance by state ----
Select cp.state,
count(Distinct account_id) as total_account,
sum(b.balance) as total_balance,
avg(b.balance) as average_balance
from customer_profiles as cp
join
bank_accounts as b
on cp.customer_id = b.customer_id
group by cp.state
order by total_balance desc;

---- 9. Customer + account + transaction ----
Select cp.state, ba.account_type, at.transaction_type,
count(Distinct transaction_id) as total_transactions,
sum(at.amount) as total_amount,
Avg(at.amount) as average_amount
from customer_profiles as cp
join
bank_accounts as ba
on cp.customer_id = ba.customer_id
join
account_transaction as at
on ba.account_id = at.account_id
group by cp.state, ba.account_type, at.transaction_type;

---- 10. Balance categorization using CASE ----
Select account_id, account_type, balance,
case when balance < 0 Then 'Negative'
     when balance = 0 Then 'Zero'
	 when balance < 50000 Then 'Low'
	 when balance < 200000 Then 'Medium'
	 Else 'High'
	 End as balance_category
from bank_accounts;

---- 11. Customers with multiple accounts ----
Select customer_id, count(account_id) as total_accounts
from bank_accounts
group by customer_id
having count(account_id) > 1
order by total_accounts desc;

---- 12. Customers with multiple account types ----
Select customer_id, count(Distinct account_type) as total_account_types
from bank_accounts
group by customer_id
having count(Distinct account_type) > 1
Order by total_account_types desc;

---- 13. Loan portfolio analysis ----
Select count(*) as total_loans,
sum(loan_amount) as total_loan_amount,
avg(loan_amount)  as average_loan_amount,
avg(term_months) as average_term_months,
avg(interest_rate) as average_interest_rate
from bank_accounts
where account_type = 'Loan';

---- 14. Loan analysis by state ----
Select cp.state, 
count(ba.account_id) as total_loans,
sum(ba.loan_amount) as total_loan_amount,
avg(ba.loan_amount)  as average_loan_amount,
avg(ba.term_months) as average_term_months,
avg(ba.interest_rate) as average_interest_rate
from bank_accounts ba
join
customer_profiles cp
on cp.customer_id = ba.customer_id
where ba.account_type = 'Loan'
Group by cp.state
order by total_loan_amount desc;

---- 15. Accounts above average balance ----
Select account_id, customer_id, account_type, balance
from bank_accounts
where balance > (Select avg(balance) from bank_accounts)
order by balance desc;

---- 16. Monthly transaction analysis ----
Select To_char(created_time, 'YYYY-MM') as month,
count(*) as total_transactions,
sum(amount) as total_amount,
avg(amount) as average_amount
from account_transaction
group by month
order by month;

---- 17. Monthly running total ----
With t1 as (
Select To_char(created_time, 'YYYY-MM') as month,
sum(amount) as monthly_amount
from account_transaction
group by month
order by month)
Select month, monthly_amount,
sum(monthly_amount) over(Order by month) as running_total
from t1;

---- 18. Month-over-month growth ----
with t1 as (
Select To_char(created_time, 'YYYY-MM') as month,
sum(amount) as monthly_amount
from account_transaction
group by month
order by month
),
t2 as (
Select month, monthly_amount,
lag(monthly_amount) over(Order by month) as previous_monthly_amount
from t1
)
Select month, monthly_amount, previous_monthly_amount,
(monthly_amount - previous_monthly_amount) as amount_change,
round(( 100 * (monthly_amount - previous_monthly_amount)/Nullif(previous_monthly_amount, 0))::numeric, 2) as percentage_change
from t2

---- 19. Top customer in each state ----
with t1 as (
Select cp.state, cp.customer_id, 
sum(ba.balance) as total_balance
from customer_profiles as cp
join
bank_accounts as ba
on cp.customer_id = ba.customer_id
group by cp.state, cp.customer_id),
t2 as (
Select state, customer_id, total_balance,
dense_rank() over (partition by state order by total_balance desc) as rank_no
from t1)
Select state, customer_id, total_balance 
from t2 
where rank_no = 1
order by total_balance desc;

---- 20. Data-quality check ----
Select at.transaction_id, at.account_id
from account_transaction as at
left join bank_accounts as ba 
on at.account_id = ba.account_id
where ba.account_id is null;







Select * from account_transaction;
Select * from bank_accounts;
Select * from customer_profiles;

