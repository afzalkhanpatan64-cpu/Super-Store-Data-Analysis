select * from orders;

ANALYSIS 1: SALES ANALYSIS
------------------------------------------------------------------------------------------------------------------------------------------
1.TOTAL SALE BY REGION
SELECT region,
SUM(sales) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

2.TOTAL SALES BY STATE
SELECT state, 
SUM(sales) AS total_sales
FROM orders
GROUP BY state
ORDER BY total_sales DESC;

3.TOTAL SALES BY CATEGORY
SELECT category,
SUM(sales) AS total_sales
FROM orders
GROUP BY category
ORDER BY total_sales DESC;

4.TOP 10 CUSTOMER BY SALES
SELECT customer_name,
SUM(sales) AS total_sales
FROM orders
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

5.TOP 10 PRODUCT BY SALES
SELECT product_name,
SUM(sales) AS total_sales
FROM orders
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;
---------------------------------------------------------------------------------------------------------------------------------
PROFIT ANALYSIS
--------------------------------------------------------------------------------------------------------------------------------
1.TOTAL PROFIT BY REGION
SELECT region, 
SUM(profit) AS total_profit
FROM orders
GROUP BY region 
ORDER BY total_profit DESC;

2.TOTAL PROFIT BY CATEGORY
SELECT category,
SUM(profit) AS total_profit
FROM orders
GROUP BY category
ORDER BY total_profit DESC;

3.TOTAL PROFIT BY STATE
SELECT state,
SUM(profit) AS total_profit
FROM orders
GROUP BY state
ORDER BY total_profit DESC;

4.TOP 10 CUSTOMERS BY PROFIT
SELECT customer_name,
SUM(profit) AS total_profit
FROM orders
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;

5.TOP 10 PRODUCTS BY PROFIT
SELECT product_name,
SUM(profit) AS total_profit
FROM orders
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

6.LOSS MAKING PRODUCTS
SELECT product_name,
SUM(profit) AS total_profit
FROM orders
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

-----------------------------------------------------------------------------------------------------------------------------------------
BASIC CUSTOMER SEGMENT ANALYSIS:
-----------------------------------------------------------------------------------------------------------------------------------------------
PROBLEM 1: WHICH CUSTOMER SEGMENT GEANRATES THE HIGHEST TOTAL SALES AND PROFIT?

SELECT segment,
SUM(sales) AS total_sales,
SUM(profit) AS total_profit
FROM orders
GROUP BY segment
ORDER BY total_sales DESC, total_profit DESC;

PROBLEM 2: WHICH CUSTOMER SEGMENT HAS THE HIGHEST AVERAGE PROFIT PER ORDER?

SELECT segment,
AVG(profit) AS avg_profit FROM orders
GROUP BY segment ORDER BY avg_profit DESC;

PROBLEM 3: WHICH CUSTOMER SEGMENT HAS PLACED THE HIGHEST NUM OF ORDERS?

SELECT segment, 
 COUNT(*) AS total_orders FROM orders
 GROUP BY segment ORDER BY total_orders DESC;

PROBLEM 4: WHICH CUSTOMER SEGMENT HAS THE HIGHEST AVERAGE SALES PER ORDER?

SELECT segment,
AVG(SALES) AS avg_sales
FROM orders
GROUP BY segment ORDER BY avg_sales DESC;

--PROBLEM 5: WHICH CUSTOMMER SEGMENT HAS SOLD THE HIGHEST TOTAL QUANTITY OF PRODUCTS?

SELECT segment, 
SUM(quantity) AS total_quantity
FROM orders
GROUP BY segment ORDER BY total_quantity DESC;

--PROBLEM 6: WHICH CUSTOMER SEGMENT RECEIVE THE HIGHEST AVERAGE PROFIT?

