# Sales Performance Analysis | SQL & Power BI

## Project Overview

I built this project to strengthen my SQL and Power BI skills by analyzing a sales dataset from start to finish. I began by validating the data, explored sales performance using SQL, and created an interactive Power BI dashboard to answer business questions and present the results in a clear and meaningful way.

---

## Business Objective

The goal of this project was to analyze a sales dataset using SQL and Power BI to better understand sales performance and present the findings through an interactive dashboard. The analysis focuses on identifying trends, evaluating performance, and answering business questions that can support sales and operational decisions.

---

## Dataset

The project uses a synthetic sales dataset containing transactional sales records. Each row represents a single sales transaction and includes information about products, customers, pricing, discounts, sales representatives, and regions.

---

### Data Source
- **Source:** Kaggle
- **Dataset:** `sales_data.csv`
- **Purpose:** Educational and portfolio project

---

### Data Dictionary

| Column | Description |
|--------|-------------|
| **Product_ID** | Unique identifier for each product |
| **Sale_Date** | Date when the sales transaction occurred |
| **Sales_Rep** | Sales representative responsible for the sale |
| **Region** | Sales region (North, South, East, or West) |
| **Sales_Amount** | Total revenue generated from the transaction |
| **Quantity_Sold** | Number of units sold in the transaction |
| **Product_Category** | Product category (Electronics, Furniture, Clothing, or Food) |
| **Unit_Cost** | Cost per unit of the product |
| **Unit_Price** | Selling price per unit |
| **Customer_Type** | Indicates whether the customer is New or Returning |
| **Discount** | Discount applied to the transaction |
| **Payment_Method** | Payment method used by the customer |
| **Sales_Channel** | Sales channel (Online or Retail) |
| **Region_and_Sales_Rep** | Combined Region and Sales Representative field used for analysis |

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| Microsoft SQL Server | Stored and managed the sales dataset |
| SQL Server Management Studio (SSMS) | Wrote and executed SQL queries |
| SQL | Data validation, exploratory data analysis, and business analysis |
| Microsoft Excel | Reviewed the dataset before importing into SQL Server |
| Microsoft Power BI | Built interactive dashboards and data visualizations |
| Git & GitHub | Version control and project documentation |

---

## Project Structure

```text
Sales-Performance-Analysis/
│
├── dataset/                 # Sales dataset (.csv)
├── sql/                     # SQL scripts
├── powerbi/                 # Power BI report (.pbix) and dashboard images
└── README.md

---

## Project Workflow

### Phase 1: Data Understanding
- Imported the sales dataset into Microsoft SQL Server.
- Explored the dataset structure.
- Verified column names, data types, and total records.
- Confirmed the imported data matched the source dataset.

### Phase 2: Data Validation
- Checked for missing values and duplicate records.
- Validated numeric, categorical, and date fields.
- Verified business rules (pricing, discounts, and sales values).
- Reviewed the dataset before analysis.

### Phase 3: Exploratory Data Analysis (EDA)
- Analyzed overall sales performance.
- Evaluated product, regional, customer, and sales representative performance.
- Explored monthly sales trends.
- Answered key business questions using SQL.

### Phase 4: Business Analysis
- Calculated key performance indicators (KPIs).
- Identified top and bottom performing products, regions, and sales representatives.
- Analyzed customer types, sales channels, payment methods, pricing, and discounts.
- Generated insights to support business decisions.

### Phase 5: Power BI Dashboard
- Built an interactive sales performance dashboard.
- Created DAX measures for key KPIs.
- Designed a star schema using a dedicated Date table.
- Added slicers, drill-down, and drill-through functionality.
- Developed an executive dashboard and a region-level analysis dashboard.

### Phase 6: Business Insights & Recommendations
- Summarized key findings.
- Provided data-driven recommendations to support business decision-making.

---

## Dashboard & Reporting

The SQL analysis is complemented with an interactive Power BI dashboard designed for business stakeholders.

The dashboard includes:

- Executive Sales Overview
- Sales Performance KPIs
- Regional Sales Analysis
- Product Performance
- Sales Representative Performance
- Customer Analysis
- Pricing & Discount Analysis
- Sales Trends

---

## Key Skills Demonstrated

### Business & Analytical Skills

- Data Understanding
- Data Quality Assessment
- Business Rule Validation
- Exploratory Data Analysis (EDA)
- KPI Development
- Business Insight Generation
- Data-Driven Decision Making

### SQL Skills

- Data Cleaning
- Data Validation
- Filtering & Sorting
- Aggregations & Grouping
- JOIN Operations
- Common Table Expressions (CTEs)
- Window Functions
- Subqueries

---

## Business Questions Answered

This project answers key business questions that support sales performance analysis and strategic decision-making, including:

- What is the overall sales performance of the business?
- Which product categories generate the highest sales revenue?
- Which regions generate the highest and lowest sales revenue?
- Which sales representatives consistently achieve the highest sales performance?
- How do new and returning customers contribute to total sales revenue?
- How do monthly sales trends change over time?
- Which sales channels generate the highest sales revenue?
- Which payment methods are most preferred by customers?
- How do product prices and discounts vary across product categories?
- Which products generate the highest and lowest sales revenue?
- Which products and sales representatives perform above the company average?
- Which regions generate the highest average order value?
- Which product categories contribute the largest share of total sales revenue?
- How does cumulative sales revenue grow over time?
- How does month-over-month sales performance change?
- Who is the top-performing sales representative within each region?
- Which are the top three products within each product category?
- What business insights can support better sales and business decisions?

---

## Business Value

This analysis demonstrates how raw sales data can be transformed into actionable business insights that support strategic decision-making.

The findings from this project help business stakeholders:

- Monitor overall sales performance.
- Identify high-performing and underperforming products.
- Compare sales performance across regions and sales representatives.
- Evaluate pricing and discount strategies.
- Understand customer purchasing behavior.
- Support data-driven sales and marketing decisions.

---

## Future Enhancements

- Perform sales forecasting using Python and machine learning techniques.
- Apply advanced SQL techniques, including query optimization and indexing.
- Build reusable SQL views and stored procedures for reporting.
- Expand the analysis with additional business KPIs and executive dashboards.

---

## Author

**Ranveer Kaur**

Aspiring Sales Data Analyst with a background in Statistics and hands-on experience in SQL, Excel, Power BI, and Python. Passionate about transforming raw data into meaningful insights through data analysis, visualization, and analytical thinking to support informed decision-making.
