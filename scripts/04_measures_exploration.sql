/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

--find the total sales
SELECT
    SUM(sales_amount) AS Total_sales
from Gold.fact_sales
    
--find how many items are sold
SELECT
    COUNT(quantity) AS items_sold
FROM Gold.fact_sales
    
--find the average selling price
SELECT
    AVG(price) AS avg_selling_price
FROM Gold.fact_sales
    
--Find the total number of orders
SELECT
    COUNT(DISTINCT(order_number)) AS total_nr_of_orders
from Gold.fact_sales
    
--find the total number of products
SELECT
    COUNT(product_name) AS total_nr_of_products
FROM Gold.dim_product
    
--find the total number of customer
SELECT 
    COUNT(customer_id) AS total_nr_of_customers
FROM Gold.dim_customer
    
--find the total number of customers that has placed the orders
SELECT
    COUNT(DISTINCT(customer_key)) AS placed_order
FROM Gold.fact_sales
    
--general combined measure
SELECT 'Total_sales' as measure_name ,SUM(sales_amount) AS measure_value from Gold.fact_sales
UNION ALL 
SELECT 'items_sold' as measure_name ,COUNT(quantity) AS measure_value from Gold.fact_sales
UNION ALL
SELECT 'avg_selling_price' as measure_name ,AVG(price) AS measure_value from Gold.fact_sales
UNION ALL
SELECT 'total_nr_of_orders' as measure_name ,COUNT(DISTINCT(order_number)) AS measure_value from Gold.fact_sales
UNION ALL
SELECT 'total_nr_of_products' as measure_name ,COUNT(customer_id) AS measure_value from Gold.dim_customer
UNION ALL
SELECT 'placed_order' as measure_name ,COUNT(DISTINCT(customer_key)) AS measure_value from Gold.fact_sales