SELECT segment, 
AVG(discount) AS avg_discount FROM orders
GROUP BY segment ORDER BY avg_discount DESC;
-------------------------------------------------------------------------------------------------------------------------------------
ADVANCED CUSTOMER SEGMENT ANALYSIS:
---------------------------------------------------------------------------------------------------------------------------------------------
--PROBLEM 1:
--BUSINESS SCENORIO
--THE COMPANY WANTS TO CLASSIFY ITS CUSTOMER SEGMENT BASED ON TOTAL SALES PERFORMANCE SO THAT CAN PLAN DIFFERENT STRATEGY?\

SELECT segment, SUM(sales) AS total_sales,
CASE
WHEN SUM(sales) > 700000 THEN 'Highest Sales'
WHEN SUM(sales) BETWEEN 500000 AND 699999 THEN 'Median Sales'
ELSE 'Lowest Sales'
END AS sale_category
FROM orders
GROUP BY segment
ORDER BY total_sales DESC;

PROBLEM 2: RANK THE CUSTOMER SEGMENT BASED ON THEIR TOTAL SALES FROM HIGHEST TO LOWEST 

SELECT SEGMENT , SUM(sales) AS total_sales,
RANK() OVER(ORDER BY SUM(sales) DESC) AS segment_rank
FROM orders
GROUP BY segment 
ORDER BY segment_rank;

PROBLEM 3: THE MANAGEMENT WANTS TO IDENTIFY ONLY  THE CUSTOMER SEGMENT

WITH segment_sale AS (
SELECT segment, 
SUM(sales) AS total_sales
FROM orders
GROUP BY segment
)
SELECT * FROM segment_sale
WHERE total_sales > 500000
ORDER BY total_sales DESC;

PROBLEM 4: FIND THE CUSTOMER SEGMENTS WHOSE TOTAL SALES ARE GREATER THAN THE AVERAGE TOTAL SALES OF ALL CUSTOMER SEGMENTS?

SELECT segment,
SUM(sales) AS total_sales
FROM orders
GROUP BY segment
HAVING SUM(sales) >
( SELECT AVG(total_sales)
  FROM
  (SELECT segment,
   SUM(sales) AS total_sales
   FROM orders
   GROUP BY segment
   ) AS segment_totals);
---------------------------------------------------------------------------------------------------------------------------------------------
REGIONAL ANALYSIS - BASIC BUSINESS ANALYSIS:
--------------------------------------------------------------------------------------------------------------------------------------
PROBLEM 1: WHICH REGION GENARATES THE HIGHEST TOTAL SALES AND TOTAL PROFIT FOR THE COMPANY?

SELECT region,
SUM(sales) AS total_sales,
SUM(profit) AS total_profit
FROM orders
GROUP BY region
ORDER BY total_sales DESC, total_profit DESC;

PROBLEM 2: WHICH REGION HAS THE HIGHEST AVERAGE PROFIT PER ORDER?

SELECT region,
AVG(profit) AS avg_profit
FROM orders
GROUP BY region
ORDER BY avg_profit DESC;

PROBLEM 3: WHICH REGION HAS THE HIGHEST NUMBER OF ORDERS?

SELECT region,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY region
ORDER BY total_orders DESC;

PROBLEM 4: WHICH REGION HAS THE HIGHEST AVERAGE SALES PER ORDER

SELECT region, 
AVG(sales) AS avg_sales
FROM orders
GROUP BY region
ORDER BY avg_sales DESC;
   
PROBLEM 5: WHICH REGION SOLD THE HIGHEST TOTAL QUANTITY OF PRODUCTS?

SELECT region,
SUM(quantity) AS total_quantity 
FROM orders
GROUP BY region
ORDER BY total_quantity DESC;

PROBLEM 6: WHICH REGION OFFERS THE HIGHEST AVERAGE DISCOUNT TO CUSTOMERS?

SELECT region,
AVG(discount) AS avg_dis
FROM orders 
GROUP BY region 
ORDER BY avg_dis DESC;

---ADVANCED BUSINESS ANALYSIS
PROBLEM 1: CLASSIFY EACH REGION BASED ON TOTAL SALES.

