-- ===========================================
-- Executive KPI Queries
-- ===========================================

-- 1. Total Revenue
SELECT
    ROUND(SUM(payment_value)::numeric,2) AS total_revenue
FROM ecommerce.payments;

-- 2. Total Orders
SELECT
    COUNT(*) AS total_orders
FROM ecommerce.orders;

-- 3. Total Customers
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM ecommerce.customers;

-- 4. Average Order Value
SELECT
    ROUND(AVG(payment_value)::numeric,2) AS average_order_value
FROM ecommerce.payments;

-- ===========================================
-- Sales Analysis
-- ===========================================

-- Monthly Revenue
SELECT
    TO_CHAR(
        DATE_TRUNC('month',o.order_purchase_timestamp),
        'YYYY-MM'
    ) AS month,
    ROUND(SUM(p.payment_value)::numeric,2) AS revenue
FROM ecommerce.orders o
JOIN ecommerce.payments p
ON o.order_id=p.order_id
GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
ORDER BY DATE_TRUNC('month',o.order_purchase_timestamp);

-- Revenue by Category
SELECT
    p.product_category_name,
    ROUND(SUM(oi.price)::numeric,2) AS revenue
FROM ecommerce.order_items oi
JOIN ecommerce.products p
ON oi.product_id=p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

-- Top 10 Sellers
SELECT
    seller_id,
    ROUND(SUM(price)::numeric,2) AS revenue
FROM ecommerce.order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;

-- ===========================================
-- Customer Analysis
-- ===========================================

-- Revenue by State
SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value)::numeric,2) AS revenue
FROM ecommerce.orders o
JOIN ecommerce.customers c
ON o.customer_id=c.customer_id
JOIN ecommerce.payments p
ON o.order_id=p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- ===========================================
-- Payment Analysis
-- ===========================================

SELECT
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value)::numeric,2) AS revenue
FROM ecommerce.payments
GROUP BY payment_type
ORDER BY revenue DESC;

-- Customer Spending Category

SELECT
    order_id,
    payment_value,
    CASE
        WHEN payment_value < 100 THEN 'Low'
        WHEN payment_value BETWEEN 100 AND 500 THEN 'Medium'
        ELSE 'High'
    END AS spending_category
FROM ecommerce.payments;

SELECT
    payment_type,
    ROUND(SUM(payment_value)::numeric,2) AS revenue
FROM ecommerce.payments
GROUP BY payment_type
HAVING SUM(payment_value) > 1000000
ORDER BY revenue DESC;

SELECT
    order_id,
    payment_value
FROM ecommerce.payments
WHERE payment_value >
(
    SELECT AVG(payment_value)
    FROM ecommerce.payments
);

SELECT
    seller_id,
    ROUND(SUM(price)::numeric,2) AS revenue,
    RANK() OVER(
        ORDER BY SUM(price) DESC
    ) AS seller_rank
FROM ecommerce.order_items
GROUP BY seller_id;

SELECT
    seller_id,
    ROUND(SUM(price)::numeric,2) AS revenue,
    ROW_NUMBER() OVER(
        ORDER BY SUM(price) DESC
    ) AS row_num
FROM ecommerce.order_items
GROUP BY seller_id;

SELECT
    seller_id,
    ROUND(SUM(price)::numeric,2) AS revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(price) DESC
    ) AS dense_rank
FROM ecommerce.order_items
GROUP BY seller_id;
