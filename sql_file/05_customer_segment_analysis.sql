# Customer Base Distribution
# How are customers distributed across segments
SELECT 
	customer_segment,
    COUNT(*) AS customer_count
FROM customer
GROUP BY customer_segment
ORDER BY customer_count DESC;

# How are customers distributed by age band?
SELECT 
	age_band,
    COUNT(*) AS customer_count
FROM customer
GROUP BY age_band
ORDER BY customer_count DESC;

# How are customers distibuted geographically?
SELECT
	region,
    COUNT(*) AS customer_count
FROM customer
GROUP BY region
ORDER BY customer_count DESC;

# Customer Activity
# Which customers transact the most?
SELECT 
	c.customer_name,
    COUNT(*) AS transaction_count
FROM customer c
LEFT JOIN transactions t
	ON c.customer_id=t.customer_id
GROUP BY c.customer_name
ORDER BY transaction_count DESC;

# Which customers generate the highest transaction value?
SELECT 
	c.customer_name,
    ROUND(SUM(t.amount_gbp), 2) AS transaction_value
FROM customer c
LEFT JOIN transactions t
	ON c.customer_id=t.customer_id
GROUP BY c.customer_name
ORDER BY transaction_value DESC;

# Segment Performance
# Which customer segments generate the most transactions?
SELECT 
	c.customer_segment,
    COUNT(*) AS transaction_count
FROM customer c
LEFT JOIN transactions t
	ON c.customer_id=t.customer_id
GROUP BY c.customer_segment
ORDER BY transaction_count DESC;

# Which customer segments generate the highest transaction value?
SELECT
    c.customer_segment,
    ROUND(SUM(t.amount_gbp),2) AS total_value
FROM customer c
LEFT JOIN transactions t
    ON t.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY total_value DESC;

# What is the average transaction value by segment?
SELECT
    c.customer_segment,
    ROUND(AVG(t.amount_gbp),2) AS avg_transaction_value
FROM customer c
LEFT JOIN transactions t
    ON t.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY avg_transaction_value DESC;

# Segment Operational Performance
# Which segments have the highest success rate?
SELECT
    c.customer_segment,
    ROUND(
        SUM(CASE WHEN t.transaction_status='Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS success_rate
FROM customer c
LEFT JOIN transactions t
    ON t.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY success_rate DESC;

# Which segments have the highest failure rates?
SELECT
    c.customer_segment,
    ROUND(
        SUM(CASE WHEN t.transaction_status IN ('Declined','Reversed') THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2) AS failure_rate
FROM customer c 
LEFT JOIN transactions t
    ON t.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY failure_rate DESC;

# What is the average fee paid per customer segment?
SELECT
    c.customer_segment,
    ROUND(AVG(t.fee_charged_gbp),2) AS avg_fee
FROM customer c
LEFT JOIN transactions t
    ON t.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY avg_fee DESC;

# KYC Analysis
# Do KYC verified customers transact more?
SELECT
	CASE 
		WHEN c.kyc_verified=1 THEN "KYC verified"
        WHEN c.kyc_verified=0 THEN "KYC not verified"
	END AS kyc_verified,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(SUM(t.amount_gbp), 2) AS total_value
FROM customer c
LEFT JOIN transactions t
	ON c.customer_id=t.customer_id
GROUP BY c.kyc_verified;

# Are non-KYC customers associated with higher fraud rates?
SELECT
    CASE 
		WHEN c.kyc_verified=1 THEN "KYC verified"
        WHEN c.kyc_verified=0 THEN "KYC not verified"
	END AS kyc_verified,
    COUNT(*) AS total_transactions,
    SUM(t.is_flagged_fraud) AS fraud_transactions,
    ROUND(
        SUM(t.is_flagged_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM customer c
LEFT JOIN transactions t
    ON t.customer_id = c.customer_id
GROUP BY c.kyc_verified
ORDER BY fraud_rate DESC;

# Customer Lifecycle
# Which account cohorts generate the most activity?
SELECT 
	YEAR(account_open_date) AS cohort_year,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(t.transaction_id) AS transactions
FROM customer c
LEFT JOIN transactions t
	ON c.customer_id=t.customer_id
GROUP BY cohort_year
ORDER BY cohort_year;

# Do older customers transact more than fewer customers?
SELECT
    YEAR(account_open_date) AS cohort_year,
    ROUND(AVG(t.amount_gbp),2) AS avg_transaction_value
FROM customer c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY cohort_year
ORDER BY cohort_year;