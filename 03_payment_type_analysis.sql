-- Orders and revenue by payment type for delivered orders (input for commission negotiations).
-- An order paid with several methods is counted once per method.
SELECT
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS total_orders,
    SUM(p.payment_value)       AS total_revenue
FROM olist_order_payments_dataset p
JOIN olist_orders_dataset o
    ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND p.payment_value > 0
GROUP BY p.payment_type
ORDER BY total_revenue DESC;