SELECT region,
SUM(sales) AS total_sales,
CASE
WHEN SUM(sales) >= 700000 THEN 'High Sales'
WHEN SUM(sales) BETWEEN 500000 AND 699999 THEN 'Median Sales'
ELSE 'Low Sales'
END AS sales_category
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

PROBLEM 2: RANK THE REGION BASED ON TOTAL SALES FROM HIGHEST TO LOWEST?

SELECT region,
SUM(sales) AS total_sales,
RANK() OVER(ORDER BY SUM(sales) DESC) AS sales_segment
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

PROBLEM 3: MANAGEMENT WANTS TO IDENTIFY ONLY THOSE  REGION WHOSE TOTAL SALES ARE GREATER THAN 500000?

WITH region_sales AS (SELECT region, SUM(sales) AS total_sales FROM orders GROUP BY region)
SELECT * FROM region_sales
WHERE total_sales > 500000
ORDER BY total_sales DESC;

PROBLEM 4: FIND THE REGION WHOSE TOTAL SALES ARE GREATER THAN THE AVERAGE TOTAL SALES OF ALL REGIONS?

SELECT region,
SUM(sales) AS total_sales
FROM orders
GROUP BY region
HAVING SUM(sales) > ( SELECT AVG(total_sales) FROM (SELECT region, SUM(sales) AS total_sales FROM orders GROUP BY region) AS region_totals)
ORDER BY total_sales DESC;
--------------------------------------------------------------------------------------------------------------------------------------------
CATEGORY ANALYSIS
--------------------------------------------------------------------------------------------------------------------------------------------
PROBLEM 1: WHICH PRODUCT CATEGORY GENARATED THE HIGHEST TOTAL SALES AND TOTAL PROFIT?

SELECT category,
SUM(sales) AS total_sales,
SUM(profit) AS total_profit
FROM orders
GROUP BY category
ORDER BY total_sales DESC, total_profit DESC;

PROBLEM 2: CLASSIFY EACH CATEGORY BASED ON TOTAL PROFIT

SELECT category, 
SUM(profit) AS total_profit,
CASE
WHEN SUM(profit) >= 130000 THEN 'High Profit'
WHEN SUM(profit) BETWEEN 50000 AND 129999 THEN 'Medium Profit'
ELSE 'Low Sales'
END AS profit_category
GROUP BY category
ORDER BY total_profit DESC;

PROBLEM 3: RANK THE PRODUCT CATEGORIES BASED ON TOTAL PROFIT FROM HIGHEST TO LOWEST

SELECT category,
SUM(profit) AS total_profit,
RANK() OVER(ORDER BY SUM(profit) DESC) AS profit_rank
FROM orders
GROUP BY category
ORDER BY profit_rank;

PROBLEM 4: FIND THE CATEGORIES WHOSE TOTAL PROFIT IS GREATER THAN THE AVARAGE TOTAL PROFIT OF ALL CATEGORIES

SELECT category,
SUM(profit) AS total_profit
FROM orders
GROUP BY category
HAVING SUM(profit) > (SELECT AVG(total_profit) FROM (SELECT category, SUM(profit) AS total_profit FROM orders
GROUP BY category
)) ORDER BY total_profit;
------------------------------------------------------------------------------------------------------------------------------------
SUB CATEGORY ANALYSIS
------------------------------------------------------------------------------------------------------------------------------------
PROBLEM 1: WHICH ARE THE TOP 5 SUB_CATEGORIES BASED ON TOTAL SALES?

SELECT sub_category,
SUM(sales) AS total_sales
FROM orders
GROUP BY sub_category
ORDER BY total_sales DESC
LIMIT 5;

PROBLEM 2: RANK ALL SUB_CATEGORIES BASED ON TOTAL PROFIT FROM HIGHEST TO LOWEST

SELECT sub_category,
SUM(profit) AS total_profit,
RANK() OVER(ORDER BY SUM(profit) DESC) AS sub_category_rank
GROUP BY sub_category
ORDER BY sub_category_rank DESC;







