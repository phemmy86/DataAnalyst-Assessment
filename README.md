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


## Question 3: Account Inactivity Alert

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


## Question 4: Customer Lifetime Value (CLV) Estimation

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

