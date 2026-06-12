# Fraud Overview
# What percentage of transactions are flagged as fraud?
SELECT 
	ROUND(SUM(is_flagged_fraud)*100/COUNT(*), 2) AS fraud_transactions_percentage,
    SUM(is_flagged_fraud) AS fraud_transactions,
    COUNT(*) AS total_transactions
FROM transactions;

# What transaction value is associated with fraud?
SELECT 
	CASE 
		WHEN is_flagged_fraud=0 THEN "Not Fraud" 
		WHEN is_flagged_fraud=1 THEN "Fraud"
	END AS is_flagged_fraud,
	COUNT(*) AS transaction_count,
    ROUND(SUM(amount_gbp), 2) AS total_value_gbp,
    ROUND(AVG(amount_gbp), 2) AS avg_value_gbp
FROM transactions 
GROUP BY is_flagged_fraud;

# Fraud by Transaction Status
# Which transaction statuses are most associated with fraud?
SELECT 
	transaction_status,
    COUNT(*) AS total_transaction,
    SUM(is_flagged_fraud) AS fraud_transaction,
    ROUND(SUM(is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate
FROM transactions
GROUP BY transaction_status
ORDER BY fraud_rate DESC;

# What percentage of fraud transactions are completed vs blocked?
SELECT
	transaction_status,
    COUNT(*) AS fraud_transactions,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM transactions WHERE is_flagged_fraud=1), 2) AS percentage
FROM transactions
WHERE is_flagged_fraud = 1
GROUP BY transaction_status
ORDER BY fraud_transactions DESC;

# Which transaction types have the highest fraud rate
SELECT
	tt.type_name,
    COUNT(*) AS total_transactions,
    SUM(t.is_flagged_fraud) AS fraud_transactions,
    ROUND(SUM(t.is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.type_name
ORDER BY fraud_rate DESC;

# Fraud by Merchant Category
# Which merchant categories generate the most fraud alerts?
SELECT 
	mc.category_name,
    COUNT(*) AS fraud_transactions
FROM merchant_category mc
LEFT JOIN transactions t
	ON mc.merchant_category_id=t.merchant_category_id
WHERE t.is_flagged_fraud=1
GROUP BY mc.category_name
ORDER BY fraud_transactions DESC;

# Which merchant categories have the highest fraud rate?
SELECT 
	mc.category_name,
    ROUND(SUM(t.is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate,   
    SUM(t.is_flagged_fraud) AS fraud_transactions,
     COUNT(*) AS total_transactions
FROM merchant_category mc
LEFT JOIN transactions t 
	ON mc.merchant_category_id=t.merchant_category_id
GROUP BY mc.category_name
ORDER BY fraud_rate DESC;

# Fraud Risk by Category
# Does the fraud engine align with merchant risk classification?
SELECT
	mc.risk_flag,
    COUNT(*) AS total_transactions,
    SUM(is_flagged_fraud) AS fraud_transactions,
    ROUND(SUM(is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate
FROM merchant_category mc
LEFT JOIN transactions t 
	ON mc.merchant_category_id=t.merchant_category_id
GROUP BY mc.risk_flag
ORDER BY fraud_rate DESC;

# Fraud by Customer
# Which customers generate the highest number of fraud alerts?
SELECT 
	c.customer_name,
    COUNT(*) AS fraud_transactions,
    ROUND(SUM(t.amount_gbp), 2) AS fraud_value
FROM customer c
LEFT JOIN transactions t 
	ON c.customer_id=t.customer_id
GROUP BY c.customer_name
ORDER BY fraud_value DESC;

# Fraud by Customer Segment
# Which customer segments experience the highest fraud rates?
SELECT 
	c.customer_segment,
    ROUND(SUM(is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate,
    SUM(is_flagged_fraud) AS fraud_transactions,
	COUNT(*) AS total_transactions
FROM customer c
LEFT JOIN transactions t
	ON c.customer_id=t.customer_id
GROUP BY c.customer_segment
ORDER BY fraud_rate DESC;

# Fraud by Channel
# Which transaction channels are most exposed to fraud?
SELECT
	tt.channel,
    ROUND(SUM(is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate,
    SUM(is_flagged_fraud) AS fraud_transactions,
    COUNT(*) AS total_transactions
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.channel
ORDER BY fraud_rate DESC;

# Fraud by Device
SELECT
    device_type,
    COUNT(*) AS total_transactions,
    SUM(is_flagged_fraud) AS fraud_transactions,
    ROUND(SUM(is_flagged_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM transactions
GROUP BY device_type
ORDER BY fraud_rate DESC;

# Fraud Amount Analysis
# Are fraud transactions larger than normal transactions?
SELECT
    CASE 
		WHEN is_flagged_fraud=0 THEN "Not Fraud"
        WHEN is_flagged_fraud=1 THEN "Fraud"
	END AS is_flagged_fraud,
    ROUND(AVG(amount_gbp),2) AS avg_transaction_value,
    ROUND(MIN(amount_gbp),2) AS min_value,
    ROUND(MAX(amount_gbp),2) AS max_value
FROM transactions
GROUP BY is_flagged_fraud;

# Fraud Trend Over Time
# Is fraud increasing or decreasing over time?
SELECT
    DATE_FORMAT(transaction_date,'%Y-%m') AS yearmonth,
    COUNT(*) AS total_transactions,
    SUM(is_flagged_fraud) AS fraud_transactions,
    ROUND(
        SUM(is_flagged_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY yearmonth
ORDER BY yearmonth;