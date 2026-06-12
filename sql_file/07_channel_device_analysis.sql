# Channel Usage Analysis
# Which channels are used most frequently?
SELECT 
	tt.channel,
    COUNT(*) AS transaction_count
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.channel
ORDER BY transaction_count DESC;

# Which channels generate the highest transaction value?
SELECT
    tt.channel,
    COUNT(*) AS transaction_count,
    ROUND(SUM(t.amount_gbp),2) AS total_value,
    ROUND(AVG(t.amount_gbp),2) AS avg_transaction_value
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.channel
ORDER BY total_value DESC;

# What share of transactions does each channel represent?
SELECT
    tt.channel,
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM transactions), 2) AS percentage
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.channel
ORDER BY percentage DESC;

# Channel Operational Performance
# Which channels have the highest completion rate?
SELECT
    tt.channel,
    ROUND(SUM(CASE WHEN t.transaction_status='Completed' THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS completion_rate
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.channel
ORDER BY completion_rate DESC;

# Which channels have the highest failure rate?
SELECT
    tt.channel,
    ROUND(SUM(CASE WHEN t.transaction_status IN ('Declined','Reversed') THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS failure_rate
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.channel
ORDER BY failure_rate DESC;

# How does transaction status vary by channel?
SELECT
    tt.channel,
    t.transaction_status,
    COUNT(*) AS transaction_count
FROM transaction_type tt
LEFT JOIN transactions t
	ON tt.transaction_type_id=t.transaction_type_id
GROUP BY tt.channel, t.transaction_status
ORDER BY tt.channel;

# Device Operational Performance
# Which devices have the highest completion rates?
SELECT
    device_type,
    ROUND(SUM(CASE WHEN transaction_status='Completed' THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS completion_rate
FROM transactions 
WHERE device_type IS NOT NULL
GROUP BY device_type
ORDER BY completion_rate DESC;

# Which devices have the highest failure rate?
SELECT
    device_type,
    ROUND(SUM(CASE WHEN transaction_status IN ('Declined','Reversed') THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS failure_rate
FROM transactions 
WHERE device_type IS NOT NULL
GROUP BY device_type
ORDER BY failure_rate DESC;

# How does transaction status vary across devices?
SELECT
    device_type,
    transaction_status,
    COUNT(*) AS transaction_count
FROM transactions
WHERE device_type IS NOT NULL
GROUP BY device_type, transaction_status
ORDER BY device_type;

# Channel vs Device Analysis
# Which devices are most commonly used within each channel?
SELECT
    tt.channel,
    t.device_type,
    COUNT(*) AS transaction_count
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE t.device_type IS NOT NULL
GROUP BY tt.channel, t.device_type
ORDER BY tt.channel, transaction_count DESC;

# Which channel-device combinations drive the highest transaction value?
SELECT
    tt.channel,
    t.device_type,
    ROUND(SUM(t.amount_gbp), 2) AS total_value
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE t.device_type IS NOT NULL
GROUP BY tt.channel, t.device_type
ORDER BY total_value DESC;

# Which channel-device combinations have the highest fraud rates?
SELECT
    tt.channel,
    t.device_type,
    COUNT(*) AS total_transactions,
    SUM(t.is_flagged_fraud) AS fraud_transactions,
    ROUND(SUM(t.is_flagged_fraud)*100/COUNT(*), 2) AS fraud_rate
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
WHERE t.device_type IS NOT NULL
GROUP BY tt.channel, t.device_type
ORDER BY fraud_rate DESC;

# Revenue Analysis
# Which channels generate the most fee revenue?
SELECT
    tt.channel,
    ROUND(SUM(t.fee_charged_gbp), 2) AS fee_revenue
FROM transaction_type tt 
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
GROUP BY tt.channel
ORDER BY fee_revenue DESC;

# Which devices generate the most fee revenue?
SELECT
    device_type,
    ROUND(SUM(fee_charged_gbp), 2) AS fee_revenue
FROM transactions
WHERE device_type IS NOT NULL
GROUP BY device_type
ORDER BY fee_revenue DESC;