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
