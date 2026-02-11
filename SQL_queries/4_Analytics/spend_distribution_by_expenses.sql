/*Spend distribution between expenses*/
WITH expense_type_cte AS(
    SELECT 
		expense_type,
		COUNT(*) AS txn_count,
		SUM(amount) AS total_spend
	FROM valid_transactions
	GROUP BY expense_type
	ORDER BY total_spend DESC
),

valid_amount_only  AS(
	SELECT valid_amount
	FROM valid_amount_only
)

SELECT 
	t1.*,
	ROUND((t1.total_spend/t2.valid_amount)*100, 2) AS distribution
FROM expense_type_cte t1
CROSS JOIN valid_amount_only t2


/*BUSINESS IMPLICATION*/
-- Meals are the biggest cost driver with 37.5% of total_spend_distribution, suggesting misclassification issue in dataset as in real companies, meals don't drive this much cost. 
-- Travel is the second biggest driver with only 6% less than meals's. This much distribution is obvious in travelling.
-- As per the IT supplies and Software Subscription, These are a strategic spend area and should be tied to productivity, not just cost.

