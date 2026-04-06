from fastapi import FastAPI
import pandas as pd

app = FastAPI()

# Load CSV files
sales_by_city = pd.read_csv("output/sales_by_city.csv")
sales_trend = pd.read_csv("output/sales_trend.csv")
top_products = pd.read_csv("output/top_products.csv")

@app.get("/")
def home():
    return {"message": "E-commerce Analytics API is running"}

@app.get("/sales/city")
def get_sales_by_city():
    return sales_by_city.head(10).to_dict(orient="records")

@app.get("/sales/trend")
def get_sales_trend():
    return sales_trend.to_dict(orient="records")

@app.get("/products/top")
def get_top_products():
    return top_products.head(10).to_dict(orient="records")