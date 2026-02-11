-- Creating View to reduce repeatable work
CREATE VIEW total_amount_only  AS 
SELECT 
	SUM(amount) AS total_amount 
FROM transactions_clean
WHERE is_amount_valid = 1;