# Project Log

## Day 1 - 21 Sep 2026

**Done**
- Created GitHub repo, folder structure, project brief, and README
- Created MySQL database `olist_ecommerce` with 9 tables
- Loaded all 9 CSV files into MySQL using a Python script

**Row counts**

| Table | Rows |
|---|---|
| customers | |
| geolocation | |
| orders | |
| order_items | |
| order_payments | |
| order_reviews | |
| products | |
| sellers | |
| product_category_translation | |

**Findings**
- Order date range: 4 Sep 2016 to 17 Oct 2018 (approx. 2 years)
- Sep 2016: only 4 orders. Oct 2018: only 4 orders. Both are partial months.

**Decisions**
- Use Jan 2017 to Aug 2018 for trend analysis (to be confirmed on Day 2)
- Why: Sep-Dec 2016 and Sep-Oct 2018 have very few orders, so including them would distort the trends

**Issues / Questions**
- (add anything unclear here)

**Next**
- Data quality checks and cleaning (nulls, duplicates, inconsistent formats)