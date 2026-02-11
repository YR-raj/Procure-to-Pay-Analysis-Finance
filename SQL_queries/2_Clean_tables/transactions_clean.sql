SELECT * FROM finance_dataset.transactions_clean;

-- Issues 
/*
- nulls exist
- inconsistent date formats
- future time exist
- unknown employee_id '999'
- unknown vendor_id '888' 
- amount is 0 but approved or rejected
- negative amounts falls under all approval_status category
- inconsistent names in expense, payment, and approval_status column
*/

-- EXPLORING DATA ISSUES ----------------------------------

/*check null*/
SELECT COUNT(*) 
FROM transactions
WHERE amount = '';
/*the quantity of nulls in amount are more than 20% of data (1271). 
Thus, filling it with median value would be a better step*/

/*check negatives*/
SELECT COUNT(*)
FROM transactions
WHERE amount < 0;
/*negatives are also more than 20% (1307) */

/*check date issues*/
SELECT COUNT(*)
FROM transactions
WHERE transaction_date > CURRENT_DATE;
/*more than 20% of data represents future time*/

/*check duplicates*/
SELECT transaction_id, COUNT(*)
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;
/*2 duplicate rows with future date*/

SELECT *
FROM transactions
WHERE transaction_id = 3199;

/*check missing employee_id & vendor_id*/
SELECT COUNT(*)
FROM transactions
WHERE employee_id = '' OR vendor_id = '';
/*no missing ids in employee and vendor*/

SELECT DISTINCT expense_type
FROM transactions;
-- travel expense/Travel and Meals/meal

/*check employee_id*/
SELECT DISTINCT employee_id
FROM transactions;
-- id 999 is unknown in employee table

/*check employee_id 999*/
SELECT *
FROM transactions
WHERE employee_id = '999';
-- more than 10 rows (0.2% of whole data) with correct data, amount, vendors



-- CLEANING DATA --------------------------------------------

/*Standerdize text*/
UPDATE transactions_clean
SET expense_type = CASE
    WHEN LOWER(expense_type) LIKE 'travel%' THEN 'Travel'
    WHEN LOWER(expense_type) LIKE 'meal%' THEN 'Meals'
    ELSE expense_type
END;

UPDATE transactions_clean
SET payment_method = UPPER(payment_method);

UPDATE transactions_clean
SET approval_status = INITCAP(LOWER(approval_status));


-- Add column for date and amount
ALTER TABLE transactions_clean
ADD COLUMN transaction_date_norm VARCHAR(10),
ADD COLUMN amount_parsed DECIMAL(12,2);

-- Clean Date column
UPDATE transactions_clean
SET transaction_date_norm = 
	CASE
	-- YYYY-MM-DD (already normalized)
	WHEN transaction_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
		THEN transaction_date

	-- DD-MM-YYYY → YYYY-MM-DD
	WHEN transaction_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
		THEN CONCAT(
			SUBSTRING(transaction_date, 7, 4), '-',
			SUBSTRING(transaction_date, 4, 2), '-',
			SUBSTRING(transaction_date, 1, 2)
		)

	-- DD/MM/YYYY → YYYY-MM-DD
	WHEN transaction_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
		THEN CONCAT(
			SUBSTRING(transaction_date, 7, 4), '-',
			SUBSTRING(transaction_date, 4, 2), '-',
			SUBSTRING(transaction_date, 1, 2)
		)

	ELSE NULL
END;

UPDATE transactions_clean
SET transaction_date_norm = NULL
WHERE transaction_date_norm REGEXP '-02-3[0-9]$';

UPDATE transactions_clean
SET transaction_date_norm = STR_TO_DATE(transaction_date_norm, '%Y-%m-%d');

/*New Date Column*/
UPDATE transactions_clean
SET amount_parsed =
	CASE
		WHEN amount REGEXP '^-?[0-9]+(\.[0-9]+)?$'
			THEN CAST(amount AS DECIMAL(12,2))
		ELSE NULL
	END;

-- Adding New date_flag column
ALTER TABLE transactions_clean
ADD COLUMN is_date_valid BOOLEAN DEFAULT 1;

UPDATE transactions_clean
SET is_date_valid = 0
WHERE transaction_date_norm > CURRENT_DATE
	OR transaction_date_norm IS NULL;

-- Adding New employee_flag column
ALTER TABLE transactions_clean
ADD COLUMN is_employee_valid BOOLEAN DEFAULT 1;

UPDATE transactions_clean
SET is_employee_valid = 0
WHERE employee_id NOT IN(
		SELECT employee_id FROM employees_clean WHERE is_valid = 1);

-- Adding New vendor_flag column
ALTER TABLE transactions_clean
ADD COLUMN is_vendor_valid BOOLEAN DEFAULT 1;

UPDATE transactions_clean
SET is_vendor_valid = 0
WHERE vendor_id NOT IN(
		SELECT vendor_id FROM vendors_clean);

-- Adding New amount_flag column
ALTER TABLE transactions_clean
ADD COLUMN is_amount_valid BOOLEAN DEFAULT 1;

UPDATE transactions_clean
SET is_amount_valid = 0
WHERE amount_parsed IS NULL
    OR amount_parsed <= 0;

-- Adding New transaction_flag column
ALTER TABLE transactions_clean
ADD COLUMN is_txn_valid BOOLEAN DEFAULT 1;

UPDATE transactions_clean
SET is_txn_valid = 0
WHERE is_date_valid = 0
	OR is_employee_valid = 0
	OR is_vendor_valid = 0
	OR is_amount_valid = 0;

-- Checking Valid Transaction Count
SELECT COUNT(*)
FROM transactions_clean
WHERE is_txn_valid = 1;


/*Checking magnitude of each field*/
SELECT
  SUM(is_date_valid = 0) AS bad_date,
  SUM(is_amount_valid = 0) AS bad_amount,
  SUM(is_employee_valid = 0) AS bad_employee,
  SUM(is_vendor_valid = 0) AS bad_vendor
FROM transactions_clean;

-- Adding tier Column
ALTER TABLE transactions_clean
ADD COLUMN txn_tier VARCHAR(10);

/*Make tiers for analysis*/
UPDATE transactions_clean
SET txn_tier = 
	CASE
		WHEN is_date_valid = 1
			 AND is_amount_valid = 1
			 AND is_employee_valid = 1
			 AND is_vendor_valid = 1
				THEN 'TIER_1'

		WHEN is_date_valid = 1
			AND is_amount_valid = 1
				THEN 'TIER_2'
				
		ELSE 'TIER_3'
	END;

-- Tier-wise Count
SELECT txn_tier, COUNT(*) AS txn_count
FROM transactions_clean
GROUP BY txn_tier;