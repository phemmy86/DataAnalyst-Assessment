# 3. -------Account Inactivity Alert

SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s ON p.owner_id = s.owner_id
WHERE p.status_id = 1 -- Assuming 1 means active AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
GROUP BY p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
HAVING last_transaction_date IS NULL OR inactivity_days > 365
ORDER BY inactivity_days DESC;


/*
## Question 3

**Approach:**  
1. **Filter active plans** (`status_id = 1`) that are either regular savings or funds.  
2. **LEFT JOIN** to the savings table to capture owners with no transactions.  
3. **Aggregate** by plan, computing each owner’s most recent transaction date.  
4. **Calculate** inactivity in days from today.  
5. **HAVING** clause to keep plans with either no transactions or inactivity > 365 days.  
6. **Order** by longest inactivity first.

**Challenges & Resolutions:**  
- Handling owners with no transactions: used `LEFT JOIN` and `last_transaction_date IS NULL`.  
- Ensuring date diff logic works across months/years: relied on MySQL’s `DATEDIFF` and `CURDATE()`.
