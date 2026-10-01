SELECT 
    oopd.payment_type, 
    COUNT(oopd.order_id) AS total_transactions,
    SUM(oopd.payment_value) AS total_revenue
FROM olist_order_payments_dataset oopd
JOIN olist_orders_dataset ood 
    ON oopd.order_id = ood.order_id
WHERE ood.order_status = 'delivered'
GROUP BY oopd.payment_type
ORDER BY total_revenue DESC;