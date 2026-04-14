library(dplyr)
library(readr)
library(ggplot2)
library(scales)

print("🚀 R Analysis Started")

# Create output folder safely
if (!dir.exists("output")) {
  dir.create("output")
}

# ================================
# LOAD DATA
# ================================
sales_city <- read_csv("output/sales_by_city.csv")
sales_trend <- read_csv("output/sales_trend.csv")
top_products <- read_csv("output/top_products.csv")

# DEBUG (REMOVE LATER)
print(colnames(sales_city))
print(colnames(sales_trend))
print(colnames(top_products))

# ================================
# CLEAN COLUMN NAMES (VERY IMPORTANT)
# ================================
names(sales_trend)[2] <- "total_sales"
names(sales_trend)[1] <- "month"

# ================================
# GLOBAL THEME (MODERN BLUE STYLE)
# ================================
theme_set(
  theme_minimal(base_size = 15) +
    theme(
      plot.title = element_text(size = 20, face = "bold"),
      axis.text = element_text(color = "black"),
      panel.grid.major = element_line(color = "#EAEAEA"),
      panel.grid.minor = element_blank()
    )
)

# ================================
# 1. TOP CITIES
# ================================
top_cities <- sales_city %>%
  arrange(desc(total_sales)) %>%
  head(10)

p1 <- ggplot(top_cities,
             aes(x = reorder(customer_city, total_sales),
                 y = total_sales)) +
  geom_col(fill = "#1976D2", width = 0.7) +
  coord_flip() +
  labs(title = "Top Cities by Sales",
       x = "City",
       y = "Total Sales")

ggsave("output/top_cities_plot.png", p1, width = 9, height = 5)

# ================================
# 2. SALES TREND (FIXED)
# ================================
sales_trend$month <- as.numeric(sales_trend$month)

p2 <- ggplot(sales_trend,
             aes(x = month, y = total_sales)) +
  geom_line(color = "#0D47A1", linewidth = 1.5) +
  geom_point(color = "#42A5F5", size = 3) +
  labs(title = "Sales Trend Over Time",
       x = "Month",
       y = "Sales")

ggsave("output/sales_trend_plot.png", p2, width = 9, height = 5)

# ================================
# 3. TOP PRODUCTS
# ================================
top_products_clean <- top_products %>%
  arrange(desc(count)) %>%
  head(10)

p3 <- ggplot(top_products_clean,
             aes(x = reorder(product_id, count),
                 y = count)) +
  geom_col(fill = "#1565C0", width = 0.7) +
  coord_flip() +
  labs(title = "Top Products",
       x = "Product",
       y = "Sales Count")

ggsave("output/top_products_plot.png", p3, width = 9, height = 5)

# ================================
# 4. NEW: GROWTH %
# ================================
sales_trend <- sales_trend %>%
  arrange(month) %>%
  mutate(growth = (total_sales / lag(total_sales) - 1) * 100)

p4 <- ggplot(sales_trend,
             aes(x = month, y = growth)) +
  geom_line(color = "#2E7D32", linewidth = 1.5) +
  geom_point(color = "#66BB6A", size = 3) +
  labs(title = "Monthly Growth %",
       x = "Month",
       y = "Growth %")

ggsave("output/growth_plot.png", p4, width = 9, height = 5)

# ================================
# 5. NEW: DISTRIBUTION
# ================================
p5 <- ggplot(sales_city, aes(x = total_sales)) +
  geom_histogram(fill = "#1E88E5", bins = 30, alpha = 0.9) +
  labs(title = "Sales Distribution",
       x = "Sales",
       y = "Frequency")

ggsave("output/distribution_plot.png", p5, width = 9, height = 5)

print("✅ All plots generated successfully")