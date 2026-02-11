/*Time based analysis*/
WITH monthly_spend AS(
	SELECT 
		YEAR(transaction_date) AS year,
		SUM(amount) AS total_spend
	FROM valid_transactions
	GROUP BY year
	ORDER BY year
),

overall_spend AS(
	SELECT valid_amount
	FROM valid_amount_only
)

SELECT 
	t1.year,
    t1.total_spend,
    ROUND((t1.total_spend/t2.valid_amount) * 100, 2) AS distribution_percentage
FROM monthly_spend t1
CROSS JOIN overall_spend t2
ORDER BY t1.year, t1.total_spend;

/*BUSINESS IMPLICATION*/
-- Overall the spend is increasing year-by-year. 
-- A sharp spike can be seen in 2023, suggesting high-activity or new_projects.
-- Following the year, there is a dip 

