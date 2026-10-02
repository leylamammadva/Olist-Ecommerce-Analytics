# E-Commerce Customer Segmentation & Retention Analysis (Olist)

**[Interactive dashboard](https://leylamammadva.github.io/Olist-Ecommerce-Analytics/)** | Power BI file: `05_RFM_Dashboard.pbix`

End-to-end analytics project on the Olist Brazilian E-Commerce dataset (Kaggle): SQL data preparation, RFM and K-Means customer segmentation, cohort retention, repurchase prediction, and a Power BI dashboard.

## Key findings

- **Revenue is concentrated in one-time buyers.** High-value one-timers are 29.8% of customers but generate 57.5% of revenue.
- **Repeat purchase is extremely rare.** 97.00% of customers ordered once, 2.76% twice and 0.24% three or more times (SQL). Less than 1% order again in the month after their first purchase (cohort analysis).
- **Delivery experience does not explain it.** Adding delivery delay, review score and freight ratio to a repurchase model did not improve prediction (ROC-AUC 0.605 vs 0.602, 5-fold CV).
- **Business implication:** the biggest growth opportunity is converting high-value one-time buyers into repeat buyers, not only acquiring new customers.

## Repository contents

| File | Description |
|---|---|
| `01_data_cleaning_and_join.sql` | Joins orders, customers and payments into one table (delivered orders, payment > 0) |
| `02_top_10_cities_revenue.sql` | Top 10 cities by revenue |
| `03_payment_type_analysis.sql` | Orders and revenue by payment type |
| `04_rfm_customer_segmentation.ipynb` | RFM scoring and 6 customer segments |
| `05_RFM_Dashboard.pbix` | Power BI dashboard (preview: `RFM_Dashboard_Preview.png`) |
| `06_advanced_ml_and_churn.ipynb` | K-Means clustering and cohort retention heatmap |
| `07_churn_prediction_time_based.ipynb` | Baseline repurchase model (RFM features, time-based split) |
| `08_churn_delivery_and_reviews.ipynb` | Adds delivery and review features, 5-fold cross-validation |
| `09_monthly_revenue_growth.sql` | Monthly revenue and month-over-month growth (CTE + LAG), 2017 onward |
| `10_orders_per_customer.sql` | Customers by number of orders (CTE + window function) |

## Analysis

### 1. SQL (files 01-03, 09-10)
- **Source of truth table (01):** delivered orders joined with customers and payments, keeping payments > 0.
- **Top 10 cities by revenue (02):** input for marketing budget allocation.
- **Payment types (03):** number of orders and revenue per payment method, input for commission negotiations. An order paid with several methods is counted once per method.
- **Monthly revenue (09):** revenue grew from 127K (Jan 2017) to 1.15M (Nov 2017) and has stayed around 1.0-1.13M per month since Jan 2018. 2016 is excluded because the platform had only a few orders then.
- **Orders per customer (10):** 97.00% of customers ordered once, 2.76% twice, 0.24% three or more times. This matches the repeat-purchase finding from the Python notebooks.

### 2. RFM segmentation (04)
Recency, Frequency and Monetary values per customer (about 93,000 customers), scored and grouped into six segments (Champions, Loyal, New / Promising, At Risk (High Value), Lost / Low Value, Regular / Average).
About 97% of customers placed one order, so Frequency is scored in three groups (1, 2, 3+ orders) and segments are defined by Recency and Monetary scores.

### 3. Dashboard (05)
KPI cards (total customers, 15.42M total revenue, 165.20 average revenue per customer), a segment slicer, customer distribution (donut) and revenue by segment (column chart). At Risk (High Value) is the second-largest revenue segment, a natural target for win-back offers.

### 4. K-Means clusters and cohorts (06)
Features: Recency, log(Frequency), log(Monetary), standardized. k = 4 chosen with the elbow method and silhouette score.

| Cluster | Customers | Revenue | Profile |
|---|---|---|---|
| Recent low spenders | 38.2% | 16.0% | ~148 days since purchase, avg spend 69 |
| Lapsed one-timers | 28.9% | 20.9% | ~425 days since purchase, avg spend 120 |
| Repeat buyers | 3.0% | 5.6% | 2.1 orders on average, avg spend 309 |
| High-value one-timers | 29.8% | 57.5% | ~174 days since purchase, avg spend 318 |

The cohort retention heatmap shows that less than 1% of customers order again in the month after their first purchase.

### 5. Repurchase prediction (07 and 08)
**Question:** which customers order again within 90 days after 2018-03-01? Features use only orders before the cutoff, so there is no data leakage.

| Notebook | Setup | Result |
|---|---|---|
| 07 | RFM features, single train/test split | 386 of 55,524 customers (0.70%) repurchased. ROC-AUC about 0.61 (Logistic Regression 0.609, Random Forest 0.616) |
| 08 | RFM vs RFM + delivery delay, review score, freight ratio, 5-fold CV | 349 of 52,013 customers (0.67%) repurchased. ROC-AUC 0.602 vs 0.605, PR-AUC 0.026 vs 0.025 |

Notebook 08 rebuilds features from the raw Olist tables (customer count differs slightly from 07) and uses cross-validation, which is more reliable than the single split in 07 because the test set there has only 77 repurchasers.
PR-AUC is about 4x the random baseline (0.007), so there is a weak signal, but delivery and review features add nothing to it.

## Limitations

- Only 349-386 customers repurchased, so model results are noisy and effects are hard to detect.
- Segment names (for example "Loyal Customers") are based on Recency and Monetary, and most customers in them bought once.
- Segment sizes are similar by construction (R and M scores are quintiles).
- The dashboard uses RFM segments, not the K-Means clusters.
- Customer counts differ slightly between notebooks and SQL (for example 93,357 vs 93,358) because of different input preparation.

## How to reproduce

1. Download the Olist Brazilian E-Commerce dataset from Kaggle and load the CSVs into a SQL database (SQLite was used).
2. Run `01_data_cleaning_and_join.sql` and export the result as `rfm_data.csv`.
3. Run notebooks `04` (creates `final_customer_segments.csv`), then `06` and `07`.
4. Notebook `08` reads the raw Olist CSVs (`orders`, `order_items`, `order_reviews`, `customers`).
5. SQL files `09` and `10` use SQLite syntax (`strftime`) and run on the `orders`, `customers` and `order_payments` tables.
6. Install dependencies: `pip install -r requirements.txt`.

The data files are not included in this repository.

## Tech stack

SQL (SQLite), Python (pandas, NumPy, scikit-learn, matplotlib, seaborn), Power BI.


