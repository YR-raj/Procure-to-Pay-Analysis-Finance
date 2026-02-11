/*Employee-level spend behavior*/
SELECT 
	em.employee_id,
    em.employee_name,
    em.role,
    SUM(amount) AS total_spend,
    ROUND(AVG(amount), 2) AS avg_spend
FROM employees_clean em
LEFT JOIN valid_transactions vt
	ON em.employee_id = vt.employee_id
WHERE em.is_valid = 1
GROUP BY em.employee_id, em.employee_name, em.role
ORDER BY total_spend DESC;