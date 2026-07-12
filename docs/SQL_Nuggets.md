# SQL Nuggets

This document captures important SQL concepts, best practices, and interview tips learned while completing the **Sales Performance Analysis | SQL & Power BI Case Study**.

The purpose of these notes is to build a practical SQL knowledge base that can be used for future projects, technical interviews, and day-to-day data analysis.

---

# SQL Nugget #1: SQL Logical Query Processing Order

## Why can't a SELECT alias be used in the GROUP BY clause?

### Logical Query Processing Order

Although SQL queries are written in the following order:

```sql
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
```

SQL Server processes them in a different order:

| Execution Order | Clause | Description |
|----------------:|---------|-------------|
| 1 | FROM | Reads the source table(s). |
| 2 | WHERE | Filters rows before grouping. |
| 3 | GROUP BY | Groups rows for aggregation. |
| 4 | HAVING | Filters grouped results. |
| 5 | SELECT | Returns columns and creates aliases. |
| 6 | ORDER BY | Sorts the final result set. |

---

## Incorrect Example

```sql
SELECT
    YEAR(Sale_Date) AS sales_year
FROM dbo.sales_data
GROUP BY sales_year;
```

### Result

```
Invalid column name 'sales_year'
```

### Why?

The alias `sales_year` is created during the **SELECT** step.

However, **GROUP BY** is executed **before** the SELECT statement.

Therefore, SQL Server does not recognize the alias.

---

## Correct Example

```sql
SELECT
    YEAR(Sale_Date) AS sales_year
FROM dbo.sales_data
GROUP BY YEAR(Sale_Date);
```

---

## Why does ORDER BY work with aliases?

Unlike GROUP BY, the ORDER BY clause is executed after the SELECT clause.

Since aliases have already been created, they can be referenced safely.

Example:

```sql
SELECT
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
ORDER BY total_sales_revenue DESC;
```

---

# SQL Nugget #2: Why Does a Derived Table Need an Alias?

## Concept

A subquery placed inside the `FROM` clause is called a **derived table**. Since it behaves like a temporary table, SQL Server requires it to have a name (alias).

Without an alias, SQL Server does not know how to reference the derived table and returns an error.

---

## Incorrect Example

```sql
SELECT AVG(total_sales_revenue)
FROM
(
    SELECT
        Product_ID,
        SUM(Sales_Amount) AS total_sales_revenue
    FROM dbo.sales_data
    GROUP BY Product_ID
);
```

### Result

```
Every derived table must have its own alias.
```

---

## Correct Example

```sql
SELECT AVG(total_sales_revenue)
FROM
(
    SELECT
        Product_ID,
        SUM(Sales_Amount) AS total_sales_revenue
    FROM dbo.sales_data
    GROUP BY Product_ID
) AS sales_summary;
```

---

## Why Is an Alias Required?

The inner query returns a **temporary table**, not a single value.

Example:

| Product_ID | total_sales_revenue |
|------------|--------------------:|
| P101 | 25,000 |
| P102 | 18,500 |
| P103 | 31,200 |

Since this result behaves like a table, SQL Server requires a name for it. The alias (`sales_summary`) acts as the name of that temporary table.

---

## When Is an Alias Required?

### Subquery Returning a Table (Alias Required)

```sql
SELECT *
FROM
(
    SELECT Product_ID, SUM(Sales_Amount) AS total_sales_revenue
    FROM dbo.sales_data
    GROUP BY Product_ID
) AS sales_summary;
```

---

### Subquery Returning a Single Value (Alias Not Required)

```sql
SELECT *
FROM dbo.sales_data
WHERE Sales_Amount >
(
    SELECT AVG(Sales_Amount)
    FROM dbo.sales_data
);
```

In this case, the subquery returns only **one value**, so no alias is needed.

---

---

# SQL Nugget #3: Common Sales KPIs

The following are commonly used Key Performance Indicators (KPIs) in Sales Analytics. These formulas represent standard business calculations and are widely used in sales reporting and business intelligence dashboards.

> **Note:** Some profitability KPIs are included for learning purposes. Their implementation depends on the business definitions and data model of the underlying dataset.

---

## 1. Total Sales Revenue

### Business Purpose

Measures the total revenue generated from all sales transactions.

### Formula

```text
Total Sales Revenue = Σ(Sales Amount)
```

---

## 2. Average Sales per Transaction

### Business Purpose

Measures the average revenue generated from each sales transaction.

### Formula

```text
Average Sales = Total Sales Revenue / Total Number of Transactions
```

---

## 3. Average Order Value (AOV)

### Business Purpose

