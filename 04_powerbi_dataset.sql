SELECT
    o.order_id,
    o.order_purchase_timestamp,
    o.order_status,

    c.customer_id,
    c.customer_city,
    c.customer_state,

    oi.product_id,
    p.product_category_name,

    oi.seller_id,
    s.seller_state,

    oi.price,
    oi.freight_value,

    pay.payment_type,
    pay.payment_installments,
    pay.payment_value,

    r.review_score

FROM ecommerce.orders o

LEFT JOIN ecommerce.customers c
ON o.customer_id = c.customer_id

LEFT JOIN ecommerce.order_items oi
ON o.order_id = oi.order_id

LEFT JOIN ecommerce.products p
ON oi.product_id = p.product_id

LEFT JOIN ecommerce.sellers s
ON oi.seller_id = s.seller_id

LEFT JOIN ecommerce.payments pay
ON o.order_id = pay.order_id

LEFT JOIN ecommerce.reviews r
ON o.order_id = r.order_id

LIMIT 10;