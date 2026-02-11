/*How much money is actually analyzable?*/
WITH valid_txn_spend AS(
	SELECT
		COUNT(*) AS valid_txn_count,
		SUM(amount) AS total_valid_spend,
		ROUND(AVG(amount), 2) AS avg_txn_value
	FROM valid_transactions
),

valid_amount_only  AS(
	SELECT Total_amount
	FROM total_amount_only
)

SELECT 
	t1.valid_txn_count,
    t1.total_valid_spend,
    t1.avg_txn_value,
    ROUND((t1.total_valid_spend/t2.Total_amount)*100, 2) AS distribution
FROM valid_txn_spend t1
CROSS JOIN total_amount_only t2


/*BUSINESS IMPLICATION*/
-- Only 16% of our spend data is clean enough for decision-making — our data governance is severely broken.
