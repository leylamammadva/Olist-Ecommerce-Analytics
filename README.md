# E-Commerce End-to-End Analytics (Olist)

## Project Overview
This project is an end-to-end data analytics solution using a real-world e-commerce dataset (Olist). The goal is to process raw data, perform customer segmentation, and build an interactive dashboard to drive business decisions.

## Tech Stack & Workflow
* **Phase 1: Data Cleaning & Modeling (SQL)** - Extracting and transforming raw CSV data into a structured format.
* **Phase 2: Customer Segmentation (Python/Pandas)** - Applying RFM (Recency, Frequency, Monetary) analysis to identify key customer groups.
* **Phase 3: Data Visualization (Power BI)** - Creating an interactive dashboard for management.

## Business Scenarios & Analysis Tasks

**Task 1: Data Cleaning and Consolidated View**
* **Business Scenario:** The company receives fragmented data from various departments (Logistics, Sales, Customer Service). Before any advanced analysis can be performed, management requires a single "Source of Truth" table.
* **Objective:** Join Orders, Customers, and Payments tables. Filter for 'delivered' status and valid payment amounts (>0) to ensure reports are based on real transactions.
* **Solution:** `01_data_cleaning_and_join.sql`

**Task 2: Top 10 Cities for Marketing Budget Allocation**
* **Business Scenario:** The Marketing Department is planning a digital ad campaign and needs to avoid blind spending. They want to target the regions that generate the highest revenue.
* **Objective:** Identify the top 10 cities based on total revenue (payment_value) from successfully delivered orders.
* **Solution:** 
