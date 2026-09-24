# Data Quality Log

## Day 2 - 22 Sep 2026

### Duplicate check
- order_reviews: 789 review_ids appear more than once (out of ~99,224 rows)
  - Example: review_id 00130cbe1f9d422698c812ed8ded1919 linked to 2 different order_ids, with identical score, text, and timestamps
  - Meaning: source-data quirk — the same review got linked to more than one order, not a true duplicate
  - Decision: when joining reviews to orders, don't assume 1 review = 1 order; do not deduplicate review rows
- orders: no duplicate order_id found — each order is unique
- geolocation: 1,000,163 total rows vs 720,154 distinct (zip/lat/lng combination)
  - Meaning: expected — many people share a zip code prefix
  - Decision: no action needed

### Null check (orders table)
- order_approved_at: 160 nulls
- order_delivered_carrier_date: 1,783 nulls
- order_delivered_customer_date: 2,965 nulls
- Meaning: these are orders that are canceled, unavailable, still processing, or shipped but not yet delivered
- Decision: keep as NULL; exclude non-delivered orders from delivery-time metrics

### Order status distribution
| Status | Count |
|---|---|
| delivered | 96,478 |
| shipped | 1,107 |
| canceled | 625 |
| unavailable | 609 |
| invoiced | 314 |
| processing | 5 |
| approved | 2 |
- Meaning: 97% of orders are delivered; the rest never completed
- Decision: use only 'delivered' orders for revenue and delivery-time analysis

### Orphan record check
- Orders with no order_items: 775
- order_items with no matching order: 0
- order_items with no matching product: 0
- Breakdown of the 775 orphan orders by status:
  | Status | Count |
  |---|---|
  | unavailable | 603 |
  | canceled | 164 |
  | created | 5 |
  | invoiced | 2 |
  | shipped | 1 |
- Meaning: 767 of 775 are canceled/unavailable orders that never got items attached (expected). 'created' is a status not seen elsewhere — likely an order started but abandoned before payment.
- Decision: exclude all 775 from revenue/product-level analysis; use only 'delivered' orders

### Impossible date check
- Delivered before purchased: 0
- Approved before purchased: 0
- Decision: no action needed, order dates are consistent

### Product category check
- Products with no category: 610 (out of 32,951)
- 2 categories have no English translation: pc_gamer, portateis_cozinha_e_preparadores_de_alimentos
- Decision: label missing categories as "unknown" in analysis; keep Portuguese names for the 2 untranslated categories, or translate manually later

### Overall cleaning decisions for Day 3+
1. Use only order_status = 'delivered' for revenue, delivery-time, and product analysis
2. Exclude the 775 orders with no order_items from any item/product-level analysis
3. Treat delivery-date nulls as "not yet reached that stage," not missing data
4. Don't assume 1:1 between order_reviews and orders — 789 review_ids link to 2+ orders
5. Handle 610 products with no category as "unknown"
6. Confirm handling of the Sep 2016 and Oct 2018 partial months before building any time trend (from Day 1 findings)

## Business analysis findings (Day 3)
- Confirmed: Sep-Dec 2016 has almost no order data (1, 265, 0, 1 orders) — excluded from trend analysis; real trend starts Jan 2017
- Nov 2017 shows a spike (7,289 orders) — likely Black Friday, worth flagging not excluding
- Late deliveries average 2.57 stars vs 4.29 for on-time — strongest insight in the dataset
- Only 3% of customers are repeat buyers (2,801 / 93,358)
- SP is by far the top state by revenue, consistent with its size/economy
- Seller 7c67e1448b00f6e969d365cea6b010ab has high revenue but a low 3.35 avg review score — flagged for quality review