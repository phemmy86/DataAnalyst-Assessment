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
