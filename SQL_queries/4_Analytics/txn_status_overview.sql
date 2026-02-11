/*How much money have been blocked?*/
WITH txn_status AS(
	SELECT 
		approval_status,
		COUNT(*) AS txn_cnt,
		SUM(amount) AS total_spend
	FROM valid_transactions
	GROUP BY approval_status
	ORDER BY total_spend DESC
),

amount AS(
	SELECT valid_amount
    FROM valid_amount_only
)

SELECT
	t1.*,
    ROUND((t1.total_spend/t2.valid_amount)*100, 2) AS distribution
FROM txn_status t1
CROSS JOIN amount t2

/*BUSINESS IMPLICATION*/
-- Only 35% of transactions are approved and 65% falls under the rest of the categories, which suggest weak Data Governance and P2P workflow.
-- 


