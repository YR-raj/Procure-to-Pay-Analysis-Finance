DESCRIBE budgets;

SELECT * 
FROM budgets
LIMIT 10;
/* No such dept id 99 */

/*Create Duplicate Table*/
CREATE TABLE budgets_clean
LIKE budgets;

/*checking new table*/
SELECT *
FROM budgets_clean;

/*Inserting original data from budget table*/
INSERT budgets_clean
SELECT *
FROM budgets;

