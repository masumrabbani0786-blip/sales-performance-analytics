DROP TABLE sales_data;



CREATE TABLE Sales_Data(
	order_id INT PRIMARY KEY,
	order_date DATE,
	customer_id VARCHAR(20),
	product_category VARCHAR(20),
	region VARCHAR(15),
	quantity INT,
	unit_price NUMERIC(10,2),
	discount NUMERIC(5,2),
	payment_method VARCHAR(20),
	delivery_days INT,
	sales_amount NUMERIC(10,2)
);

SELECT * FROM Sales_Data;

--TOTAL ROWS
SELECT COUNT(*) ROWS FROM Sales_data
AS total_rows;

--TOTAL ORDERS
SELECT COUNT(DISTINCT order_id) AS 
total_orders
FROM sales_data;

--TOTAL CUSTOMER
SELECT COUNT(DISTINCT customer_id) AS 
total_customer
FROM sales_data;

--TOTAL QUANTITY SOLD
SELECT SUM(quantity) AS
total_quantity
FROM sales_data;

--TOTAL SALES
SELECT SUM((quantity*unit_price)*(1-discount)) AS
total_sales
FROM sales_data;

--AVERAGE ORDER VALUE	
SELECT SUM((quantity*unit_price)*(1-discount))/
	COUNT(DISTINCT order_id) AS 
	average_order_value
FROM sales_data;

--WHICH PRODUCT CATEGORY GENERATES THE MOST SLES
SELECT product_category,SUM
	((quantity*unit_price)*(1-discount)) AS
	total_sales
FROM sales_data
GROUP BY product_category
ORDER BY total_sales DESC;

--TOP 3 PRODUCT CATEGORIES BY SALES
SELECT product_category,SUM
	((quantity*unit_price)*(1-discount)) AS
	total_sales
FROM sales_data
GROUP BY product_category
ORDER BY total_sales DESC
LIMIT 3;

--WHICH CATEGORY HAS THE HIGHEST QUANTITY SOLD
SELECT product_category,SUM
	(quantity) AS total_quantity
FROM sales_data
GROUP BY product_category
ORDER BY total_quantity DESC;

--CATEGORY-WISE AVERAGE ORDER VALUE
SELECT product_category,SUM
	((quantity*unit_price)*(1-discount))/
	COUNT(DISTINCT order_id) AS 
	average_order_value
FROM sales_data
GROUP BY  product_category
ORDER BY average_order_value DESC;

--TOP 10 CUSTOMER BY SALES
SELECT customer_id,SUM
	((quantity*unit_price)*(1-discount)) AS
	total_sales
FROM sales_data
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;

--WHICH CUSTOMER PLACED THE MOST ORDERS
SELECT customer_id,
	COUNT(DISTINCT order_id)AS
total_orders
FROM sales_data
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

--AVERAGE SALES PER CUSTOMER
SELECT customer_id,SUM
	((quantity*unit_price)*(1-discount))AS 
	total_sales
FROM sales_data
GROUP BY customer_id
ORDER BY total_sales DESC;

--REGION-WISE TOTAL SALES
SELECT region,SUM
	((quantity*unit_price)*(1-discount))AS 
	total_sales
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;

--REGION-WISE ORDER COUNT
SELECT region,COUNT(DISTINCT order_id)
	AS total_orders
FROM sales_data
GROUP BY region
ORDER BY total_orders DESC;

--REGION-WISE QUANTITY SOLD
SELECT region,SUM
	(quantity)AS total_quantity
FROM sales_data
GROUP BY region
ORDER BY total_quantity DESC;

--MONTH-WISE TOTAL SALES
SELECT
	DATE_TRUNC('month',order_date)
AS sales_month,
	SUM ((quantity*unit_price)*(1-discount)) AS total_sales
FROM sales_data
GROUP BY sales_month
ORDER BY sales_month;

--WHICH MONTH HAD THE HIGHEST SALES
SELECT
	DATE_TRUNC('month',order_date)
AS sales_month,
	SUM ((quantity*unit_price)*(1-discount)) AS total_sales
FROM sales_data
GROUP BY sales_month
ORDER BY total_sales DESC
LIMIT 1;

--MONTH-WISE ORDER COUNT
SELECT 
    DATE_TRUNC('month', order_date) AS sales_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales_data
GROUP BY sales_month
ORDER BY sales_month;

--PEYMENT METHOD-WISE ORDERS
SELECT 
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales_data
GROUP BY payment_method
ORDER BY total_orders DESC;

--PEYMENT METHOD-WISE SALES
SELECT 
    payment_method,
    SUM((quantity * unit_price)*(1-discount)) AS total_sales
FROM sales_data
GROUP BY payment_method
ORDER BY total_sales DESC;

--AVERAGE DELIVERY DAYS
SELECT 
    AVG(delivery_days) AS average_delivery_days
FROM sales_data;

--REGION-WISE AVERAGE DELIVERY DAYS
SELECT 
    region,
    AVG(delivery_days) AS average_delivery_days
FROM sales_data
GROUP BY region
ORDER BY average_delivery_days;

--TOP 5 CUSTOMER USING RANK()
WITH customer_sales AS (
    SELECT 
        customer_id,
        SUM((quantity * unit_price)*(1-discount)) AS total_sales
    FROM sales_data
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS customer_rank
FROM customer_sales
ORDER BY customer_rank
LIMIT 5;

--ORDERS ABOVE AVERAGE SALES
SELECT 
    order_id,
    customer_id,
    ((quantity * unit_price)*(1-discount)) AS total_sales
FROM sales_data
WHERE ((quantity * unit_price)*(1-discount)) >
(
    SELECT AVG((quantity * unit_price)*(1-discount))
    FROM sales_data
)
ORDER BY total_sales DESC;

--MONTH-WISE SALES
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM((quantity * unit_price)*(1-discount)) AS total_sales
    FROM sales_data
    GROUP BY sales_month
)
SELECT 
    sales_month,
    total_sales
FROM monthly_sales
ORDER BY sales_month;

--MONTH-OVER-MONTH SALES GROWTH
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month',order_date) AS sales_month,
        SUM((quantity * unit_price)*(1-discount)) AS total_sales
    FROM sales_data
	GROUP BY DATE_TRUNC('month',order_date)
),
previous_sales AS (
    SELECT 
        sales_month,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY sales_month
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT 
    sales_month,
    total_sales,
    previous_month_sales,
    ROUND(
        (
            (total_sales - previous_month_sales)
            / NULLIF(previous_month_sales, 0)
        ) * 100,
        2
    ) AS growth_percentage
FROM previous_sales
ORDER BY sales_month;



