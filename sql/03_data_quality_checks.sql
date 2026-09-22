USE olist_ecommerce;

-- ==========================================
-- 1. DUPLICATE CHECKS
-- ==========================================

-- Duplicate order_reviews (same review_id linked to more than one order)
SELECT review_id, COUNT(*) AS n
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

-- How many review_ids are duplicated in total
SELECT COUNT(*) AS duplicated_review_ids
FROM (
    SELECT review_id
    FROM order_reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) t;

-- Example: look at one duplicated review_id to see why
SELECT * FROM order_reviews
WHERE review_id = '00130cbe1f9d422698c812ed8ded1919';

-- Duplicate orders (should be zero)
SELECT order_id, COUNT(*) AS n
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Duplicate geolocation rows (expected here; this table has many rows per zip)
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng) AS distinct_rows
FROM geolocation;

-- ==========================================
-- 2. NULL CHECKS
-- ==========================================

SELECT
  SUM(order_approved_at IS NULL) AS null_approved,
  SUM(order_delivered_carrier_date IS NULL) AS null_carrier,
  SUM(order_delivered_customer_date IS NULL) AS null_delivered,
  COUNT(*) AS total_orders
FROM orders;

-- ==========================================
-- 3. ORDER STATUS DISTRIBUTION
-- ==========================================

SELECT order_status, COUNT(*) AS n
FROM orders
GROUP BY order_status
ORDER BY n DESC;

-- ==========================================
-- 4. ORPHAN RECORD CHECKS
-- ==========================================

-- Orders with no order_items
SELECT COUNT(*) FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

-- Breakdown of those orphan orders by status
SELECT o.order_status, COUNT(*) AS n
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
GROUP BY o.order_status;

-- order_items with no matching order (should be zero)
SELECT COUNT(*) FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- order_items with no matching product (should be zero)
SELECT COUNT(*) FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- ==========================================
-- 5. IMPOSSIBLE DATE CHECKS
-- ==========================================

-- Delivered before it was purchased (should be zero)
SELECT COUNT(*) FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;

-- Approved before purchased (should be zero)
SELECT COUNT(*) FROM orders
WHERE order_approved_at < order_purchase_timestamp;

-- ==========================================
-- 6. PRODUCT CATEGORY CHECKS
-- ==========================================

-- Products with no category
SELECT COUNT(*) FROM products WHERE product_category_name IS NULL;

-- Categories with no English translation
SELECT DISTINCT p.product_category_name
FROM products p
LEFT JOIN product_category_translation t
  ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;