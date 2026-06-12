# International Transaction Overview
# How many transactions are international vs domestic?
SELECT
    CASE WHEN tt.is_domestic=1 THEN 'Domestic' ELSE 'International' END AS is_domestic,
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM transactions), 2) AS percentage
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
GROUP BY tt.is_domestic;

# What transaction value comes from domestic vs international activity?
SELECT
    CASE WHEN tt.is_domestic=1 THEN 'Domestic' ELSE 'International' END AS is_domestic,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp),2) AS total_value,
    ROUND(AVG(t.amount_gbp),2) AS avg_transaction_value
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
GROUP BY tt.is_domestic;

# International Transaction Trend
# How does international transaction volume change over time?
SELECT
    DATE_FORMAT(t.transaction_date,'%Y-%m') AS month,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp),2) AS total_value
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0
GROUP BY month
ORDER BY month;

# What share of monthly activity is international?
SELECT
    DATE_FORMAT(t.transaction_date,'%Y-%m') AS month,
    ROUND(SUM(CASE WHEN tt.is_domestic = 0 THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS international_share_pct
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
GROUP BY month
ORDER BY month;

# International Transaction Types
# Which international transaction types are used most?
SELECT
    tt.type_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp), 2) AS total_value
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0
GROUP BY tt.type_name
ORDER BY transaction_count DESC;

# Which international transaction types generate the highest value?
SELECT
    tt.type_name,
    ROUND(SUM(t.amount_gbp), 2) AS total_value,
    ROUND(AVG(t.amount_gbp), 2) AS avg_transaction_value
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0
GROUP BY tt.type_name
ORDER BY total_value DESC;

# International Transaction Performance
# What is the completion rate of international performance
SELECT
    ROUND(SUM(CASE WHEN t.transaction_status='Completed' THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS completion_rate
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0;

# What is the failure rate of international transactions
SELECT
    ROUND(SUM(CASE WHEN t.transaction_status IN ('Declined','Reversed') THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS failure_rate
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0;

# How do statuses distribute within international transactions
SELECT
    transaction_status,
    COUNT(*) AS transaction_count
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0
GROUP BY transaction_status
ORDER BY transaction_count DESC;

# FX Analysis
# What FX rates are being used?
SELECT
    ROUND(MIN(fx_rate_used), 2) AS min_fx_rate,
    ROUND(MAX(fx_rate_used), 2) AS max_fx_rate,
    ROUND(AVG(fx_rate_used), 2) AS avg_fx_rate
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0;

# How do FX rates vary over time?
SELECT
    DATE_FORMAT(transaction_date,'%Y-%m') AS month,
    ROUND(AVG(fx_rate_used), 2) AS avg_fx_rate
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0
GROUP BY month
ORDER BY month;

# Which transaction types experience the highest FX rates?
SELECT
    tt.type_name,
    ROUND(AVG(t.fx_rate_used), 2) AS avg_fx_rate
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0
GROUP BY tt.type_name
ORDER BY avg_fx_rate DESC;

# International Fee Revenue
# How much fee revenue comes from international transactions?
SELECT
    ROUND(SUM(fee_charged_gbp),2) AS international_fee_revenue
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0;

# Which international transaction types generate the most fee revenue?
SELECT
    tt.type_name,
    ROUND(SUM(t.fee_charged_gbp), 2) AS fee_revenue
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE tt.is_domestic = 0
GROUP BY tt.type_name
ORDER BY fee_revenue DESC;

# International Customer Analysis
# Which customers perform the most international transactions?
SELECT
    c.customer_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp), 2) AS total_value
FROM transactions t
RIGHT JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
RIGHT JOIN customer c
    ON t.customer_id = c.customer_id
WHERE tt.is_domestic = 0
GROUP BY c.customer_name
ORDER BY transaction_count DESC;

# Which customers generate the highest international value?
SELECT
    c.customer_name,
    ROUND(SUM(t.amount_gbp),2) AS total_value
FROM transactions t
RIGHT JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
RIGHT JOIN customer c
    ON t.customer_id = c.customer_id
WHERE tt.is_domestic = 0
GROUP BY c.customer_name
ORDER BY total_value DESC;

# International Merchant Analysis
# Which merchant categories receive the most international spending?
SELECT
    mc.category_name,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp),2) AS total_value
FROM transactions t
RIGHT JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
RIGHT JOIN merchant_category mc
    ON t.merchant_category_id = mc.merchant_category_id
WHERE tt.is_domestic = 0
GROUP BY mc.category_name
ORDER BY total_value DESC;

# Which sectors drive international spending?
SELECT
    mc.sector,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp),2) AS total_value
FROM transactions t
RIGHT JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
RIGHT JOIN merchant_category mc
    ON t.merchant_category_id = mc.merchant_category_id
WHERE tt.is_domestic = 0
GROUP BY mc.sector
ORDER BY total_value DESC;