Measures the average amount spent per customer order.

### Formula

```text
Average Order Value (AOV) = Total Sales Revenue / Total Number of Orders
```

---

## 4. Total Quantity Sold

### Business Purpose

Measures the total number of product units sold.

### Formula

```text
Total Quantity Sold = Σ(Quantity Sold)
```

---

## 5. Total Number of Transactions

### Business Purpose

Measures the total number of completed sales transactions.

### Formula

```text
Total Transactions = COUNT(Transactions)
```

---

## 6. Revenue Contribution Percentage

### Business Purpose

Measures the percentage of total company revenue contributed by a product, category, region, or sales representative.

### Formula

```text
Revenue Contribution (%) = (Category Revenue / Total Company Revenue) × 100
```

---

## 7. Average Discount

### Business Purpose

Measures the average discount applied to sales transactions.

### Formula

```text
Average Discount = Σ(Discount) / Total Number of Transactions
```

or

```text
Average Discount = AVG(Discount)
```

---

## 8. Sales Growth Percentage

### Business Purpose

Measures the increase or decrease in sales over a specified time period.

### Formula

```text
Sales Growth (%) = ((Current Sales − Previous Sales) / Previous Sales) × 100
```

---

## 9. Cost of Goods Sold (COGS)

### Business Purpose

Measures the direct cost associated with products sold.

### Formula

```text
COGS = Unit Cost × Quantity Sold
```

---

## 10. Total Profit

### Business Purpose

Measures the earnings after deducting product costs from revenue.

### Formula

```text
Profit = Revenue − Cost
```

or

```text
Profit = (Unit Price − Unit Cost) × Quantity Sold
```

---

## 11. Gross Profit Margin

### Business Purpose

Measures the percentage of revenue retained after covering direct product costs.

### Formula

```text
Gross Profit Margin (%) = (Gross Profit / Revenue) × 100
```

---

## 12. Profit per Unit

### Business Purpose

Measures the profit earned on each unit sold.

### Formula

```text
Profit per Unit = Unit Price − Unit Cost
```

---

## 13. Discounted Revenue

### Business Purpose

Measures revenue received after applying discounts.

### Formula

```text
Discounted Revenue = Quantity Sold × Unit Price × (1 − Discount)
```

---

## 14. Customer Retention Rate

### Business Purpose

Measures the percentage of customers retained during a specified period.

### Formula

```text
Customer Retention Rate (%) = (Retained Customers / Customers at Beginning of Period) × 100
```

---

## 15. Customer Acquisition Rate

### Business Purpose

Measures the percentage of new customers acquired during a specified period.

### Formula

```text
Customer Acquisition Rate (%) = (New Customers / Total Customers) × 100
```

---

## 16. Sales Target Achievement

### Business Purpose

Measures actual sales performance against a predefined sales target.

### Formula

```text
Sales Target Achievement (%) = (Actual Sales / Sales Target) × 100
```

---

## 17. Sales per Representative

### Business Purpose

Measures the total revenue generated by each sales representative.

### Formula

```text
Sales per Representative = Σ(Sales Revenue by Sales Representative)
```

---

## 18. Average Revenue per Sales Representative

### Business Purpose

Measures the average revenue generated across all sales representatives.

### Formula

```text
Average Revenue per Sales Representative = Total Sales Revenue / Total Number of Sales Representatives
```

---

## 19. Product Revenue Ranking

### Business Purpose

Ranks products based on their total sales revenue.

### Formula

```text
Product Revenue Rank = Rank(Total Sales Revenue)
```

---

## 20. Running Sales Revenue

### Business Purpose

Measures cumulative sales revenue over time.

### Formula

```text
Running Sales Revenue = Current Period Revenue + Previous Running Revenue
```

---

## Dataset Note

This project uses a synthetic sales dataset for SQL practice and portfolio development.

Most revenue-based KPIs can be demonstrated accurately using the available data. However, some profitability KPIs (such as **Profit** and **Gross Profit Margin**) are included for learning purposes only because the synthetic dataset generates `Sales_Amount`, `Unit_Price`, `Unit_Cost`, `Quantity_Sold`, and `Discount` independently rather than from a mathematically consistent transaction model.

In a production environment, KPI definitions should always be validated with business stakeholders before reporting analytical results.

---

## Key Takeaway

> A technically correct SQL query does not always produce a valid business KPI.

Before reporting a KPI, a data analyst should verify:

1. The business definition of each field.
2. Whether the required fields are mathematically related.
3. That calculations use consistent business definitions.
4. That the dataset contains the required level of detail.
5. That the final results make business sense.
