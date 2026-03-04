# 🏗️ Modern Data Warehouse & Analytics Pipeline

> **Production-style data warehouse** built on SQL Server using Medallion Architecture — ingesting ERP and CRM sales data through a fully documented ETL pipeline into a Star Schema optimized for fast, scalable analytical queries.

---

## 📌 Project Overview

Most analytics projects start with clean data. Real businesses don't have that luxury — they have messy ERP exports, fragmented CRM records, and no single source of truth. This project simulates exactly that environment and solves it the right way: with a structured, layered data warehouse that separates raw ingestion from clean transformation from business-ready reporting.

The result is a warehouse that any analyst, BI tool, or stakeholder can query directly — without needing to understand the mess underneath.

---

## 🎯 Business Objectives

The warehouse is designed to answer three core business questions:

- **Customer Behaviour** — Who are our best customers? How do they segment by purchase patterns and lifetime value?
- **Product Performance** — Which products drive revenue? Which underperform across regions or time periods?
- **Sales Trends** — How is the business trending week-over-week, month-over-month, and seasonally?

---

## 🏛️ Architecture — Medallion Layers

The warehouse follows the **Medallion Architecture** pattern with three distinct layers:

```
┌─────────────────────────────────────────────────────┐
│                    GOLD LAYER                        │
│     Star Schema — Fact & Dimension Tables            │
│     Optimized for BI queries and reporting           │
├─────────────────────────────────────────────────────┤
│                   SILVER LAYER                       │
│     Cleansed, standardized, integrated data          │
│     Business rules applied, duplicates removed       │
├─────────────────────────────────────────────────────┤
│                   BRONZE LAYER                       │
│     Raw ingestion from ERP and CRM source CSVs       │
│     No transformations — exact source replica        │
└─────────────────────────────────────────────────────┘
```

| Layer | Purpose | Key Operations |
|---|---|---|
| **Bronze** | Raw landing zone | Ingest CSV source files as-is from ERP & CRM |
| **Silver** | Cleansed & integrated | Dedup, null handling, type casting, source joins |
| **Gold** | Analytics-ready | Star Schema with fact and dimension tables |

---

## 🔬 Methodology

### 1. 📥 Data Ingestion (Bronze Layer)
- Loaded raw ERP data (sales transactions, products, regions) and CRM data (customer profiles, accounts) from CSV source files into SQL Server staging tables
- No transformations applied — Bronze preserves exact source fidelity for auditability and reprocessing

### 2. 🧹 Data Cleansing & Integration (Silver Layer)
- Resolved data quality issues: nulls, duplicates, inconsistent date formats, mismatched customer IDs across ERP and CRM
- Applied business rules to standardize fields (e.g., product categories, region codes, currency normalization)
- Joined ERP and CRM sources into a unified, integrated customer-product-sales view

### 3. 🌟 Data Modeling (Gold Layer — Star Schema)
Designed a **Star Schema** optimized for analytical query performance:

```
                    ┌──────────────┐
                    │  dim_date    │
                    └──────┬───────┘
                           │
┌──────────────┐    ┌──────┴───────┐    ┌──────────────────┐
│ dim_customer │────│  fact_sales  │────│   dim_product    │
└──────────────┘    └──────┬───────┘    └──────────────────┘
                           │
                    ┌──────┴───────┐
                    │  dim_region  │
                    └──────────────┘
```

| Table | Type | Description |
|---|---|---|
| `fact_sales` | Fact | Core transaction records with revenue, quantity, and foreign keys |
| `dim_customer` | Dimension | Customer profiles from CRM with segmentation attributes |
| `dim_product` | Dimension | Product catalog with category and pricing info |
| `dim_date` | Dimension | Date spine with week, month, quarter, year attributes |
| `dim_region` | Dimension | Store/region hierarchy for geographic analysis |

### 4. 📊 Analytics & Reporting (SQL Queries)
Built SQL-based analytical reports across three domains:

- **Customer Analytics** — RFM-style segmentation, top customer ranking, churn indicators
- **Product Analytics** — Revenue by category, top/bottom performers, YoY product trends
- **Sales Analytics** — Weekly/monthly trend analysis, seasonal patterns, regional breakdowns

---

## 📁 Repository Structure

```
├── datasets/       # Source CSV files (ERP and CRM raw data)
├── docs/           # Data model diagrams and architecture documentation
├── scripts/        # T-SQL scripts: Bronze → Silver → Gold ETL + analytics queries
├── tests/          # Data quality validation tests
├── LICENSE
└── README.md
```

---

## 🛠️ Tech Stack

| Category | Tools |
|---|---|
| Database | Microsoft SQL Server |
| Language | T-SQL |
| Architecture | Medallion (Bronze / Silver / Gold) |
| Data Modeling | Star Schema (Fact + Dimension Tables) |
| ETL | Stored procedures and SQL scripts |
| Source Systems | ERP (CSV), CRM (CSV) |

---

## 💡 Key Takeaways

- **Medallion Architecture isn't just an enterprise buzzword** — separating raw ingestion from cleansing from reporting makes the pipeline auditable, debuggable, and extensible without breaking downstream queries
- **Star Schema outperforms normalized 3NF for analytics** — fewer joins, faster aggregation, and BI-tool friendly structure; the tradeoff in storage is worth it at analytical query scale
- **Data quality fixes belong in Silver, not Gold** — pushing cleansing logic into the Gold layer creates fragile, hard-to-maintain reporting queries; keeping it in Silver means Gold tables are always trustworthy
- **Tests folder matters** — validation scripts catch data quality regressions early, especially when source CSVs change format between refreshes

---

## 👤 Author

**Salman Khan Shafi**
MS Business Analytics — Duke Fuqua '26
[LinkedIn](https://linkedin.com/in/salmankhanshafi) • [GitHub](https://github.com/salmanshafi9898)
