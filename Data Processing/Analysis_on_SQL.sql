-- 1. Checking the Cleaned Dataset

SELECT *
FROM municipal_revenue_clean
LIMIT 20;

-- Checking the number of records 
SELECT
    COUNT(*) AS total_records
FROM municipal_revenue_clean

-- Summary of the key financial fields
SELECT
    SUM(billing_amount) AS total_billed,
    SUM(payment_amount) AS total_collected,
    SUM(outstanding_balance) AS total_outstanding,
    AVG(billing_amount) AS avg_bill_amount,
    AVG(payment_amount) AS avg_payment_amount
FROM municipal_revenue_clean;

-- 2. Revenue by Municipality
-- Which municipalities generate the most revenue and have the largest outstanding balances?
SELECT
    municipality,
    SUM(billing_amount) AS total_billed,
    SUM(payment_amount) AS total_collected,
    SUM(outstanding_balance) AS total_outstanding
FROM municipal_revenue_clean
GROUP BY municipality
ORDER BY total_billed DESC;

-- Municipality_C generates the most revenue and has the largest outstanding balances

-- 3. Collection rate
SELECT
    municipality,
    SUM(billing_amount) AS total_billed,
    SUM(payment_amount) AS total_collected,
    ROUND(
        SUM(payment_amount) / NULLIF(SUM(billing_amount), 0) * 100,
        2
    ) AS collection_rate
FROM municipal_revenue_clean
GROUP BY municipality
ORDER BY collection_rate DESC;

-- Municipality_G has the highest collection rate

-- 4. Payment Status
SELECT
    payment_status,
    COUNT(*) AS number_of_accounts,
    SUM(billing_amount) AS total_billed,
    SUM(payment_amount) AS total_collected,
    SUM(outstanding_balance) AS total_outstanding
FROM municipal_revenue_clean
GROUP BY payment_status
ORDER BY total_outstanding DESC;

-- 5. Revenue by service
SELECT
    service_type,
    SUM(billing_amount) AS total_billed,
    SUM(payment_amount) AS total_collected,
    SUM(outstanding_balance) AS total_outstanding
FROM municipal_revenue_clean
GROUP BY service_type
ORDER BY total_billed DESC;

-- Electricity service generates the highest revenue 

-- 6. Monthly Revenue Trend
SELECT
    DATE_FORMAT(billing_date, 'MMMM') AS month,
    SUM(billing_amount) AS total_billed,
    SUM(payment_amount) AS total_collected,
    SUM(outstanding_balance) AS total_outstanding
FROM municipal_revenue_clean
GROUP BY DATE_FORMAT(billing_date, 'MMMM'), MONTH(billing_date)
ORDER BY total_billed;

-- 7. Top debtors
SELECT
    municipality,
    customer_type,
    SUM(outstanding_balance) AS total_outstanding,
    SUM(billing_amount) AS total_billed,
    SUM(payment_amount) AS total_paid
FROM municipal_revenue_clean
GROUP BY
    municipality,
    customer_type
ORDER BY total_outstanding DESC
LIMIT 20;

-- Municipality_D has the highest total outstanding balance

-- 8. Overdue Accounts
SELECT
    municipality,
    COUNT(*) AS overdue_accounts,
    SUM(outstanding_balance) AS overdue_balance,
    AVG(days_overdue) AS avg_days_overdue
FROM municipal_revenue_clean
WHERE days_overdue > 0
GROUP BY municipality
ORDER BY overdue_balance DESC;

-- Municipality_C has the highest overdue balance

-- 9. Customer segment analysis
SELECT
    customer_type,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(billing_amount) AS total_billed,
    SUM(payment_amount) AS total_collected,
    SUM(outstanding_balance) AS total_outstanding
FROM municipal_revenue_clean
GROUP BY customer_type
ORDER BY total_outstanding DESC;

-- Residential customers have the highest outstanding balance

-- 10. High-risk accounts
-- Identifying accounts that have both a significant balance and long overdue periods:
SELECT
    customer_id,
    municipality,
    customer_type,
    SUM(outstanding_balance) AS total_outstanding,
    MAX(days_overdue) AS max_days_overdue
FROM municipal_revenue_clean
GROUP BY
    customer_id,
    municipality,
    customer_type
HAVING
    SUM(outstanding_balance) > 5000
    AND MAX(days_overdue) > 90
ORDER BY total_outstanding DESC;

-- A Business account from Municipality_B has the highest total outstanding balance and days overdue




