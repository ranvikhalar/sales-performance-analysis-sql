/*
=========================================================
PHASE 1: DATA UNDERSTANDING
=========================================================

Objective:
Understand the structure, content, and quality of the sales dataset before performing data cleaning and business analysis.

=========================================================
*/

-- STEP 1: Check total number of records in the sales table
-- Business purpose: Understand dataset size and scale of analysis
SELECT
	COUNT(*) AS total_rows
FROM dbo.sales_data;

-- STEP 2: Review the table structure.
-- Business purpose: Understand the available columns and data types before performing data analysis.
EXEC sp_help 'dbo.sales_data';

-- STEP 3: View table metadata using INFORMATION_SCHEMA.
-- Business purpose: Review column details using a standard SQL metadata view.
SELECT
	COLUMN_NAME,
	DATA_TYPE,
	IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA= 'dbo' AND TABLE_NAME = 'sales_data';

-- STEP 3: Preview the dataset.
-- Business purpose: Review sample records to understand the data before analysis.
SELECT TOP(10) *
FROM dbo.sales_data;

/*
=========================================================
PHASE 1 OBSERVATIONS
=========================================================

1. The dataset contains 1,000 sales records.

2. The table structure, column names, and data types were successfully verified.

3. During the initial import, the Discount column was incorrectly detected as a TIME data type. After validating the source CSV, the dataset was re-imported
   without checking off the "Use Rich Data Type Detection" option enabled, resulting in the Discount column being correctly imported as a DECIMAL data type.

Conclusion:
The dataset structure and data types were successfully validated and the dataset was prepared for the Data Quality Assessment phase.

=========================================================
*/

/*
=========================================================
PHASE 2: DATA QUALITY ASSESSMENT
=========================================================

Objective:
Assess the quality of the sales dataset by identifying missing values, duplicate records, inconsistent values, and other issues before performing business analysis.

=========================================================
*/

-- STEP 4: Check for missing values.
-- Business purpose: Ensure critical business fields contain complete data for accurate reporting.

SELECT
    COUNT(*) AS total_records,
    COUNT(*) - COUNT(Product_ID) AS product_id_missing_values,
    COUNT(*) - COUNT(Sale_Date) AS sale_date_missing_values,
    COUNT(*) - COUNT(Sales_Rep) AS sales_rep_missing_values,
    COUNT(*) - COUNT(Region) AS region_missing_values,
    COUNT(*) - COUNT(Sales_Amount) AS sales_amount_missing_values,
    COUNT(*) - COUNT(Quantity_Sold) AS quantity_sold_missing_values,
    COUNT(*) - COUNT(Product_Category) AS product_category_missing_values,
    COUNT(*) - COUNT(Unit_Cost) AS unit_cost_missing_values,
    COUNT(*) - COUNT(Unit_Price) AS unit_price_missing_values,
    COUNT(*) - COUNT(Customer_Type) AS customer_type_missing_values,
    COUNT(*) - COUNT(Discount) AS discount_missing_values,
    COUNT(*) - COUNT(Payment_Method) AS payment_method_missing_values,
    COUNT(*) - COUNT(Sales_Channel) AS sales_channel_missing_values,
    COUNT(*) - COUNT(Region_and_Sales_Rep) AS region_and_sales_rep_missing_values
FROM dbo.sales_data;

-- Real-world note: Manual NULL checks are suitable for small tables.
-- For large tables, metadata-driven dynamic SQL avoids writing one expression per column.

/*
=========================================================
FUTURE ENHANCEMENT: DYNAMIC SQL
=========================================================

For large production datasets containing hundreds or thousands of columns, missing value checks can be generated dynamically using metadata tables (INFORMATION_SCHEMA.COLUMNS or sys.columns).

This approach will be implemented later in the project as part of the Advanced SQL Techniques section.
=========================================================
*/

--DECLARE @sql NVARCHAR(MAX);

