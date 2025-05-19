#1. --------High-Value Customers with Multiple Products
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    SUM(s.confirmed_amount)/100 AS total_deposits
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
JOIN plans_plan p ON u.id = p.owner_id
WHERE p.is_a_fund = 1 AND s.confirmed_amount > 0
GROUP BY u.id, u.first_name, u.last_name
HAVING COUNT(DISTINCT s.id) >= 1 AND COUNT(DISTINCT p.id) >= 1
ORDER BY  investment_count asc;

/*
# DataAnalytics-Assessment
## Question 1: High-Value Customers with Multiple Products

**Approach:**  
- Joined `users_customuser` to both `savings_savingsaccount` and `plans_plan` on `owner_id`.  
- Filtered only confirmed savings (`confirmed_amount > 0`) and actual funds (`is_a_fund = 1`).  
- Used `COUNT(DISTINCT ...)` to get per user counts of savings and investment accounts.  
- Summed `confirmed_amount` (which is in cents) and divided by 100 to convert to currency.  

**Challenges & Resolutions:**  
- **Multiple joins causing duplication:** solved by using `DISTINCT` inside `COUNT`.  
- **Amount stored in cents:** applied a `/100` conversion so total shows in standard units.
/*