SELECT * FROM customer LIMIT 10;

-- Business Overview

-- Total number of Records
SELECT COUNT(*)
FROM customer;

-- Total Revenue 
SELECT SUM("Sales") AS "Reevenue"
FROM customer;

-- Total Profit 
SELECT SUM("Profit") AS Total_Profit 
FROM customer;

-- Avg Sales 
SELECT
AVG("Sales")
FROM customer;

-- Avg Profit 
SELECT
AVG("Profit")
FROM customer;

-- Total Orders
SELECT
COUNT(DISTINCT "Order ID") AS Total_orders
FROM customer;

-- Total Customers
SELECT COUNT(DISTINCT "Customer ID") AS Total_customer
FROM customer;

-- Avg Order Value 
SELECT
SUM("Sales")/COUNT(DISTINCT "Order ID") AS Average_Order_Value
FROM customer;



-- Sales Performanc

-- Which product categories generate the highest revenue?

SELECT "Category" , SUM("Sales")
FROM customer
GROUP BY 1
ORDER BY 2 DESC;

-- Which category is most profitable?
SELECT "Category" , SUM("Profit")
FROM customer
GROUP BY 1
ORDER BY 2 DESC;


--Which sub-categories generate the highest profit?
SELECT "Sub-Category" , SUM("Profit") 
FROM customer 
GROUP BY 1
ORDER BY 2 DESC;

-- Which regions generate the highest revenue and profit?
SELECT "Region" , SUM("Sales") AS Revenue , SUM("Profit") AS Profit
FROM customer
GROUP BY 1
ORDER BY 2 DESC;

-- Which states contribute the highest sales?
SELECT "State" , SUM("Sales") AS Sales
FROM customer 
GROUP BY 1
ORDER BY 2 DESC ;

-- Time Analysis

-- How do monthly sales and profit change over time?
SELECT "Month" , SUM("Sales") AS Revenue , SUM("Profit") AS Profit
FROM customer 
GROUP BY 1
ORDER BY 1 DESC;

-- Which quarter performs the best?
SELECT
EXTRACT(YEAR FROM "Order Date") AS Year,
EXTRACT(QUARTER FROM "Order Date") AS Quarter,
SUM("Sales") AS Revenue
FROM customer
GROUP BY Year,Quarter
ORDER BY Year,Quarter;

-- Customer Analysis

-- Who are the Top 10 customers by revenue?
SELECT "Customer Name" , SUM("Sales") AS Revenue
FROM customer 
GROUP BY 1 
ORDER BY 2 DESC LIMIT 10;

-- Which customers are repeat buyers?
SELECT "Customer ID" , "Customer Name" , COUNT(DISTINCT "Order ID") AS Total_orders
FROM customer
GROUP BY 1,2
HAVING COUNT(DISTINCT "Order ID") > 1
ORDER BY 3 DESC;

-- Which customer segment generates the highest sales and profit?
SELECT "Segment" , SUM("Sales") as Revenue , SUM("Profit") as Profit
FROM customer 
GROUP BY 1
ORDER BY 2,3 DESC;

-- Product Analysis

-- Which are the Top 10 best-selling products?
SELECT "Product Name" , SUM("Sales") AS Revenue
FROM customer
GROUP BY 1
ORDER BY 2 DESC LIMIT 10;

-- Which products generate losses?
SELECT "Product Name" , SUM("Profit") AS Total_Loss 
FROM customer 
GROUP BY 1
HAVING SUM("Profit") < 0
ORDER BY Total_Loss;

-- Does discount reduce profitability?
SELECT "Discount" , Avg("Profit") AS Avg_profit , COUNT(*) AS Orders
FROM customer
GROUP BY 1
ORDER BY 1;

-- Shipping Analysis

-- Which shipping mode generates the highest sales and profit?
SELECT "Ship Mode" , SUM("Sales") AS Revenue , SUM("Profit") AS Profit
FROM customer 
GROUP BY 1
ORDER BY 2 DESC;

-- — Advanced SQL

-- Rank products based on total profit (Window Function)
SELECT "Product Name" , SUM("Profit") AS Profit ,
        RANK() OVER(ORDER BY SUM("Profit") DESC ) AS Product_rank
FROM customer 
GROUP BY 1;

-- Find the Top 3 products within each category (CTE + ROW_NUMBER)

WITH RankedProducts AS
(
SELECT "Category", "Product Name", SUM("Sales") AS Revenue,
ROW_NUMBER() OVER(PARTITION BY "Category" ORDER BY SUM("Sales") DESC) AS Rank_No
FROM customer
GROUP BY "Category","Product Name"
)

SELECT *
FROM RankedProducts
WHERE Rank_No <= 3;

-- What percentage of total revenue does each category contribute?
SELECT
"Category", SUM("Sales") AS Revenue, SUM("Sales") * 100.0 / (SUM(SUM("Sales")) OVER ()) AS Revenue_Percentage
FROM customer
GROUP BY "Category"
ORDER BY Revenue DESC;


