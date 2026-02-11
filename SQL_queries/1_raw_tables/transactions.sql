DESCRIBE transactions;

SELECT *
FROM transactions
LIMIT 20;

CREATE TABLE transactions_clean LIKE transactions;

INSERT INTO transactions_clean
SELECT *
FROM transactions
