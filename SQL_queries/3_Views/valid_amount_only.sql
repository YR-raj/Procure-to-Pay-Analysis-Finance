-- Creating Valid_amount View
CREATE VIEW valid_amount_only AS 
SELECT SUM(amount) AS valid_amount
FROM valid_transactions