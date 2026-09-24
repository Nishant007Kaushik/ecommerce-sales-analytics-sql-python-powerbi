USE olist_ecommerce;

-- ==========================================
-- Q1: Revenue and order volume trend over time
-- ==========================================
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- ==========================================
-- Q2: Top categories and states by revenue
-- ==========================================

-- Top product categories by revenue
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;

-- Top states by revenue
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY revenue DESC
LIMIT 10;

-- ==========================================
-- Q3: Delivery delay vs review score
-- ==========================================
SELECT
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
        ELSE 'On time'
    END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS n
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;

-- ==========================================
-- Q4: Repeat vs one-time customers
-- ==========================================
SELECT
    CASE WHEN order_count > 1 THEN 'Repeat' ELSE 'One-time' END AS customer_type,
    COUNT(*) AS customers
FROM (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) t
GROUP BY customer_type;

-- ==========================================
-- Q5: Best sellers by revenue (min 10 orders)
-- ==========================================
SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING orders >= 10
ORDER BY revenue DESC
LIMIT 10;

-- ==========================================
-- Q6: Payment method usage
-- ==========================================
SELECT
    payment_type,
    COUNT(*) AS n,
    ROUND(SUM(payment_value), 2) AS total_value
FROM order_payments
GROUP BY payment_type
ORDER BY n DESC;