--SELECT @sql = STRING_AGG(
--    CAST(
--        'SELECT ' +
--        QUOTENAME(c.name, '''') + ' AS column_name, ' +
--        'COUNT(*) - COUNT(' + QUOTENAME(c.name) + ') AS missing_values ' +
--        'FROM dbo.sales_data'
--        AS NVARCHAR(MAX)
--    ),
--    ' UNION ALL '
--)
--FROM sys.columns AS c
--WHERE c.object_id = OBJECT_ID('dbo.sales_data');

--EXEC sp_executesql @sql;

-- STEP 5: Check for duplicate records.
-- Business purpose: Identify completely duplicated sales records that could lead to inaccurate business reporting.

SELECT
    Product_ID,
    Sale_Date,
    Sales_Rep,
    Region,
    Sales_Amount,
    Quantity_Sold,
    Product_Category,
    Unit_Cost,
    Unit_Price,
    Customer_Type,
    Discount,
    Payment_Method,
    Sales_Channel,
    Region_and_Sales_Rep,
    COUNT(*) AS duplicate_count
FROM dbo.sales_data
GROUP BY
    Product_ID,
    Sale_Date,
    Sales_Rep,
    Region,
    Sales_Amount,
    Quantity_Sold,
    Product_Category,
    Unit_Cost,
    Unit_Price,
    Customer_Type,
    Discount,
    Payment_Method,
    Sales_Channel,
    Region_and_Sales_Rep
HAVING COUNT(*) > 1;

-- STEP 6: Validate numeric values.
-- Business purpose: Identify invalid or unrealistic numeric values that may affect business analysis.
SELECT *
FROM dbo.sales_data
WHERE Sales_Amount < 0 
    OR Quantity_Sold < 0
    OR Unit_Cost < 0
    OR Unit_Price < 0
    OR Discount < 0
    OR Discount > 1;

-- STEP 7: Validate categorical values.
-- Business purpose: Identify inconsistent or unexpected category values before analysis.

SELECT DISTINCT Region
FROM dbo.sales_data;

SELECT DISTINCT Product_Category
FROM dbo.sales_data;

SELECT DISTINCT Customer_Type
FROM dbo.sales_data;

SELECT DISTINCT Payment_Method
FROM dbo.sales_data;

SELECT DISTINCT Sales_Channel
FROM dbo.sales_data;

-- STEP 8: Validate date values.
-- Business purpose: Identify invalid or unrealistic sales dates before time-based analysis.

SELECT
    MIN(Sale_Date) AS earliest_sale_date,
    MAX(Sale_Date) AS latest_sale_date
FROM dbo.sales_data;

-- STEP 9: Validate business rules.
-- Business purpose: Identify records where the selling price is lower than the unit cost.

SELECT *
FROM dbo.sales_data
WHERE Unit_Price <= Unit_Cost;

/*
=========================================================
PHASE 2 OBSERVATIONS
=========================================================

1. No missing values were identified across any columns.

2. No fully duplicated records were found in the dataset.

3. Numeric fields passed the initial validation with no invalid or unrealistic values detected.

4. Categorical fields contained consistent business values with no unexpected categories identified.

5. The sales date range was reviewed and found to be appropriate for analysis.

6. Business rule validation confirmed that Unit_Price was not lower than Unit_Cost for any sales record.

Conclusion:
The dataset successfully passed the initial data quality assessment and is suitable for exploratory data analysis and business reporting.

=========================================================
*/

/*
=========================================================
PHASE 3: EXPLORATORY DATA ANALYSIS (EDA)
=========================================================

Objective:
Explore the sales dataset to identify trends, patterns, and business insights that support data-driven decision-making.

=========================================================
*/

-- STEP 10: Analyze overall sales performance.
-- Business purpose: Provide a high-level summary of the overall sales performance to understand the current state of the business before performing detailed analysis.

SELECT SUM(Sales_Amount) AS total_sales_revenue,
    AVG(Sales_Amount) AS average_sales_per_transaction,
    MAX(Sales_Amount) AS highest_sale,
    MIN(Sales_Amount) AS lowest_sale,
    COUNT(*) AS total_transactions
FROM dbo.sales_data;

/*
---------------------------------------------------------
Observations

• The business generated total sales revenue of $5,019,265.23 from 1,000 sales transactions.

• The average sales value per transaction was $5,019.27.

• The highest sale was $9,989.04, while the lowest sale was $100.12.

Business Insight

The sales data contains a good mix of transaction values, making it suitable for analyzing business performance.
---------------------------------------------------------
*/

-- STEP 11: Analyze product category performance.
-- Business purpose: Identify the highest and lowest performing product categories to support inventory, pricing, and marketing decisions.

SELECT Product_Category,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Product_Category
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• Clothing generated the highest total sales revenue - $1,313,474.36.

• Furniture ranked second, followed closely by Electronics.

• Food generated the lowest total sales revenue.

Business Insight

Clothing is the strongest-performing category and may benefit from continued inventory and marketing support.
---------------------------------------------------------
*/

-- STEP 12: Analyze regional sales performance.
-- Business purpose: Compare sales performance across regions to identify areas requiring additional sales and marketing efforts.

SELECT Region,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Region
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• North generated the highest sales revenue.

• East and West produced similar sales revenue.

• South generated the lowest sales revenue.

Business Insight

The South region may require additional sales or marketing efforts to improve performance.
---------------------------------------------------------
*/

-- STEP 13: Analyze sales representative performance.
-- Business purpose: Compare sales performance across sales representatives to identify top performers and opportunities for coaching and performance improvement.

SELECT Sales_Rep,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Sales_Rep
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• David generated the highest total sales revenue.

• Bob ranked second in total sales revenue.

• Charlie generated the lowest total sales revenue.

Business Insight

Sales performance varies among sales representatives. Reviewing the strategies used by top performers may help improve the performance of the overall sales team.
---------------------------------------------------------
*/

-- STEP 14: Analyze customer type performance.
-- Business purpose: Compare sales performance across customer types to understand customer contribution and support customer relationship strategies.

SELECT Customer_Type,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Customer_Type
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• Returning customers generated $2,513,006.93 in sales revenue.

• New customers generated $2,506,258.30 in sales revenue.

• Both customer types contributed almost equally to total sales revenue.

Business Insight

The business is performing well in both acquiring new customers and retaining existing customers.
---------------------------------------------------------
*/

-- STEP 15: Analyze monthly sales trends.
-- Business purpose: Analyze sales trends over time to identify seasonal patterns and support business planning and forecasting.

SELECT YEAR(Sale_Date) AS sales_year,
    MONTH(Sale_Date) AS sales_month,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY YEAR(Sale_Date), MONTH(Sale_Date)
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• January 2023 generated the highest monthly sales revenue.

• October and November were also among the strongest sales months.

• January 2024 recorded significantly lower sales revenue, indicating that only partial monthly data is available.

Business Insight

Sales fluctuate throughout the year. Monthly trends can help identify seasonal patterns and support business planning.
---------------------------------------------------------
*/

-- STEP 16: Analyze sales channel performance.
-- Business purpose: Compare sales performance across sales channels to identify the most effective channels for generating revenue.

SELECT Sales_Channel,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Sales_Channel
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• Retail generated slightly higher sales revenue than Online.

• Both sales channels contributed nearly equal amounts of total revenue.

Business Insight

Both Retail and Online channels are important revenue sources and should continue to be supported.
---------------------------------------------------------
*/

-- STEP 17: Analyze payment method performance.
-- Business purpose: Compare sales performance across payment methods to understand customer payment preferences and support payment strategy decisions.

SELECT Payment_Method,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Payment_Method
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• Credit Card generated the highest sales revenue.

• Bank Transfer ranked second.

• Cash generated the lowest sales revenue.

Business Insight

Customers appear to prefer electronic payment methods over cash transactions.
---------------------------------------------------------
*/

-- STEP 18: Analyze product pricing.
-- Business purpose: Analyze product pricing to understand the range of selling prices across product categories and support pricing decisions.

SELECT Product_Category,
    AVG(Unit_Price) AS average_unit_price,
    MAX(Unit_Price) AS highest_unit_price,
    MIN(Unit_Price) AS lowest_unit_price
FROM dbo.sales_data
GROUP BY Product_Category;

/*
---------------------------------------------------------
Observations

• Electronics had the highest average unit price.

• Food recorded the highest individual unit price.

• Furniture had the lowest minimum unit price.

Business Insight

Product pricing varies across categories, providing different pricing options for customers.
---------------------------------------------------------
*/

-- STEP 19: Analyze discount performance.
-- Business purpose: Analyze discount patterns to understand how discounts are applied across product categories and support pricing and promotional strategies.

SELECT Product_Category,
    AVG(Discount) AS average_discount
FROM dbo.sales_data
GROUP BY Product_Category
ORDER BY average_discount DESC;

/*
---------------------------------------------------------
Observations

• Clothing received the highest average discount (16.02%).

• Electronics received the lowest average discount (13.65%).

• Average discounts across categories ranged between approximately 14% and 16%.

Business Insight

Discount strategies are fairly consistent across product categories with only small differences.
---------------------------------------------------------
*/

-- STEP 20: Analyze top-performing products.
-- Business purpose: Identify the products generating the highest sales revenue to support inventory, marketing, and sales strategies.

SELECT TOP (5)
    Product_ID,
    Product_Category,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY
    Product_ID,
    Product_Category
ORDER BY
    total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• Product 1089 generated the highest total sales revenue.

• The top five products belong to multiple product categories.

• Revenue is distributed across several high-performing products.

Business Insight

Top-performing products should remain a focus for inventory planning and promotional activities.
---------------------------------------------------------
*/

-- STEP 21: Analyze above-average sales representatives.
-- Business purpose: Identify sales representatives whose total sales revenue exceeds the company's average sales performance.

SELECT Sales_Rep,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Sales_Rep
HAVING SUM(Sales_Amount) > 
(
    SELECT AVG(total_sales_revenue)
    FROM
    (
        SELECT Sales_Rep,
        SUM(Sales_Amount) AS total_sales_revenue
        FROM dbo.sales_data
        GROUP BY Sales_Rep
    ) AS sales_summary
)
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• David generated the highest sales revenue.

• Bob also achieved sales revenue above the average sales representative performance.

Business Insight

Top-performing sales representatives can be used as benchmarks for improving team performance.
---------------------------------------------------------
*/

-- STEP 22: Analyze lowest-performing products.
-- Business purpose: Identify products generating the lowest sales revenue to support inventory review, pricing strategies, and product improvement.

SELECT TOP(5) Product_ID, 
    Product_Category,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Product_Category, Product_ID
ORDER BY total_sales_revenue ASC;

/*
---------------------------------------------------------
Observations

• Product 1070 generated the lowest sales revenue.

• Several products generated considerably lower revenue than the company's top-performing products.

Business Insight

Low-performing products should be reviewed to identify opportunities for improvement.
---------------------------------------------------------
*/

-- STEP 23: Analyze above-average products.
-- Business purpose: Identify products whose total sales revenue exceeds the average product sales revenue.

SELECT Product_ID,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Product_ID
HAVING SUM(Sales_Amount) > 
(
    SELECT AVG(total_sales_revenue)
    FROM (
            SELECT Product_ID,
            SUM(Sales_Amount) AS total_sales_revenue
            FROM dbo.sales_data
            GROUP BY Product_ID
    ) AS sales_summary
)
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• Multiple products generated sales revenue above the average product revenue.

• Product 1099 recorded the highest revenue among the above-average products.

Business Insight

These products are important contributors to overall sales revenue and should continue to receive attention.
---------------------------------------------------------
*/
 
-- STEP 24: Analyze average order value by region.
-- Business purpose: Compare the average order value across regions to identify areas generating higher value transactions and support regional sales strategies.

SELECT Region,
    AVG(Sales_Amount) AS average_order_value
FROM dbo.sales_data
GROUP BY Region
ORDER BY average_order_value DESC;

/*
---------------------------------------------------------
Observations

• North recorded the highest average order value.

• East recorded the lowest average order value.

• The average order value was relatively similar across all regions.

Business Insight

Customers in the North region tend to place slightly higher-value orders than customers in other regions.
---------------------------------------------------------
*/

-- STEP 25: Analyze product category profit.
-- Business purpose: Compare profit across product categories to identify the most profitable products and support pricing, inventory, and sales strategies.

SELECT Product_Category,
    SUM((Unit_Price - Unit_Cost)*Quantity_Sold) AS total_profit
FROM dbo.sales_data
GROUP BY Product_Category
ORDER BY total_profit DESC;

/*
---------------------------------------------------------
Observations

• Furniture generated the highest calculated total profit.

• Clothing ranked second in calculated total profit.

• Food generated the lowest calculated total profit.

Business Insight

Based on the available data, Furniture appears to be the most profitable category. Since this is a synthetic dataset, these profit values should be treated as conceptual.
---------------------------------------------------------
*/

-- STEP 26: Analyze sales representative profitability.
-- Business purpose: Compare profit generated by each sales representative to identify the highest contributing sales representatives.

SELECT
    Sales_Rep,
    SUM((Unit_Price - Unit_Cost) * Quantity_Sold) AS total_profit
FROM dbo.sales_data
GROUP BY Sales_Rep
ORDER BY total_profit DESC;

/*
---------------------------------------------------------
Observations

• David generated the highest calculated total profit.

• Bob ranked second in calculated total profit.

• Charlie generated the lowest calculated total profit.

Business Insight

David contributed the highest calculated profit among all sales representatives. These results are based on the synthetic dataset and should be interpreted as conceptual.
---------------------------------------------------------
*/

-- STEP 27: Analyze revenue contribution by product category.
-- Business purpose: Determine the percentage of total sales revenue contributed by each product category to identify the company's primary revenue drivers.

SELECT
    Product_Category,
    SUM(Sales_Amount) AS total_sales_revenue,
    (SUM(Sales_Amount) * 100.0
        /
        (
            SELECT SUM(Sales_Amount)
            FROM dbo.sales_data
        )
    ) AS revenue_contribution_percentage
FROM dbo.sales_data
GROUP BY Product_Category
ORDER BY revenue_contribution_percentage DESC;

/*
---------------------------------------------------------
Observations

• Clothing contributed the highest percentage of total sales revenue.

• Furniture and Electronics contributed similar shares of total revenue.

• Food contributed the smallest share of total revenue.

Business Insight

Revenue is well distributed across all product categories, with Clothing contributing the largest share.
---------------------------------------------------------
*/

-- STEP 28: Rank products by total sales revenue.
-- Business purpose: Rank products based on total sales revenue to identify the strongest and weakest performers.

SELECT
    Product_ID,
    SUM(Sales_Amount) AS total_sales_revenue,
    RANK() OVER (
        ORDER BY SUM(Sales_Amount) DESC
    ) AS product_revenue_rank
FROM dbo.sales_data
GROUP BY Product_ID
ORDER BY product_revenue_rank;

/*
---------------------------------------------------------
Observations

• Product 1099 ranked first based on total sales revenue.

• Products were ranked from highest to lowest sales revenue.

Business Insight

Product rankings help identify the strongest-performing products for inventory planning and promotional decisions.
---------------------------------------------------------
*/

-- STEP 29: Compare RANK(), DENSE_RANK(), and ROW_NUMBER().
-- Business purpose: Demonstrate different ranking methods for products based on total sales revenue and understand how SQL handles ties.

-- RANK()
-- - Assigns the same rank to same values.
-- - Skips the next rank after a same value.
-- - Example: 1, 2, 2, 4
--
-- DENSE_RANK()
-- - Assigns the same rank to same values.
-- - Does not skip the next rank.
-- - Example: 1, 2, 2, 3
--
-- ROW_NUMBER()
-- - Assigns a unique sequential number to every row.
-- - Does not consider ties.
-- - Example: 1, 2, 3, 4

SELECT
    Product_ID,
    SUM(Sales_Amount) AS total_sales_revenue,

    RANK() OVER (
        ORDER BY SUM(Sales_Amount) DESC
    ) AS product_rank,

    DENSE_RANK() OVER (
        ORDER BY SUM(Sales_Amount) DESC
    ) AS dense_product_rank,

    ROW_NUMBER() OVER (
        ORDER BY SUM(Sales_Amount) DESC
    ) AS row_number

FROM dbo.sales_data
GROUP BY Product_ID
ORDER BY total_sales_revenue DESC;

/*
---------------------------------------------------------
Observations

• RANK(), DENSE_RANK(), and ROW_NUMBER() produced the same rankings for this dataset.

• No products had identical total sales revenue that affected the rankings.

Business Insight

Although the results are the same here, each ranking function behaves differently when duplicate values exist.
---------------------------------------------------------
*/

-- STEP 30: Analyze cumulative monthly sales revenue.
-- Business purpose: Calculate the cumulative monthly sales revenue to monitor business growth over time.

-- CTE (Common Table Expression)
-- Creates a temporary named result set that can be referenced later in the same query. It improves readability and simplifies complex queries by breaking them into smaller logical steps.

WITH monthly_sales AS
(
    SELECT
        Year(Sale_Date) AS sales_year,
        MONTH(Sale_Date) AS sales_month,
        SUM(Sales_Amount) AS monthly_sales_revenue
    FROM dbo.sales_data
    GROUP BY Year(Sale_Date), MONTH(Sale_Date)
)

SELECT sales_year,
    sales_month,
    monthly_sales_revenue,
    SUM(monthly_sales_revenue) OVER
    (
        ORDER BY sales_year, sales_month
    ) AS running_sales_revenue
FROM monthly_sales
ORDER BY sales_year, sales_month;

/*
---------------------------------------------------------
Observations

• Running sales revenue increased each month as sales accumulated over time.

• The cumulative sales revenue reached the company's total sales revenue by the final reporting period.

Business Insight

Running totals provide a clear view of cumulative business performance throughout the reporting period.
---------------------------------------------------------
*/

-- STEP 31: Analyze month-over-month sales growth.
-- Business purpose: Compare monthly sales revenue with the previous month to measure business growth and identify increasing or declining sales trends.

WITH monthly_sales AS
(
    SELECT
        Year(Sale_Date) AS sales_year,
        MONTH(Sale_Date) AS sales_month,
        SUM(Sales_Amount) AS monthly_sales_revenue
    FROM dbo.sales_data
    GROUP BY Year(Sale_Date), MONTH(Sale_Date)
),
monthly_comparison AS
(
    SELECT
        sales_year,
        sales_month,
        monthly_sales_revenue,
        LAG(monthly_sales_revenue) OVER
        (
            ORDER BY sales_year, sales_month
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    sales_year,
    sales_month,
    monthly_sales_revenue,
    previous_month_sales,
    monthly_sales_revenue - previous_month_sales AS sales_change,
    ROUND(
    (
        (monthly_sales_revenue - previous_month_sales) * 100.0
        / NULLIF(previous_month_sales, 0)
    ),
    2) AS sales_growth_percentage
FROM monthly_comparison
ORDER BY
    sales_year,
    sales_month;

/*
---------------------------------------------------------
Observations

• Monthly sales experienced both increases and decreases throughout the reporting period.

• October recorded the highest month-over-month sales growth.

• January 2024 recorded the largest decline because only partial monthly data is available.

Business Insight

Monitoring month-over-month growth helps identify sales trends and periods that may require further investigation.
---------------------------------------------------------
*/

-- STEP 32: Identify the top-performing sales representative in each region.
-- Business purpose: Determine the highest-performing sales representative within each region based on total sales revenue.

WITH regional_sales AS
(
    SELECT
        Region,
        Sales_Rep,
        SUM(Sales_Amount) AS total_sales_revenue
    FROM dbo.sales_data
    GROUP BY
        Region,
        Sales_Rep
),
ranked_sales AS
(
    SELECT
        Region,
        Sales_Rep,
        total_sales_revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY Region
            ORDER BY total_sales_revenue DESC
        ) AS sales_rank
    FROM regional_sales
)

SELECT
    Region,
    Sales_Rep,
    total_sales_revenue
FROM ranked_sales
WHERE sales_rank = 1
ORDER BY Region;

/*
---------------------------------------------------------
Observations

• Bob was the top-performing sales representative in both the East and West regions.

• Eve ranked first in the North region.

• David ranked first in the South region.

Business Insight

Each region has a different top-performing sales representative, highlighting regional differences in sales performance.
---------------------------------------------------------
*/

-- STEP 33: Identify the top 3 products in each product category.
-- Business purpose: Identify the highest-performing products within each category to support inventory, promotion, and product strategy decisions.

WITH product_sales AS
(SELECT Product_Category,
    Product_ID,
    SUM(Sales_Amount) AS total_sales_revenue
FROM dbo.sales_data
GROUP BY Product_Category, Product_ID),

ranked_products AS
(SELECT Product_Category,
    Product_ID,
    total_sales_revenue,
    ROW_NUMBER() OVER
    (
    PARTITION BY Product_Category
    ORDER BY total_sales_revenue DESC
    ) AS product_rank
  FROM product_sales
)

SELECT Product_Category,
    Product_ID,
    total_sales_revenue,
    product_rank
FROM ranked_products
WHERE product_rank <= 3
ORDER BY Product_Category, product_rank;

/*
---------------------------------------------------------
Observations

• The top three products were identified within each product category.

• Product 1090 ranked first in Clothing.

• Product 1048 ranked first in Electronics.

• Product 1027 ranked first in Food.

• Product 1089 ranked first in Furniture.

Business Insight

Identifying the top products within each category helps prioritize inventory management and promotional efforts.
---------------------------------------------------------
*/

/*
=========================================================
FINAL NOTE

This project uses a synthetic dataset for learning and portfolio purposes.

Profit calculations are included to demonstrate SQL analysis. Since the dataset does not maintain a consistent relationship between Sales_Amount, Unit_Price, Unit_Cost, Quantity_Sold, and Discount, the calculated profit values should be interpreted for learning purposes only.
=========================================================
*/
