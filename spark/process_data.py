from pyspark.sql import SparkSession
from pyspark.sql.functions import col, month

# Start Spark
spark = SparkSession.builder \
    .appName("Ecommerce Analytics") \
    .getOrCreate()

print("🚀 Spark Started")

# Load datasets
orders = spark.read.csv("dataset/olist_orders_dataset.csv", header=True, inferSchema=True)

customers = spark.read.csv("dataset/olist_customers_dataset.csv", header=True, inferSchema=True)

order_items = spark.read.csv("dataset/olist_order_items_dataset.csv", header=True, inferSchema=True)

print("✅ Data Loaded")

# Join datasets
df = orders.join(customers, "customer_id") \
           .join(order_items, "order_id")

# Clean data
df = df.dropna().dropDuplicates()
df = df.filter(col("price") > 0)

# Feature engineering
df = df.withColumn("order_month", month("order_purchase_timestamp"))

# Sales by city
sales_by_city = df.groupBy("customer_city") \
    .sum("price") \
    .withColumnRenamed("sum(price)", "total_sales")

# Sales trend
sales_trend = df.groupBy("order_month") \
    .sum("price") \
    .orderBy("order_month")

# Top products
top_products = df.groupBy("product_id") \
    .count() \
    .orderBy("count", ascending=False)

# Save outputs
sales_by_city.toPandas().to_csv("sales_by_city.csv", index=False)
sales_trend.toPandas().to_csv("sales_trend.csv", index=False)
top_products.toPandas().to_csv("top_products.csv", index=False)

print("🔥 Processing Done!")