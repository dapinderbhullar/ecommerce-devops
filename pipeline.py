from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Ecommerce Pipeline").getOrCreate()

print("Pipeline started...")

df = spark.read.csv("dataset_ecommerce/olist_orders_dataset.csv", header=True)

print("Data Loaded")

# Basic transformation
status_count = df.groupBy("order_status").count()

print("Order Status Summary:")
status_count.show()

spark.stop()

print("Pipeline completed")