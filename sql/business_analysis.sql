SELECT
    ROUND(SUM(payment_value)::numeric,2) AS total_revenue
FROM ecommerce.payments;

SELECT COUNT(*) AS total_orders
FROM ecommerce.orders;

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM ecommerce.customers;

SELECT
    ROUND(AVG(payment_value)::numeric,2) AS average_order_value
FROM ecommerce.payments;

SELECT
    TO_CHAR(DATE_TRUNC('month', o.order_purchase_timestamp),'YYYY-MM') AS month,
    ROUND(SUM(p.payment_value)::numeric,2) AS revenue
FROM ecommerce.orders o
JOIN ecommerce.payments p
ON o.order_id = p.order_id
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp);

SELECT
    TO_CHAR(DATE_TRUNC('month', order_purchase_timestamp),'YYYY-MM') AS month,
    COUNT(*) AS total_orders
FROM ecommerce.orders
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY DATE_TRUNC('month', order_purchase_timestamp);

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price)::numeric,2) AS revenue
FROM ecommerce.order_items oi
JOIN ecommerce.products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

SELECT
    seller_id,
    ROUND(SUM(price)::numeric,2) AS revenue
FROM ecommerce.order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;

SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value)::numeric,2) AS revenue
FROM ecommerce.orders o
JOIN ecommerce.customers c
ON o.customer_id = c.customer_id
JOIN ecommerce.payments p
ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

SELECT
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value)::numeric,2) AS revenue
FROM ecommerce.payments
GROUP BY payment_type
ORDER BY revenue DESC;
