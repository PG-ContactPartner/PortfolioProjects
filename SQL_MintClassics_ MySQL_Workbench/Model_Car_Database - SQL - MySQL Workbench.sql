-- 1. Database “mintclassics” exploration
USE mintclassics;
SELECT 
	orders.orderNumber, 
	customers.customerName, 
    orders.orderDate, 
    products.productName,
    products.productCode,
    products.productLine,
    products.buyPrice,
    products.quantityInStock, 
    orderdetails.quantityOrdered, 
    orderdetails.priceEach,
    (orderdetails.quantityOrdered * orderdetails.priceEach) AS TotalOrder,
    payments.paymentDate,
    orders.shippedDate,
    timestampdiff(day, orders.orderDate, orders.shippedDate) AS LeadTime,
    concat(employees.firstName, " ",  employees.lastName) AS "SalesRep",
    offices.country AS Country
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
    JOIN warehouses ON products.warehouseCode = warehouses.warehouseCode
    JOIN orderdetails ON products.productCode = orderdetails.productCode
    JOIN orders ON orders.orderNumber = orderdetails.orderNumber
    JOIN customers ON customers.customerNumber = orders.customerNumber
    JOIN payments ON customers.customerNumber = payments.customerNumber
    JOIN employees ON employees.employeeNumber = customers.salesRepEmployeeNumber
    JOIN offices ON offices.officeCode = employees.officeCode
ORDER BY orders.orderdate ASC;


-- 2. Exploring distinct products and warehouses

-- 2.1 - 110 distinct products

SELECT COUNT(products.productCode) as products
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
    JOIN warehouses ON products.warehouseCode = warehouses.warehouseCode;

-- 2.2 - Warehouses

SELECT DISTINCT
	warehouses.warehouseCode,
	(warehouses.warehouseName) AS Warehouse
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
    JOIN warehouses ON products.warehouseCode = warehouses.warehouseCode;
    
-- 2.3 - Products total stock - 555131 pieces

SELECT SUM(products.quantityInStock) AS products_total_stock
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
    JOIN warehouses ON products.warehouseCode = warehouses.warehouseCode;

-- 3 - Determine which products sell the most/least

-- 3.1 - Which products have the most number of orders?

SELECT productName, COUNT(orderNumber) AS total_orders
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY productName
ORDER BY total_orders DESC;

-- 3.2 - Which products have the least number of orders?

SELECT productName, COUNT(orderNumber) AS total_orders
FROM products
	JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY productName
ORDER BY total_orders ASC;

-- 3.3 - Which product lines had the highest sales in terms of both number of pieces sold and their value? 

		-- Number of Pieces
SELECT products.productLine, SUM(quantityOrdered) AS total_units_sold
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
	JOIN orderdetails ON products.productCode = orderdetails.productCode
	JOIN orders ON orders.orderNumber = orderdetails.orderNumber
GROUP BY products.productLine
ORDER BY total_units_sold DESC;

		-- Value
SELECT products.productLine, SUM(amount) AS total_value
FROM products
	JOIN orderdetails ON products.productCode = orderdetails.productCode
	JOIN orders ON orders.orderNumber = orderdetails.orderNumber
    JOIN customers ON orders.customerNumber = customers.customerNumber
    JOIN payments ON customers.customerNumber = payments.customerNumber
GROUP BY products.productLine
ORDER BY total_value DESC;

-- 3.4 - Which product lines generated a lower total value of sales?

SELECT products.productLine, SUM(amount) AS total_value
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
	JOIN orderdetails ON products.productCode = orderdetails.productCode
	JOIN orders ON orders.orderNumber = orderdetails.orderNumber
    JOIN customers ON customers.customerNumber = orders.customerNumber
    JOIN payments ON payments.customerNumber = customers.customerNumber
GROUP BY products.productLine
ORDER BY total_value ASC;

-- 3.5 - Which products generated a lower total value of sales?

SELECT products.productCode, products.productName, SUM(amount) AS total_value
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
	JOIN orderdetails ON products.productCode = orderdetails.productCode
	JOIN orders ON orders.orderNumber = orderdetails.orderNumber
    JOIN customers ON customers.customerNumber = orders.customerNumber
    JOIN payments ON payments.customerNumber = customers.customerNumber
GROUP BY 1, 2
ORDER BY total_value ASC;


-- 4. - Inventory versus Sales

-- 4.1 - Which products have high inventory but low sales?

USE mintclassics;
SELECT 
	productCode,
	productName,
    productLine,
    quantityInStock,
    totalOrdered,
	(quantityInStock - totalOrdered) AS inventory
    FROM
		(SELECT
			pr.productCode,
			pr.productName,
            pr.productLine,
			pr.quantityInStock,
            SUM(ord.quantityOrdered) AS totalOrdered
		FROM mintclassics.products AS pr
		LEFT JOIN mintclassics.orderdetails AS ord ON pr.productCode = ord.productCode
        GROUP BY
			pr.productCode,
			pr.productName,
			pr.quantityInStock
   		) AS inventoryData
