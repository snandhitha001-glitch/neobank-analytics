# Check TABLE Structures
DESCRIBE customer;
DESCRIBE transaction_type;
DESCRIBE merchant_category;
DESCRIBE transactions;

# Since the tables were imported by default method we'll convert to the right datatypes
# Verify current values before altering
# customer tble
SELECT DISTINCT kyc_verified
FROM customer;

UPDATE customer
SET kyc_verified = 
	CASE
		WHEN kyc_verified = 'True' THEN 1
        WHEN kyc_verified = 'False' THEN 0
	END;

SELECT account_open_date
FROM customer
LIMIT 5;

UPDATE customer
SET account_open_date = STR_TO_DATE(account_open_date, '%Y-%m-%d');

ALTER TABLE customer
MODIFY COLUMN customer_id INT,
MODIFY COLUMN kyc_verified TINYINT(1),
MODIFY COLUMN account_open_date DATE;

DESCRIBE customer;

# transaction_type table
SELECT DISTINCT is_domestic
FROM transaction_type;

UPDATE transaction_type
SET is_domestic = 
	CASE
		WHEN is_domestic = 'True' THEN 1
        WHEN is_domestic = 'False' THEN 0
	END;

ALTER TABLE transaction_type
MODIFY COLUMN transaction_type_id INT,
MODIFY COLUMN is_domestic TINYINT(1),
MODIFY COLUMN typical_fee_gbp DECIMAL(10,2);

# merchant category table
ALTER TABLE merchant_category
MODIFY COLUMN merchant_category_id INT;

# transactions table
SELECT DISTINCT is_flagged_fraud
FROM transactions;

UPDATE transactions
SET is_flagged_fraud = 
	CASE
		WHEN is_flagged_fraud = 'True' THEN 1
        ELSE 0
	END;

SELECT
    transaction_date,
    transaction_datetime
FROM transactions
LIMIT 10;

SELECT DISTINCT fx_rate_used
FROM transactions
ORDER BY fx_rate_used;

# Since fx_rate_used is used as TEXT
SELECT COUNT(*)
FROM transactions
WHERE fx_rate_used = '';

SELECT *
FROM transactions
WHERE fx_rate_used NOT REGEXP '^[0-9.]+$'
AND fx_rate_used IS NOT NULL;

SELECT DISTINCT(device_type) FROM transactions;

SELECT DISTINCT
    device_type,
    LENGTH(device_type) AS len
FROM transactions;

UPDATE transactions
SET device_type =
    CASE
        WHEN device_type IS NULL
             OR device_type = ''
        THEN 'Automated/ATM'
        ELSE device_type
    END;

ALTER TABLE transactions
MODIFY COLUMN transaction_id INT,
MODIFY COLUMN customer_id INT,
MODIFY COLUMN transaction_type_id INT,
MODIFY COLUMN merchant_category_id INT,
MODIFY COLUMN transaction_date DATE,
MODIFY COLUMN transaction_datetime DATETIME,
MODIFY COLUMN amount_gbp DECIMAL(12,2),
MODIFY COLUMN fee_charged_gbp DECIMAL(10,2),
MODIFY COLUMN is_flagged_fraud TINYINT(1),
MODIFY COLUMN fx_rate_used DECIMAL(8,2);