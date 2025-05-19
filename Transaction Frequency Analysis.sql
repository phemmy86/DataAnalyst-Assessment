#2.------ Transaction Frequency Analysis

WITH monthly_transactions AS (
    SELECT s.owner_id,
        COUNT(*) AS transaction_count,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS months_active
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success'
    GROUP BY s.owner_id
),
frequency_metrics AS (
    SELECT 
        owner_id,
        transaction_count,
        months_active,
        transaction_count/months_active AS transactions_per_month,
        CASE 
            WHEN transaction_count/months_active >= 10 THEN 'High Frequency'
            WHEN transaction_count/months_active >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM monthly_transactions
    WHERE months_active > 0
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(transactions_per_month), 1) AS avg_transactions_per_month
FROM frequency_metrics
GROUP BY frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
    
    
/*    
# DataAnalytics-Assessment

## Question 2: Transaction Frequency Analysis

**Approach:**  
1. **CTE `monthly_transactions`:**  
   - Count successful transactions per customer.  
   - Calculate months active by taking the difference between first and last transaction month + 1.  
2. **CTE `frequency_metrics`:**  
   - Compute transactions per month (`transaction_count / months_active`).  
   - Categorize into High (≥10), Medium (≥3), Low (<3) frequency.  
3. **Final SELECT:**  
   - Group by frequency category, count customers, and average transactions/month (rounded to one decimal).  
   - Use a custom `ORDER BY` to preserve High→Medium→Low order.

**Challenges & Resolutions:**  
- **Division precision:** cast to decimal (`*1.0`) to avoid integer division.  
- **Ordering categories:** used a `CASE` in `ORDER BY` to enforce logical ordering.  
