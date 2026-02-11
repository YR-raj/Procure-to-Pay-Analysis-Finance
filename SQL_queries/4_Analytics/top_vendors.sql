/*Who is our top vendors?*/
WITH vendor_info AS(
	SELECT
		t1.vendor_id,
		t1.vendor_name,
        t1.vendor_category,
		COUNT(*) AS txn_count,
		SUM(amount) AS total_spend
	FROM vendors_clean t1
	LEFT JOIN valid_transactions t2
		ON t1.vendor_id = t2.vendor_id
	GROUP BY t1.vendor_id, t1.vendor_name, t1.vendor_category
	ORDER BY total_spend DESC
), 
amount AS(
	SELECT valid_amount
    FROM valid_amount_only
)

SELECT
	t1.*,
    ROUND((t1.total_spend/t2.valid_amount)*100, 2) AS distribution
FROM vendor_info t1
CROSS JOIN amount t2

/*BUSINESS IMPLICATION*/
-- very high vendor concentration risk (Dell alone has 42% of total spending), suggesting either diversifying or onbaording new vendors.
 


