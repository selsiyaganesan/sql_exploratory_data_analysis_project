/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */--analyze the yearly performance of products by comparing each product sales to both its average sales performance and the previous year's sales
SELECT
  order_year,
  product_name,
  Current_sales,
  avg_sales,
  Current_sales-avg_sales AS change_sales,
  Previous_sales,
  Current_sales-Previous_sales AS change_over_period
FROM(
    SELECT
    DATETRUNC(YEAR,f.order_date) AS order_year,
    p.product_name,
    SUM(f.sales_amount) AS Current_sales,
    AVG(SUM(f.sales_amount)) OVER (PARTITION BY p.product_name) AS avg_sales,
    LAG(SUM(f.sales_amount)) OVER (PARTITION BY p.product_name ORDER BY DATETRUNC(YEAR,f.order_date)) AS Previous_sales
    FROM Gold.fact_sales AS f
    left join Gold.dim_product AS p
    ON f.product_key=p.product_key
    WHERE DATETRUNC(YEAR,f.order_date) IS NOT NULL
    GROUP BY DATETRUNC(YEAR,f.order_date),
    p.product_name
)t
--or( WITH CTE)
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 
        YEAR(f.order_date),
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    -- Year-over-Year Analysis
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
