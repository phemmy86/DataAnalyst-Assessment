# 4. ----Customer Lifetime Value (CLV) Estimation

SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND((COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1)) * 12 * 
         (SUM(s.confirmed_amount)/100 * 0.001), 2) AS estimated_clv
FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE s.transaction_status = 'success' AND s.confirmed_amount > 0
GROUP BY u.id, u.first_name, u.last_name, u.date_joined
HAVING tenure_months > 0
ORDER BY estimated_clv DESC;


/*

## Question 5: Customer Lifetime Value (CLV) Estimation

**Approach:**  
1. Calculate each user’s tenure in months using `TIMESTAMPDIFF` between `date_joined` and today.  
2. Count only successful, positive-amount savings transactions.  
3. Compute monthly transaction rate: `total_transactions / tenure_months`.  
4. Annualize it (`* 12`) and multiply by average transaction value (in thousands: `confirmed_amount/100 * 0.001`).  
5. Round the final CLV to two decimals.  
6. Exclude users with zero tenure and order by highest CLV.

**Challenges & Resolutions:**  
- Avoid division by zero by using `GREATEST(...,1)`.  
- Ensuring currency and units conversion (cents to thousands) is explicit and correct.
