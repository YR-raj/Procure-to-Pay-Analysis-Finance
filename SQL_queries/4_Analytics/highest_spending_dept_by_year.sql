/*department based analysis*/
WITH dept_info AS(
	SELECT 
		dept_name,
		YEAR(transaction_date) AS year,
		SUM(amount) AS total_spend
	FROM valid_transactions
	GROUP BY dept_name, year
),

amount AS (
    SELECT 
        YEAR(transaction_date) AS year,
        SUM(amount) AS valid_amount
    FROM valid_transactions
    GROUP BY YEAR(transaction_date)
),

dept_spend_overview  AS(
	SELECT 
		t1.dept_name,
		t1.year,
		t1.total_spend,
		ROUND((t1.total_spend/t2.valid_amount) * 100, 2) AS distribution_percentage,
        ROW_NUMBER() OVER(PARTITION BY `year` ORDER BY total_spend) AS rn
	FROM dept_info t1
	LEFT JOIN amount t2
		ON t1.year = t2.year
	ORDER BY t1.year, t1.total_spend
)

SELECT 
	year,
	dept_name,
	total_spend,
	distribution_percentage
FROM dept_spend_overview
WHERE rn = 4;


/*BUSINESS IMPLICATION*/
-- HR seem to be the highest spending department in early years with almost 28-30% of total spending is done by them.
-- For HR dept, a big part of budget may go into hiring, training or employee benefits.
-- Finance dept becomes dominant in recent years with distribution remains the same as HR
-- Possible drivers for finance dept could be Higher audit/compliance costs, Financial software subscriptions, or Consulting or external vendors
-- No single department is disproportionately large; spending is relatively balanced across functions.


