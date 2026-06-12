# Row count check
SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM transaction_type;
SELECT COUNT(*) FROM merchant_category;
SELECT COUNT(*) FROM transactions;

# Foreign Key Validation
SELECT COUNT(*)
FROM transactions t
LEFT JOIN customer c
ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*)
FROM transactions t
LEFT JOIN transaction_type tt
ON t.transaction_type_id = tt.transaction_type_id
WHERE tt.transaction_type_id IS NULL;

SELECT COUNT(*)
FROM transactions t
LEFT JOIN merchant_category mc
ON t.merchant_category_id = mc.merchant_category_id
WHERE mc.merchant_category_id IS NULL;

# Create Analysis View
CREATE VIEW vw_transactions AS
SELECT
    t.transaction_id,
    t.transaction_date,
    t.transaction_datetime,
    t.amount_gbp,
    t.fee_charged_gbp,
    t.transaction_status,
    t.is_flagged_fraud,
    t.fx_rate_used,
    t.device_type,
    t.failed_reason,

    c.customer_id,
    c.customer_name,
    c.age_band,
    c.region,
    c.customer_segment,
    c.kyc_verified,
    c.account_open_date,

    tt.type_name,
    tt.channel,
    tt.is_domestic,
    tt.typical_fee_gbp,

    mc.category_name,
    mc.sector,
    mc.risk_flag

FROM transactions t
JOIN customer c
    ON t.customer_id = c.customer_id
JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
JOIN merchant_category mc
    ON t.merchant_category_id = mc.merchant_category_id;
    
# Verify the view
SELECT *
FROM vw_transactions
LIMIT 5;