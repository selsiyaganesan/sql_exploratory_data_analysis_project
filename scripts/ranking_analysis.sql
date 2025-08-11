/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
--WHICH 5 PRODUCTS GENERATE THE HIGHEST REVENUE
SELECT TOP 5
  p.product_name,
  SUM(s.sales_amount) AS total_revenue
FROM Gold.fact_sales AS s
LEFT JOIN Gold.dim_product AS p
ON s.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
--what are the 5 worst performing of products in terms of sales
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) AS total_revenue
FROM Gold.fact_sales AS s
LEFT JOIN Gold.dim_product AS p
ON s.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC
--WHICH 5 SUBCATEGORY GENERATE THE HIGHEST REVENUE
SELECT TOP 5
p.sub_category,
SUM(s.sales_amount) AS total_revenue
FROM Gold.fact_sales AS s
LEFT JOIN Gold.dim_product AS p
ON s.product_key=p.product_key
GROUP BY p.sub_category
ORDER BY total_revenue DESC
--find the top 10 customers who have generated the highest revenue
SELECT TOP 10
c.customer_key,
c.firstname,
c.lastname,
SUM(s.sales_amount) AS total_revenue
FROM Gold.fact_sales AS s
LEFT JOIN Gold.dim_customer AS c
ON s.customer_key=c.customer_key
GROUP BY c.customer_key,c.firstname,
c.lastname
ORDER BY total_revenue DESC
--the 3 customers with the fewest order placed
SELECT TOP 3
c.customer_key,
c.firstname,
c.lastname,
COUNT(DISTINCT(s.order_number)) AS order_placed
FROM Gold.fact_sales AS s
LEFT JOIN Gold.dim_customer AS c
ON s.customer_key=c.customer_key
GROUP BY c.customer_key,c.firstname,
c.lastname
ORDER BY order_placed ASC
