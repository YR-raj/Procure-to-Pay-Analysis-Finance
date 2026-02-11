SELECT * FROM finance_dataset.budgets_clean;

/*Cleaning Budget table*/
SELECT bt.department_id, dt.department_id
FROM budgets_clean bt
LEFT JOIN departments_clean dt
	ON bt.department_id = dt.department_id 
WHERE dt.department_id IS NULL;


/*flagging invalid dept_id 99*/
ALTER TABLE budgets_clean
ADD COLUMN is_valid BOOLEAN DEFAULT 1;

UPDATE budgets_clean
SET is_valid = 0
WHERE department_id NOT IN 
	(SELECT department_id FROM departments_clean);




