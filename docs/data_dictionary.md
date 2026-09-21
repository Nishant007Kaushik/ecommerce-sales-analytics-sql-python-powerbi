# Data Dictionary

Database: `olist_ecommerce` (MySQL). Source: Olist Brazilian E-Commerce Public Dataset (Kaggle).

## customers
| Column | Description |
|---|---|
| customer_id | Key used to link a customer to an order (a new ID is created for each order) |
| customer_unique_id | Identifies the actual person; use this to find repeat buyers |
| customer_zip_code_prefix | First digits of the customer's zip code |
| customer_city | Customer city |
| customer_state | Customer state (2-letter code) |

## orders
| Column | Description |
|---|---|
| order_id | Unique order identifier |
| customer_id | Links to customers |
| order_status | Order stage (delivered, shipped, canceled, etc.) |
| order_purchase_timestamp | When the customer placed the order |
| order_approved_at | When payment was approved |
| order_delivered_carrier_date | When the order was handed to the carrier |
| order_delivered_customer_date | When the customer received the order |
| order_estimated_delivery_date | Delivery date promised to the customer |

## order_items
| Column | Description |
|---|---|
| order_id | Links to orders |
| order_item_id | Item number within the order (1, 2, 3...) |
| product_id | Links to products |
| seller_id | Links to sellers |
| shipping_limit_date | Deadline for the seller to hand the item to the carrier |
| price | Item price |
| freight_value | Shipping cost for the item |

## order_payments
| Column | Description |
|---|---|
| order_id | Links to orders |
| payment_sequential | Sequence number when an order is paid with more than one method |
| payment_type | Payment method (credit card, boleto, voucher, etc.) |
| payment_installments | Number of installments chosen |
| payment_value | Amount paid |

## order_reviews
| Column | Description |
|---|---|
| review_id | Review identifier |
| order_id | Links to orders |
| review_score | Rating from 1 to 5 |
| review_comment_title | Optional review title |
| review_comment_message | Optional review text |
| review_creation_date | When the satisfaction survey was sent |
| review_answer_timestamp | When the customer answered |

## products
| Column | Description |
|---|---|
| product_id | Unique product identifier |
| product_category_name | Category name (in Portuguese) |
| product_name_lenght | Number of characters in the product name (spelled "lenght" in the source data) |
| product_description_lenght | Number of characters in the description (same spelling) |
| product_photos_qty | Number of product photos |
| product_weight_g | Weight in grams |
| product_length_cm / product_height_cm / product_width_cm | Package dimensions in cm |

## sellers
| Column | Description |
|---|---|
| seller_id | Unique seller identifier |
| seller_zip_code_prefix | First digits of the seller's zip code |
| seller_city | Seller city |
| seller_state | Seller state |

## geolocation
| Column | Description |
|---|---|
| geolocation_zip_code_prefix | Zip code prefix (many rows per prefix) |
| geolocation_lat / geolocation_lng | Latitude and longitude |
| geolocation_city / geolocation_state | City and state |

## product_category_translation
| Column | Description |
|---|---|
| product_category_name | Category name in Portuguese |
| product_category_name_english | Category name in English |

## How the tables connect
- customers.customer_id → orders.customer_id
- orders.order_id → order_items, order_payments, order_reviews
- order_items.product_id → products.product_id
- order_items.seller_id → sellers.seller_id
- products.product_category_name → product_category_translation.product_category_name