# Overall Transaction Activity
# How many transactions were processed and what was the total transaction value?
SELECT 
	COUNT(*) AS total_transactions,
    ROUND(SUM(amount_gbp), 2) AS total_transaction_value,
    ROUND(AVG(amount_gbp), 2) AS avg_transaction_value
FROM transactions;

# How many non-failed transactions were processed and what was the total transaction value?
SELECT 
	COUNT(*) AS total_transactions,
    ROUND(SUM(amount_gbp), 2) AS total_transaction_value,
    ROUND(AVG(amount_gbp), 2) AS avg_transaction_value
FROM transactions
WHERE transaction_status NOT IN ('Reversed', 'Declined');

# Daily Transaction Activity
# What is the average number of transactions processed per day?
SELECT
	ROUND(COUNT(*)/COUNT(DISTINCT transaction_date), 2) AS avg_transactions_per_day
FROM transactions;

# Daily Transaction Trend
# How does transaction volume vary by day?
SELECT
	transaction_date,
	COUNT(*) AS no_of_transactions,
    ROUND(SUM(amount_gbp), 2) AS transaction_value
FROM transactions
GROUP BY transaction_date
ORDER BY transaction_date;

# Monthly Transaction Trend
# How does transaction activity evolve over time?
SELECT 
	DATE_FORMAT(transaction_date, '%Y-%m') AS yearmonth,
    COUNT(*) AS no_of_transactions,
    ROUND(SUM(amount_gbp), 2) AS transaction_value
FROM transactions
GROUP BY yearmonth
ORDER BY yearmonth;

# Transaction Status Performance
# Transaction Status Distribution
# What percentage of transactions are completed, declined, pending and reversed?
SELECT 
	transaction_status,
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM transactions), 2) AS percentage
FROM transactions
GROUP BY transaction_status
ORDER BY percentage DESC;

# Completion Rate
# What is the overall transaction success rate?
SELECT 
	ROUND(
		SUM(CASE WHEN transaction_status='Completed' THEN 1 ELSE 0 END)*100/COUNT(*), 
		2
	) AS success_rate_percentage
FROM transactions;

# Failure Rate
# What percentage of transactions failed?
SELECT 
	ROUND(
		SUM(CASE WHEN transaction_status IN ('Declined', 'Reversed') THEN 1 ELSE 0 END)*100/COUNT(*), 
		2
	) AS failure_rate_percentage
FROM transactions;

# Transaction value by status
# How much transaction value is associated with each status?
SELECT 
	transaction_status,
    COUNT(*) AS no_of_transactions,
    ROUND(SUM(amount_gbp), 2) AS total_value,
    ROUND(AVG(amount_gbp), 2) AS avg_value
FROM transactions
GROUP BY transaction_status
ORDER BY total_value DESC, no_of_transactions DESC;

# Transaction type performance
# Most used transaction types
# Which transaction types are most frequently used?
SELECT 
	tt.type_name,
    COUNT(*) AS transaction_count
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.type_name
ORDER BY transaction_count DESC;

# Which transaction types drive the highest transaction value
SELECT 
	tt.type_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp), 2) AS total_value,
    ROUND(AVG(t.amount_gbp), 2) AS avg_value
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.type_name
ORDER BY total_value DESC;

# Status performance by transaction type
# Which transaction types have the highest completion and failure rates
SELECT 
	tt.type_name,
    t.transaction_status,
    COUNT(*) AS transaction_count
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.type_name, t.transaction_status
ORDER BY tt.type_name, transaction_count DESC; 

