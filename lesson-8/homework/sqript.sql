--1
SELECT Category, COUNT(*) AS TotalProducts
FROM Products
GROUP BY Category;

--2
SELECT AVG(Price) AS AveragePrice
FROM Products
WHERE Category = 'Electronics';

--3
SELECT * FROM Customers
WHERE City LIKE 'L%';

--4
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%er';

--5
SELECT * 
FROM Customers
WHERE Country LIKE '%A';

--6
SELECT MAX(Price) AS HighestPrice
FROM Products;

--7
SELECT ProductName,
       IIF(StockQuantity < 30, 'Low Stock', 'Sufficient') AS StockStatus
FROM Products;

--8
FROM Customers
GROUP BY Country;

--9
SELECT MIN(Quantity) AS 'MIN_Order',
	   MAX(Quantity) AS 'MAX_Order'
FROM Orders;

--10
FROM Orders
WHERE YEAR(OrderDate) = 2023
EXCEPT
SELECT DISTINCT CustomerID
FROM Invoices;

--11
SELECT ProductName
FROM Products
UNION ALL
SELECT ProductName
FROM Products_Discounted;

--12
SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;

--13
SELECT YEAR(OrderDate) AS OrderYear, AVG(Quantity) AS AverageOrderAmount
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

--14
SELECT ProductName,
       CASE 
           WHEN Price < 100 THEN 'Low'
           WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
           ELSE 'High'
       END AS PriceGroup
FROM Products
ORDER BY Price DESC;

--15
SELECT DISTINCT City
FROM Customers
ORDER BY City;

--16
SELECT ProductID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

--17
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%oo%';

--18
SELECT ProductID
FROM Products
INTERSECT
SELECT ProductID
FROM Products_Discounted;

--19
SELECT TOP 3 CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

--20
SELECT ProductID, ProductName
FROM Products
EXCEPT
SELECT ProductID, ProductName
FROM Products_Discounted;

--21

--22
SELECT TOP 5 ProductID, SUM(Quantity) AS TotalQuantity
FROM Orders
GROUP BY ProductID
ORDER BY TotalQuantity DESC;
