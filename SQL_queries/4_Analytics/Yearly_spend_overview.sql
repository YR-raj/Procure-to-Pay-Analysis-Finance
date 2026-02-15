/*Time based analysis*/
WITH yearly_spend AS(
	SELECT 
		YEAR(transaction_date) AS year,
		SUM(amount) AS total_spend
	FROM valid_transactions
	GROUP BY year
	ORDER BY year
), 

lag_cte AS(
	SELECT 
		*,
		LAG(total_spend) OVER(ORDER BY year) AS previous_amount
	FROM yearly_spend
)

SELECT 
	*,
    ROUND(((total_spend - previous_amount)/previous_amount)*100, 2) AS `YoY%`
FROM lag_cte 
ORDER BY year;

/*BUSINESS IMPLICATION*/
-- The overall spending trend follows a realistic financial cycle:
-- contraction → aggressive expansion → correction → stabilization.

-- Year 2022 shows significant contraction in spending (-27.12%)
-- Possible reasons: cost-cutting measures or reduce procurement

-- Following year 2023 shows high spending spike (+78.81%)
-- suggesting expansion activities such as onboarding new vendors,
-- capital investments, infrastructure upgrades, or enhanced employee programs.

-- Year 2024 and 2025 shows a controlled correction and stable growth,
-- which may indicate normalization after an unusually high spending year, 
-- and improved financial planning
