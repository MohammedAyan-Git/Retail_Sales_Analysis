--RETAIL SALES ANALYSIS(SQL PROJECT)
--CREATE DATABASE
CREATE DATABASE Retail_sales;

--CREATE TABLE
DROP TABLE IF EXISTS Retailsales;
CREATE TABLE Retailsales(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(10),
		age INT,
		category VARCHAR(20),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
);
SELECT * FROM Retailsales;

--IMPORT DATA FROM CSV
--STEP1 (DATA CLEANING)
--CHECK WHETHER IS THERE ANY NULL VALUES IN THE RECORDS 
--FOR EACH COLUMN
SELECT * FROM Retailsales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

--DELETE THE RECORDS HAVING NULL VALUES
DELETE FROM Retailsales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
SELECT COUNT(*) FROM Retailsales;--3ROWS DELETED

--STEP2 (DATA EXPLORATION)

--HOW MANY SALES WE HAVE
SELECT COUNT(total_sale) AS total_sales FROM Retailsales;

--HOW MANY unique CUSTOMERS WE HAVE
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM Retailsales;

--HOW MANY CATEGORIES WE HAVE
SELECT COUNT(DISTINCT category) FROM Retailsales;--for category count
SELECT DISTINCT category FROM Retailsales;--for category name

--STEP3 (DATA ANALYSIS OR BUSINESS PROBLEMS)

--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT *FROM Retailsales
WHERE Sale_date='2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
SELECT * FROM RETAILSALES
WHERE
	CATEGORY = 'Clothing'
	AND QUANTITY >= 4
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11';

--3.Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS NET_SALES,
	COUNT(*) AS TOTAL_ORDERS
FROM
	RETAILSALES
GROUP BY
	CATEGORY;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(AGE), 2) AS AVERAGE_AGE
FROM
	RETAILSALES
WHERE
	CATEGORY = 'Beauty';


--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT transactions_id,total_sale FROM Retailsales
WHERE total_sale>1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(transactions_id) AS total_transactions FROM Retailsales
GROUP BY category,gender
ORDER BY 1;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT year,month,avg_sale
FROM(
	SELECT
		EXTRACT (YEAR FROM sale_date) AS year,
		EXTRACT (MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	FROM Retailsales
	GROUP BY 1,2
) AS TABLE1
WHERE rank=1;

--8.Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id, SUM(total_sale) AS total_sales
FROM Retailsales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS total_customers
FROM Retailsales
GROUP BY 1;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
WITH hourly_sales
AS
(SELECT *,
	CASE 
	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
	END AS Shift
FROM Retailsales
)
SELECT shift,
		COUNT(transactions_id)
FROM hourly_sales
GROUP BY shift;

--END OF RETAIL SALES ANALYSIS

