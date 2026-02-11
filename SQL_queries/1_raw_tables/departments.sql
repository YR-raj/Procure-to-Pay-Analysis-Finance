DESCRIBE departments;

SELECT * 
FROM departments
LIMIT 10;
/*Inconsistent dept_name*/

/*Create Duplicate clean Table*/
CREATE TABLE departments_clean AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cost_center_code) AS department_id,
    CASE
        WHEN cost_center_code = 'CC100' THEN 'Finance'
        WHEN cost_center_code = 'CC101' THEN 'Fin.'
        WHEN cost_center_code = 'CC200' THEN 'Human Resources'
        WHEN cost_center_code = 'CC300' THEN 'IT'
        ELSE 'Unknown'
    END AS dept_name,
    cost_center_code
FROM departments
GROUP BY cost_center_code;