SELECT
    tt.type_name,
    ROUND(
        SUM(
            CASE
                WHEN t.transaction_status='Completed'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS completion_rate
FROM transactions t
JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
GROUP BY tt.type_name
ORDER BY completion_rate DESC;

SELECT
    tt.type_name,
    ROUND(
        SUM(
            CASE
                WHEN t.transaction_status IN ('Declined','Reversed')
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS failure_rate
FROM transactions t
JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
GROUP BY tt.type_name
ORDER BY failure_rate DESC;
 
 
 # Average Transaction Value by Status
 SELECT
    transaction_status,
    ROUND(AVG(amount_gbp),2) AS avg_transaction_value
FROM transactions
GROUP BY transaction_status
ORDER BY avg_transaction_value DESC;

# Fee Performance
# Total Fee Revenue
# How much fee revenue was generated?
SELECT
	ROUND(SUM(fee_charged_gbp), 2) AS total_fee_revenue
FROM transactions
WHERE transaction_status='Completed';

# Fee Revenue by Transaction type
# Which transaction types generate the most fee income?
SELECT
	tt.type_name,
	ROUND(SUM(t.fee_charged_gbp), 2) AS total_fee_revenue
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.type_name
ORDER BY total_fee_revenue DESC;

# Actual vs Expected Fees
# Are customers being charged the expected fees?
# typical_fee_gbp = 0 -> no fee
SELECT 
	tt.type_name, 
    ROUND(SUM(tt.typical_fee_gbp), 2) AS expected_fee_revenue,
    ROUND(SUM(t.fee_charged_gbp), 2) AS collected_fee_revenue,
    ROUND(SUM(t.fee_charged_gbp)-SUM(tt.typical_fee_gbp), 2) AS fee_diff
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
WHERE t.transaction_status = 'Completed'
GROUP BY tt.type_name
ORDER BY ABS(fee_diff) DESC;

-- output seems suspicious verifying:
SELECT
    tt.type_name,
    COUNT(*) AS completed_transactions,
    MIN(t.fee_charged_gbp) AS min_fee,
    MAX(t.fee_charged_gbp) AS max_fee,
    AVG(t.fee_charged_gbp) AS avg_fee
FROM transactions t
JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
WHERE t.transaction_status = 'Completed'
GROUP BY tt.type_name
ORDER BY tt.type_name;

SELECT
    tt.type_name,
    COUNT(*) AS completed_transactions,
    ROUND(SUM(tt.typical_fee_gbp),2) AS expected_fee_revenue,
    ROUND(SUM(t.fee_charged_gbp),2) AS actual_fee_revenue,
    ROUND(
        SUM(t.fee_charged_gbp)
        - SUM(tt.typical_fee_gbp),
        2
    ) AS fee_variance
FROM transactions t
JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
WHERE t.transaction_status = 'Completed'
GROUP BY tt.type_name
ORDER BY ABS(fee_variance) DESC;

SELECT
    tt.type_name,
    t.transaction_status,
    COUNT(*) AS transaction_count
FROM transactions t
JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
WHERE tt.typical_fee_gbp > 0
GROUP BY tt.type_name, t.transaction_status
ORDER BY tt.type_name;

/* Completed transactions for fee-bearing transaction types recorded no actual fees 
despite standard fee schedules indicating expected charges. This resulted in negative fee 
variance across Transfer-International, ATM Withdrawal, and Crypto Purchase transactions.
*/

# Operational Efficiency
# Failure Reasona Analysis
# What are the primary causes of transaction failures
SELECT
    failed_reason,
    COUNT(*) AS occurrence_count
FROM transactions
WHERE failed_reason IS NOT NULL
GROUP BY failed_reason
ORDER BY occurrence_count DESC;

# Top Customers by Transaction Volume
# Which customers are the most active 
SELECT
    c.customer_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp),2) AS total_value
FROM transactions t
JOIN customer c
    ON t.customer_id = c.customer_id
WHERE transaction_status='Completed'
GROUP BY c.customer_name
ORDER BY transaction_count DESC, total_value DESC
LIMIT 10;

# Top Customers by Transaction Value
# Which customers contribute the highest transaction value
SELECT
    c.customer_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp),2) AS total_value
FROM transactions t
JOIN customer c
    ON t.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_value DESC
LIMIT 10;