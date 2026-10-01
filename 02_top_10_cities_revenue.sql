SELECT 
    c.customer_city,
    SUM(p.payment_value) AS total_revenue
FROM olist_customers_dataset c
JOIN olist_orders_dataset o 
    ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p 
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
  AND p.payment_value > 0
GROUP BY c.customer_city
ORDER BY total_revenue DESC
LIMIT 10;