WHERE (quantityInStock - totalOrdered) > 0
ORDER BY inventory DESC;

-- 4.2 - Which products have inventory shortage but high sales?

USE mintclassics;
SELECT 
	productCode,
    productName,
    productLine,
    quantityInStock,
    totalOrdered,
    (quantityInStock - totalOrdered) AS inventory
FROM 
	(SELECT
		pr.productCode,
		pr.productName,
		pr.productLine,
		pr.quantityInStock,
        SUM(ord.quantityOrdered) AS TotalOrdered
	FROM mintclassics.products AS pr
    LEFT JOIN orderdetails AS ord ON pr.productCode = ord.productCode
    GROUP BY 
		pr.productCode,
		pr.productName,
		pr.productLine,
		pr.quantityInStock
	) AS inventoryData
WHERE (quantityInStock - totalOrdered) < 0
ORDER BY inventory ASC;


-- 5. - Review inventory

-- 5.1 - Warehouses total inventory

USE mintclassics;
SELECT 
	warehouses.warehouseCode, 
	warehouses.warehouseName, 
    SUM(products.quantityInStock) AS totalInventory
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
    JOIN warehouses ON products.warehouseCode = warehouses.warehouseCode
GROUP BY 1
ORDER BY 3 DESC;

-- 5.2 - Warehouse inventory by product

USE mintclassics;
SELECT
	products.productCode,
	products.productName, 
	warehouses.warehouseCode,
	warehouses.warehouseName, 
	SUM(products.quantityInStock) AS stock
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
    JOIN warehouses ON products.warehouseCode = warehouses.warehouseCode
GROUP BY 1, 2, 3 
ORDER BY 5 ASC;

-- 5.3 - Warehouses inventory by product line
 
SELECT
	productlines.productLine,
	warehouses.warehouseCode,
    warehouses.warehouseName, 
	SUM(products.quantityInStock) AS inventory
FROM products
	JOIN productlines ON products.productLine = productlines.productLine
    JOIN warehouses ON products.warehouseCode = warehouses.warehouseCode
GROUP BY 1, 2
ORDER BY 4 DESC;

-- 6. Which products can be dropped out?

-- 6.1. Products Inventory To Sales Ratio

	-- Inventory to Sales Ratio = (Inventory Level) / (Net Sales) --

-- Year 2003
USE mintclassics;
SELECT
	products.productCode,
    products.productName,
    products.productLine,
    SUM(products.quantityInStock) AS Inventory,
    SUM(orderdetails.quantityOrdered) AS quantitySold,
    SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS netSales,
    (SUM(products.quantityInStock)/SUM(orderdetails.priceEach * orderdetails.quantityOrdered)) AS InventoryToSalesRatio
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
WHERE YEAR(orders.orderDate) <> 2004 AND YEAR(orders.orderDate) <> 2005 -- YEAR 2003
GROUP BY 1, 3
ORDER BY 7 ASC;

-- Year 2004
USE mintclassics;
SELECT
	products.productCode,
    products.productName,
    products.productLine,
    SUM(products.quantityInStock) AS Inventory,
    SUM(orderdetails.quantityOrdered) AS quantitySold,
    SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS netSales,
    (SUM(products.quantityInStock)/SUM(orderdetails.priceEach * orderdetails.quantityOrdered)) AS InventoryToSalesRatio
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
WHERE YEAR(orders.orderDate) <> 2003 AND YEAR(orders.orderDate) <> 2005 -- YEAR 2004
GROUP BY 1, 3
ORDER BY 7 DESC;

-- 6.2 Product Lines Inventory to Sales Ratio

-- Year 2003
USE mintclassics;
SELECT
    products.productLine,
    SUM(products.quantityInStock) AS Inventory,
    SUM(orderdetails.quantityOrdered) AS quantitySold,
    SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS netSales,
    (SUM(products.quantityInStock)/SUM(orderdetails.priceEach * orderdetails.quantityOrdered)) AS InventoryToSalesRatio
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
WHERE YEAR(orders.orderDate) <> 2004 AND YEAR(orders.orderDate) <> 2005 -- YEAR 2003
GROUP BY 1
ORDER BY 5 ASC;

-- Year 2004
USE mintclassics;
SELECT
    products.productLine,
    SUM(products.quantityInStock) AS Inventory,
    SUM(orderdetails.quantityOrdered) AS quantitySold,
    SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS netSales,
    (SUM(products.quantityInStock)/SUM(orderdetails.priceEach * orderdetails.quantityOrdered)) AS InventoryToSalesRatio
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
WHERE YEAR(orders.orderDate) <> 2003 AND YEAR(orders.orderDate) <> 2005 -- YEAR 2004
GROUP BY 1
ORDER BY 5 ASC;