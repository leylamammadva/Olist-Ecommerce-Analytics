-- Monthly revenue and month-over-month growth for delivered orders.
-- 2016 is excluded: the platform had only a few orders in late 2016 (data gap in Nov), which distorts growth rates.
WITH monthly AS (
    SELECT
        strftime('%Y-%m', o.order_purchase_timestamp) AS month,
        SUM(p.payment_value) AS revenue
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
      AND p.payment_value > 0
      AND o.order_purchase_timestamp >= '2017-01-01'
    GROUP BY 1
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
          / LAG(revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;