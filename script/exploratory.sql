-- Generate a report that shows all key metrics of the business

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products' AS measure_name, COUNT(DISTINCT product_name) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers' AS measure_name, COUNT(customer_key) AS measure_value FROM gold.dim_customers


-- Total customers by countries

SELECT 
	country,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC

-- Total customers by gender

SELECT 
	gender,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

-- Total products by category

SELECT 
	category,
	COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

-- Average cost in each category

SELECT 
	category,
	AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC

-- Total revenue generated for each category

SELECT 
	p.category,
	SUM(sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY category
ORDER BY total_revenue DESC

-- Total revenue generated for each customer

SELECT 
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON c.customer_key= s.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC

-- Distribution of items sold across countries

SELECT 
	c.country,
	SUM(s.quantity) AS total_sold_itmes
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON c.customer_key= s.customer_key
GROUP BY c.country
ORDER BY total_sold_itmes DESC

-- Which 5 products generate the highest revenue

SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount)  AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

SELECT * 
FROM (
	SELECT
		p.product_name,
		SUM(s.sales_amount)  AS total_revenue,
		ROW_NUMBER () OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON p.product_key = s.product_key
	GROUP BY p.product_name)t
WHERE rank_products <= 5

-- Which 5 products generate the lowest revenue

SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount)  AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC
