from getpass import getpass
from pathlib import Path
from urllib.parse import quote_plus

import pandas as pd
from sqlalchemy import create_engine, text

DB_NAME = "olist_ecommerce"
RAW_DIR = Path(__file__).resolve().parent.parent / "data" / "raw"

# CSV file -> MySQL table
FILES = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_orders_dataset.csv": "orders",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "product_category_translation",
}

# Columns to convert to dates (blank values become NULL)
DATE_COLUMNS = {
    "orders": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
    "order_items": ["shipping_limit_date"],
    "order_reviews": ["review_creation_date", "review_answer_timestamp"],
}

password = quote_plus(getpass("MySQL root password: "))
engine = create_engine(
    f"mysql+pymysql://root:{password}@localhost:3306/{DB_NAME}?charset=utf8mb4"
)

for file_name, table in FILES.items():
    df = pd.read_csv(RAW_DIR / file_name, encoding="utf-8")

    for col in DATE_COLUMNS.get(table, []):
        df[col] = pd.to_datetime(df[col], errors="coerce")

    # Empty the table first so the script can be re-run safely
    with engine.begin() as conn:
        conn.execute(text(f"TRUNCATE TABLE {table}"))

    df.to_sql(table, engine, if_exists="append", index=False, chunksize=5000)
    print(f"{table}: loaded {len(df):,} rows")

print("Done.")