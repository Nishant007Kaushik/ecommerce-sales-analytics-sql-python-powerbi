USE olist_ecommerce;

-- 1. Row count for every table
SELECT 'customers' AS tbl, COUNT(*) AS n FROM customers
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;

-- 2. Order date range
SELECT MIN(order_purchase_timestamp), MAX(order_purchase_timestamp) FROM orders;

-- 3. Orders per month (shows the partial months at the start and end)
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
       COUNT(*) AS orders
FROM orders
GROUP BY month
ORDER BY month;

-- 4. Customers row count (double-check)
SELECT COUNT(*) FROM customers;