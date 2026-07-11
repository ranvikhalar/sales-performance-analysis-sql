# SQL Nuggets

This document captures important SQL concepts, best practices, and interview tips learned while completing the **Sales Performance Analysis | SQL & Power BI Case Study**.

The purpose of these notes is to build a practical SQL knowledge base that can be used for future projects, technical interviews, and day-to-day data analysis.

---

# Nugget #1: SQL Logical Query Processing Order

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
