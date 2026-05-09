# coffee_shop_Databricks_project

# ☕ Coffee Shop Sales Analytics

> **A comprehensive data engineering and analytics project analyzing 149K+ transactions across 3 NYC locations**

[![Databricks](https://img.shields.io/badge/Databricks-SQL-FF3621?logo=databricks)](https://databricks.com)
[![Status](https://img.shields.io/badge/Status-Complete-success)](#)
[![Data](https://img.shields.io/badge/Records-149K-blue)](#)
[![Revenue](https://img.shields.io/badge/Revenue-$699K-green)](#)

---

## 📊 Project Overview

This project demonstrates end-to-end data engineering and business intelligence capabilities through comprehensive analysis of coffee shop transaction data. The analysis spans **6 months** (January - June 2023) across **3 locations** in New York City, processing **149,116 transactions** totaling **$698,812** in revenue.

### 🎯 Key Objectives

* **Data Engineering**: Build a robust data cleaning and transformation pipeline
* **Quality Assurance**: Implement comprehensive data validation checks
* **Business Intelligence**: Extract actionable insights for operational optimization
* **Performance Analysis**: Identify revenue drivers and growth patterns

---

## 🏗️ Architecture & Data Pipeline

```
┌─────────────────┐
│   Raw Data      │
│  coffee_shop    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Data Quality    │
│ Validation      │
│  • Null checks  │
│  • Duplicates   │
│  • Data types   │
│  • Validation   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Transformation  │
│  • Trim spaces  │
│  • Type casting │
│  • Derive cols  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Clean Table    │
│ coffee_shop_clean│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Analytics     │
│  • KPIs         │
│  • Trends       │
│  • Insights     │
└─────────────────┘
```

---

## 🔧 Data Engineering Process

### 1️⃣ Data Quality Assessment

**Null Value Analysis**
* Checked all 11 columns for null values
* **Result**: Zero nulls found across 149K records ✅

**Duplicate Detection**
* Analyzed `transaction_id` for duplicates using GROUP BY + HAVING
* **Result**: No duplicate transactions found ✅

**Data Type Validation**
* Reviewed schema using `DESC` command
* Identified `transaction_qty` stored as DOUBLE (should be INT)

**Whitespace Detection**
* Found **1,952 records** with leading/trailing spaces in text fields
* Applied `TRIM()` function across 4 columns

**Business Rule Validation**
* Verified `unit_price > 0` and `transaction_qty > 0`
* **Result**: No negative or zero values ✅

### 2️⃣ Data Transformation

Created optimized `coffee_shop_clean` table with:

* **Type Casting**: Converted `transaction_qty` from DOUBLE → INT
* **Derived Column**: Added `total_revenue = transaction_qty × unit_price`
* **Data Cleanup**: Applied TRIM() to all string fields
* **Maintained Integrity**: Preserved all 149,116 records

```sql
CREATE OR REPLACE TABLE coffee_shop_clean AS
SELECT
    transaction_id,
    transaction_date,
    transaction_time,
    CAST(transaction_qty AS INT) AS transaction_qty,
    store_id,
    store_location,
    product_id,
    unit_price,
    product_category,
    product_type,
    product_detail,
    CAST(transaction_qty AS INT) * unit_price AS total_revenue
FROM coffee_shop;
```

---

## 📈 Business Analytics & Insights

### 💰 Executive Summary

| Metric | Value |
|--------|-------|
| **Total Revenue** | $698,812 |
| **Total Transactions** | 149,116 |
| **Total Units Sold** | 214,470 |
| **Average Order Value** | $4.69 |
| **Average Selling Price** | $3.38 |
| **Avg Qty/Transaction** | 1.44 units |

### 🏆 Top Performers

#### Best-Selling Product Types

| Rank | Product Type | Revenue |
|------|-------------|----------|
| 🥇 | Barista Espresso | $91,406 |
| 🥈 | Brewed Chai Tea | $77,082 |
| 🥉 | Hot Chocolate | $72,416 |
| 4 | Gourmet Brewed Coffee | $70,035 |
| 5 | Brewed Black Tea | $47,932 |

#### Top Product Details

| Product | Revenue |
|---------|----------|
| Sustainably Grown Organic Lg | $21,152 |
| Dark Chocolate Lg | $21,006 |
| Latte Rg | $19,112 |
| Cappuccino Lg | $17,642 |
| Morning Sunrise Chai Lg | $17,384 |

### 📍 Location Analysis

#### Revenue by Store

| Location | Revenue | Contribution |
|----------|---------|-------------|
| **Hell's Kitchen** | $236,511 | 33.8% |
| **Astoria** | $232,244 | 33.2% |
| **Lower Manhattan** | $230,057 | 32.9% |

*Remarkably balanced revenue distribution across all three locations*

#### Units Sold by Store

| Location | Units Sold |
|----------|------------|
| Lower Manhattan | 71,742 |
| Hell's Kitchen | 71,737 |
| Astoria | 70,991 |

### ⏰ Time-Based Patterns

#### Peak Hours (Morning Rush)

| Hour | Revenue | % of Daily Revenue |
|------|---------|-------------------|
| **10 AM** | $88,673 | ~12.7% |
| **9 AM** | $85,170 | ~12.2% |
| **8 AM** | $82,700 | ~11.8% |

**💡 Insight**: 8-10 AM generates nearly **25% of daily revenue** in just 2 hours

#### Top Revenue Days

| Date | Revenue | Day Type |
|------|---------|----------|
| June 19, 2023 | $6,404 | Weekday |
| June 13, 2023 | $6,189 | Weekday |
| June 8, 2023 | $6,152 | Weekday |

### 📊 Category Performance

| Category | Revenue | Contribution % | Units Sold |
|----------|---------|-----------------|------------|
| **Coffee** | $269,952 | 38.63% | 89,250 |
| **Tea** | $196,406 | 28.11% | 69,737 |
| **Bakery** | $82,316 | 11.78% | 23,214 |
| **Drinking Chocolate** | $72,416 | 10.36% | 17,457 |
| **Coffee Beans** | $40,085 | 5.74% | 1,828 |
| **Branded** | $13,607 | 1.95% | 776 |
| **Loose Tea** | $11,214 | 1.60% | 1,210 |
| **Flavours** | $8,409 | 1.20% | 10,511 |
| **Packaged Chocolate** | $4,408 | 0.63% | 487 |

---

## 📉 Growth & Trend Analysis

### 📅 Monthly Revenue Trajectory

| Month | Revenue | MoM Growth |
|-------|---------|------------|
| January | $81,678 | - |
| February | $76,145 | **-6.77%** ⚠️ |
| March | $98,835 | **+29.80%** 🚀 |
| April | $118,941 | **+20.34%** 📈 |
| May | $156,728 | **+31.77%** 🚀 |
| June | $166,486 | **+6.23%** 📊 |

**Key Findings**:
* **Revenue doubled** from January ($82K) to June ($166K)
* **Strong recovery** after February dip with exceptional March-May growth (avg 27% MoM)
* **Growth deceleration** in June signals potential market saturation or seasonal normalization

### 📊 Day-to-Day Volatility Analysis

**Volatility Range**: -26.86% to +33.19%

**Notable Patterns**:
* **Month-End Drops**: Consistent declines observed
  * Jan 28: -25.71%
  * Feb 28: -26.86%
  * Jun 28: -20.86%
  * *Hypothesis*: Weekend closures or reduced operations

* **Month-Start Surges**: Strong recovery patterns
  * May 1: +33.19%
  * Mar 1: +31.55%
  * Apr 1: +28.11%
  * *Hypothesis*: Customer re-engagement after month-end lulls

---

## 🎯 Strategic Recommendations

### 🔥 High-Priority Actions

1. **Optimize Morning Operations (8-10 AM)**
   * Increase staffing during peak hours
   * Ensure adequate inventory for Coffee category (39% of revenue)
   * Focus on Barista Espresso preparation efficiency

2. **Investigate June Growth Deceleration**
   * Analyze competitive landscape
   * Review seasonal demand patterns
   * Consider promotional campaigns to maintain momentum

3. **Leverage Month-Start Momentum**
   * Launch monthly promotions on 1st-3rd of each month
   * Capitalize on natural customer re-engagement patterns

4. **Address Month-End Patterns**
   * Investigate operational constraints causing drops
   * Consider extended hours or special offers during weekends

### 💡 Product Strategy

* **Double down on Coffee**: 38.63% revenue contribution—maintain quality and variety
* **Expand Tea offerings**: Strong 28.11% contribution with growth potential
* **Promote high-margin items**: Focus on Barista Espresso ($91K) and specialty drinks

### 📍 Location Strategy

* **Balanced performance** across all 3 locations suggests consistent operations
* Share best practices across stores
* Consider location-specific promotions to drive differentiation

---

## 🛠️ Technical Stack

* **Platform**: Databricks SQL
* **Compute**: Serverless SQL Warehouse (2X-Small, Photon-enabled)
* **Language**: SQL (Databricks SQL dialect)
* **Catalog**: Unity Catalog (`saswat.pintu`)
* **Tables**: 
  * `coffee_shop` (raw data)
  * `coffee_shop_clean` (transformed data)

---

## 📁 Project Structure

```
.
├── README.md                          # This file
├── coffee_shop.dbquery.ipynb         # Main SQL analysis notebook
├── data/
│   ├── coffee_shop                   # Raw table (149K records)
│   └── coffee_shop_clean            # Cleaned table (149K records)
└── analysis/
    ├── data_quality_checks.sql      # Validation queries
    ├── transformations.sql          # Cleaning & transformation logic
    ├── kpi_analysis.sql            # Business metrics
    └── trend_analysis.sql          # Growth & pattern analysis
```

---

## 🚀 How to Use

### Prerequisites
* Databricks workspace with SQL access
* Unity Catalog enabled
* Serverless SQL warehouse (or cluster with Photon)

### Setup

1. **Import Data**
   ```sql
   -- Load your data into: saswat.pintu.coffee_shop
   ```

2. **Run Data Quality Checks**
   * Execute statements 1-24 for validation

3. **Create Clean Table**
   * Run statement 25 to generate `coffee_shop_clean`

4. **Generate Analytics**
   * Execute statements 26-39 for full analysis

### Quick Start Query

```sql
USE CATALOG saswat;
USE SCHEMA pintu;

-- Get executive summary
SELECT
    ROUND(SUM(total_revenue),2) AS total_revenue,
    COUNT(transaction_id) AS total_transactions,
    ROUND(AVG(total_revenue),2) AS avg_order_value
FROM coffee_shop_clean;
```

---

## 📝 Analysis Methodology

### Data Quality Framework

1. **Completeness**: Null value checks across all fields
2. **Uniqueness**: Duplicate detection on transaction IDs
3. **Validity**: Range checks for prices and quantities
4. **Consistency**: Data type verification and standardization
5. **Accuracy**: Whitespace cleanup and format validation

### Analytical Approach

1. **Descriptive Analytics**: KPIs and summary statistics
2. **Diagnostic Analytics**: Category, location, and time-based segmentation
3. **Trend Analysis**: MoM growth, day-to-day volatility
4. **Comparative Analysis**: Product, category, and location benchmarking

---

## 🎓 Key Learnings

### Data Engineering
* ✅ Importance of thorough data quality assessment
* ✅ Value of derived columns for analysis efficiency
* ✅ Impact of data type optimization on query performance

### Business Intelligence
* ✅ Morning hours are critical revenue drivers
* ✅ Month-end patterns suggest operational opportunities
* ✅ Product mix heavily favors coffee and tea categories
* ✅ Location performance is remarkably balanced

### SQL Techniques Used
* Common Table Expressions (CTEs)
* Window Functions (`LAG`, `OVER`)
* Aggregations and grouping
* Date/time manipulation (`HOUR`, `DATE_FORMAT`, `MONTH`)
* Conditional logic and filtering
* Type casting and transformations

---

## 📊 Visualizations

*For visual dashboards and charts, see the Databricks workspace or connect this data to your BI tool of choice (Tableau, Power BI, Looker, etc.)*

**Recommended Charts**:
* 📈 Line chart: Monthly revenue trend
* 📊 Bar chart: Revenue by category
* ⏰ Heatmap: Hourly sales patterns
* 🗺️ Map: Location performance
* 🥧 Pie chart: Category contribution

---

## 🔮 Future Enhancements

* [ ] Customer segmentation analysis
* [ ] Predictive modeling for demand forecasting
* [ ] Seasonal decomposition of time series
* [ ] Cohort analysis for customer retention
* [ ] A/B testing framework for promotions
* [ ] Real-time dashboard with streaming data
* [ ] Machine learning for dynamic pricing
* [ ] Integration with inventory management systems

---

## 👤 Author

**Saswat Betta Aptakam**
* 📧 Email: saswatbetta.aptakam@gmail.com
* 🔗 GitHub: [Your GitHub Profile]
* 💼 LinkedIn: [Your LinkedIn Profile]

---

## 📄 License

This project is available for educational and portfolio purposes.

---

## 🙏 Acknowledgments

* Databricks for providing robust SQL analytics capabilities
* Unity Catalog for seamless data governance
* The data engineering and analytics community for best practices

---

## 📞 Contact

For questions, suggestions, or collaboration opportunities:
* 📧 saswatbetta.aptakam@gmail.com
* 💬 Open an issue in this repository

---

<div align="center">



*Built with ❤️ using Databricks SQL*

</div>
