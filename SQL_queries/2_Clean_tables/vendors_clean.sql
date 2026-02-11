CREATE TABLE vendors_clean AS
SELECT 
	MIN(vendor_id) AS vendor_id,
    Standardized_name AS vendor_name,
    vendor_category, 
    country
FROM(
	SELECT 
		vendor_id,
		CASE 
			WHEN LOWER(vendor_name) LIKE 'ama%' THEN 'Amazon Pvt Ltd'
			WHEN LOWER(vendor_name) LIKE 'del%' THEN 'Dell Inc'
			WHEN LOWER(vendor_name) LIKE 'flip%' THEN 'Flipkart Pvt Ltd'
			ELSE vendor_name 
		END AS Standardized_name,
		vendor_category,
		UPPER(country) AS country
	FROM vendors
) t
GROUP BY Standardized_name, vendor_category, country