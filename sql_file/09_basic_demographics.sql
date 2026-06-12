# Customer Base Overview
# How many customers does Zephyr Bank have?
SELECT
    COUNT(*) AS total_customers
FROM customer;

# What is the customer distribution by segment?
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM customer), 2) AS percentage
FROM customer
GROUP BY customer_segment
ORDER BY customer_count DESC;

# What is the customer distribution by age band?
SELECT
    age_band,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM customer), 2) AS percentage
FROM customer
GROUP BY age_band
ORDER BY age_band;

# What is the customer distribution by region?
SELECT
    region,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM customer), 2) AS percentage
FROM customer
GROUP BY region
ORDER BY customer_count DESC;

# KYC Analysis
# What percentage of customers are KYC verified?
SELECT
    CASE WHEN kyc_verified=1 THEN 'KYC Verified' ELSE 'Not Verified' END AS kyc_verified,
    COUNT(*) AS customer_count,
    ROUND(SUM(kyc_verified)*100/(SELECT COUNT(*) FROM customer), 2) AS percentage
FROM customer
GROUP BY kyc_verified;

# Which customer segments have the highest KYC completion?
SELECT
    customer_segment,
    COUNT(*) AS customers,
    SUM(kyc_verified) AS verified_customers,
    ROUND(SUM(kyc_verified)*100/COUNT(*), 2) AS verification_rate
FROM customer
GROUP BY customer_segment
ORDER BY verification_rate DESC;

# Which age groups have the highest KYC completion?
SELECT
    age_band,
    COUNT(*) AS customers,
    SUM(kyc_verified) AS verified_customers,
    ROUND(SUM(kyc_verified)*100/COUNT(*), 2) AS verification_rate
FROM customer
GROUP BY age_band
ORDER BY verification_rate DESC;

# Customer Tenure Analysis
# How long have customers been with the bank?
SELECT
    ROUND(AVG(DATEDIFF('2026-05-31', account_open_date))/365, 2) AS avg_customer_tenure_years
FROM customer;

# Which customer segments have the longest tenure?
SELECT
    customer_segment,
    ROUND(AVG(DATEDIFF('2026-05-31', account_open_date))/365, 2) AS avg_tenure_years
FROM customer
GROUP BY customer_segment
ORDER BY avg_tenure_years DESC;

# Which regions contain the longest-tenured customers?
SELECT
    region,
    ROUND(AVG(DATEDIFF('2026-05-31', account_open_date))/365, 2) AS avg_tenure_years
FROM customer
GROUP BY region
ORDER BY avg_tenure_years DESC;

# Transaction Activity by Demographics
# Which age bands generate the most transactions?
SELECT
    c.age_band,
    COUNT(*) AS transaction_count
FROM transactions t
RIGHT JOIN customer c
    ON t.customer_id = c.customer_id
GROUP BY c.age_band
ORDER BY transaction_count DESC;

# Which age bands generate the highest transaction value?
SELECT
    c.age_band,
    ROUND(SUM(t.amount_gbp),2) AS total_value
FROM transactions t
RIGHT JOIN customer c
    ON t.customer_id = c.customer_id
GROUP BY c.age_band
ORDER BY total_value DESC;

# Which regions generate the most transactions?
SELECT
    c.region,
    COUNT(*) AS transaction_count
FROM transactions t
RIGHT JOIN customer c
    ON t.customer_id = c.customer_id
GROUP BY c.region
ORDER BY transaction_count DESC;

# Which regions generate the highest transaction value?
SELECT
    c.region,
    ROUND(SUM(t.amount_gbp), 2) AS total_value
FROM transactions t
RIGHT JOIN customer c
    ON t.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_value DESC;

# Which customer segments generate the most transactions?
SELECT
    c.customer_segment,
    COUNT(*) AS transaction_count
FROM transactions t
RIGHT JOIN customer c
    ON t.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY transaction_count DESC;

# Which customer segments generate the highest transaction value?
SELECT
    c.customer_segment,
    ROUND(SUM(t.amount_gbp), 2) AS total_value
FROM transactions t
RIGHT JOIN customer c
    ON t.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY total_value DESC;

# Customer Profile Matrix
# How are customer segments distributed across age groups?
SELECT
    age_band,
    customer_segment,
    COUNT(*) AS customer_count
FROM customer
GROUP BY age_band, customer_segment
ORDER BY age_band, customer_count DESC;

# How are customer segments distributed across regions?
SELECT
    region,
    customer_segment,
    COUNT(*) AS customer_count
FROM customer
GROUP BY region, customer_segment
ORDER BY region, customer_count DESC;

# Which age groups dominate each region?
SELECT
    region,
    age_band,
    COUNT(*) AS customer_count
FROM customer
GROUP BY region, age_band
ORDER BY customer_count DESC, region;