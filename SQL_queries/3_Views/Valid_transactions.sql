/*Create View for Clean_transaction_table*/
CREATE OR REPLACE VIEW valid_transactions AS
SELECT 
    tr.transaction_id,
    tr.transaction_date_norm AS transaction_date,
    em.employee_id,
    d.dept_name,
    v.vendor_id, 
    v.vendor_name,
    v.vendor_category,
    tr.expense_type,
    tr.amount_parsed AS amount,
    tr.payment_method,
    CASE 
        WHEN tr.approval_status = '' THEN 'not_known'
        ELSE tr.approval_status
    END AS approval_status
FROM transactions_clean tr         
LEFT JOIN employees_clean em 
    ON tr.employee_id = em.employee_id
LEFT JOIN departments_clean d 
    ON em.department_id = d.department_id
LEFT JOIN vendors_clean v 
    ON tr.vendor_id = v.vendor_id
WHERE tr.is_txn_valid = 1;
