-- How many customers ordered once, twice, 3+ times (delivered orders).
-- Result: 97.00% of customers ordered once, 2.76% twice, 0.24% three or more times.
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE WHEN orders >= 3 THEN '3+' ELSE CAST(orders AS TEXT) END AS orders_placed,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM customer_orders
GROUP BY 1
ORDER BY 1;
