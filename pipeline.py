import os

print("🚀 Pipeline started...")

# Step 1: Run Spark
os.system("python spark/process_data.py")

print("✅ Spark step completed")

print("🎯 Pipeline finished")