# Merchant Category Usage
# Which merchant categories are used most frequently?
SELECT
	mc.category_name,
    COUNT(*) AS transaction_count
FROM merchant_category mc
LEFT JOIN transactions t
	ON mc.merchant_category_id=t.merchant_category_id
GROUP BY mc.category_name
ORDER BY transaction_count DESC;

# Which merchant categories drive the highest transaction value?
SELECT
	mc.category_name,
    ROUND(SUM(amount_gbp), 2) AS total_value,
    ROUND(AVG(amount_gbp), 2) AS avg_transaction_value
FROM merchant_category mc
LEFT JOIN transactions t
	ON mc.merchant_category_id=t.merchant_category_id
GROUP BY mc.category_name
ORDER BY total_value DESC;

# Sector performance
# Which sectors generate the highest transaction activity?
SELECT
	mc.sector,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp), 2) AS total_value
FROM merchant_category mc
LEFT JOIN transactions t
	ON mc.merchant_category_id=t.merchant_category_id
GROUP BY mc.sector
ORDER BY total_value DESC;

# What is the average transaction value by sector?
SELECT
    mc.sector,
    ROUND(AVG(t.amount_gbp), 2) AS avg_transaction_value
FROM transactions t
JOIN merchant_category mc
    ON t.merchant_category_id = mc.merchant_category_id
GROUP BY mc.sector
ORDER BY avg_transaction_value DESC;

# Category Operational Performance
# Which merchant categories have the highest completion rates?
SELECT 
	mc.category_name, 
	ROUND(SUM(CASE WHEN t.transaction_status='Completed' THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS completion_rate
FROM merchant_category mc
LEFT JOIN transactions t 
	ON mc.merchant_category_id=t.merchant_category_id
GROUP BY mc.category_name
ORDER BY completion_rate DESC;

# Which merchant categories have the highest failure rates?
SELECT 
	mc.category_name, 
	ROUND(SUM(CASE WHEN t.transaction_status IN ('Reversed', 'Declined') THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS failure_rate
FROM merchant_category mc
LEFT JOIN transactions t 
	ON mc.merchant_category_id=t.merchant_category_id
GROUP BY mc.category_name
ORDER BY failure_rate DESC;

# How does transaction status vary across merchant categories?
SELECT
    mc.category_name,
    t.transaction_status,
    COUNT(*) AS transaction_count
FROM merchant_category mc
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
GROUP BY mc.category_name, t.transaction_status
ORDER BY mc.category_name, transaction_count DESC;

# Risk Analysis
# How are transactions distributed across risk categories?
SELECT
	risk_flag,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp), 2) AS total_value
FROM merchant_category mc
LEFT JOIN transactions t
	ON mc.merchant_category_id=t.merchant_category_id
GROUP BY risk_flag
ORDER BY transaction_count DESC;

# Which risk categories drive the highest transaction value?
SELECT
    risk_flag,
    ROUND(SUM(t.amount_gbp),2) AS total_value,
    ROUND(AVG(t.amount_gbp),2) AS avg_transaction_value
FROM merchant_category mc
LEFT JOIN transactions t 
    ON t.merchant_category_id = mc.merchant_category_id
GROUP BY risk_flag
ORDER BY total_value DESC;

# Fraud Analysis by Merchant Category
# Which merchant categories generate the most fraud alerts?
SELECT
    mc.category_name,
    COUNT(*) AS fraud_transactions
FROM merchant_category mc  
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
WHERE t.is_flagged_fraud = 1
GROUP BY mc.category_name
ORDER BY fraud_transactions DESC;

# Which merchant categories have the highest fraud rate?
SELECT
    mc.category_name,
    COUNT(*) AS total_transactions,
    SUM(t.is_flagged_fraud) AS fraud_transactions,
    ROUND(SUM(t.is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate
FROM merchant_category mc
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
GROUP BY mc.category_name
ORDER BY fraud_rate DESC;

# Does merchant risk classification align with actual fraud rates
SELECT
    mc.risk_flag,
    COUNT(*) AS total_transactions,
    SUM(t.is_flagged_fraud) AS fraud_transactions,
    ROUND(SUM(t.is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate
FROM merchant_category mc 
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
GROUP BY mc.risk_flag
ORDER BY fraud_rate DESC;

# Revenue Analysis
# Which merchant categories generate the most fee revenue?
SELECT
    mc.category_name,
    ROUND(SUM(t.fee_charged_gbp), 2) AS fee_revenue
FROM merchant_category mc 
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
GROUP BY mc.category_name
ORDER BY fee_revenue DESC;

# Which sectors generate the most fee revenue?
SELECT
    mc.sector,
    ROUND(SUM(t.fee_charged_gbp), 2) AS fee_revenue
FROM merchant_category mc 
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
GROUP BY mc.sector
ORDER BY fee_revenue DESC;

# Customer Spending Behaviour
# Which merchant categories attract the highest spending?
SELECT
    mc.category_name,
    ROUND(SUM(t.amount_gbp), 2) AS total_spend
FROM merchant_category mc 
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
WHERE t.transaction_status='Completed'
GROUP BY mc.category_name
ORDER BY total_spend DESC;

# Which merchant categories have the highest average per transaction?
SELECT
    mc.category_name,
    ROUND(AVG(t.amount_gbp),2) AS avg_spend
FROM merchant_category mc 
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
WHERE t.transaction_status='Completed'
GROUP BY mc.category_name
ORDER BY avg_spend DESC;

# High-Risk Category Monitoring
# Which high-risk merchant categories generate the most activity?
SELECT
    mc.category_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp),2) AS total_value
FROM merchant_category mc 
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
WHERE mc.risk_flag='High'
GROUP BY mc.category_name
ORDER BY total_value DESC;

# Which high-risk merchant categories have the highest fraud rates?
SELECT
    mc.category_name,
    COUNT(*) AS total_transactions,
    SUM(t.is_flagged_fraud) AS fraud_transactions,
    ROUND(SUM(t.is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate
FROM merchant_category mc 
LEFT JOIN transactions t
    ON t.merchant_category_id = mc.merchant_category_id
WHERE mc.risk_flag='High'
GROUP BY mc.category_name
ORDER BY fraud_rate DESC;