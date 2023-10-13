USE sample_data

SELECT * FROM geo;
SELECT * FROM people;
SELECT * FROM products;
SELECT * FROM sales;

-- Q1. Print details of sales where amounts are > 2,000 and boxes are < 100

SELECT *
FROM sample_data.sales
WHERE Amount > 2000 AND Boxes < 100
ORDER BY SaleDate;

-- Q2. How many sales did each of the salespersons have in January 2022?

USE sample_data

SELECT
	p.Salesperson, 
    SUM(s.Boxes) AS TotalBoxes,
	SUM(s.Amount) AS TotalSales
FROM sales s
	RIGHT JOIN people p
    ON s.SPID = p.SPID
WHERE YEAR(s.SaleDate) = 2022 AND MONTH(s.SaleDate) = 01
GROUP BY p.Salesperson
ORDER BY TotalSales DESC;

-- Q3. Which product sells more boxes?

USE sample_data

SELECT 
	p.Product,
    SUM(s.Boxes) AS TotalBoxes
FROM products AS p
	JOIN sales AS s
		ON p.PID = s.PID
GROUP BY p.Product
ORDER BY TotalBoxes DESC;

-- Q4. Which product sold more boxes in the first 7 days of February 2022?

USE sample_data

SELECT 
	pr.Product,
       SUM(s.Boxes) AS TotalBoxesSold
FROM products pr
	JOIN sales s
		ON pr.PID = s.PID
WHERE YEAR(s.SaleDate) = 2022 AND MONTH(s.SaleDate) = 02 AND DAY(s.SaleDate) BETWEEN 01 AND 07
GROUP BY pr.Product
ORDER BY TotalBoxesSold DESC;
    
-- Q5. Which sales had under 100 customers & 100 boxes? Did any of them occur on Wednesday?

SELECT *,
	CASE WHEN Customers < 100 AND Boxes < 100 AND WEEKDAY(SaleDate) = 2 THEN "OK"
    ELSE "Not OK"
    END AS "Result"
FROM sales
ORDER BY Result DESC;


    
