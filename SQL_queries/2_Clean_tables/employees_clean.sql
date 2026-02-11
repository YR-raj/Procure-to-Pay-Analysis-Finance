SELECT * FROM finance_dataset.employees_clean;

/*ISSUES*/
-- unknown dept_id '99'
-- null approval_limit

/*Confirm data issues*/
SELECT *
FROM employees_clean ec
LEFT JOIN departments_clean dc
	ON ec.department_id = dc.department_id
WHERE dc.department_id IS NULL;

/*Create New column*/
ALTER TABLE employees_clean
ADD COLUMN is_valid BOOLEAN DEFAULT 1;

/*Flag the issue*/
UPDATE employees_clean
SET is_valid = 0 
WHERE department_id NOT IN (
	SELECT department_id
    FROM departments_clean);
    
/*actual clean table where is_valid = 1*/
SELECT *
FROM employees_clean
WHERE is_valid = 1;





