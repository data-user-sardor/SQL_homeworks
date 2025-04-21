--1
SELECT ProductName AS Name
FROM Products;
--2
SELECT *
FROM Customers AS Client;
--3
SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;
--4
SELECT ProductName
FROM Products
INTERSECT
SELECT ProductName
FROM Products_Discounted;
--5
SELECT DISTINCT FirstName, Country
FROM Customers;
--6
SELECT ProductName, Price,
       CASE
           WHEN Price > 1000 THEN 'High'
           WHEN Price <= 1000 THEN 'Low'
       END AS PriceCategory
FROM Products;
--7
SELECT ProductName, StockQuantity,
       IIF(StockQuantity > 100, 'Yes', 'No') AS InStock
FROM Products_Discounted;
--8
SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM OutOfStock;
--9
SELECT ProductName
FROM Products
EXCEPT
SELECT ProductName
FROM Products_Discounted;
--10
SELECT ProductName, Price,
       IIF(Price > 1000, 'Expensive', 'Affordable') AS PriceTag
FROM Products;
--11
SELECT *
FROM Employees
WHERE Age < 25
   OR Salary > 60000;
--12
UPDATE Employees
SET Salary = Salary * 1.10
WHERE Departmentname = 'HR'
   OR EmployeeID = 5;
--13
SELECT ProductName
FROM Products
INTERSECT
SELECT ProductName
FROM Products_Discounted;
--14
SELECT SaleID, SaleAmount,
       CASE
           WHEN SaleAmount > 500 THEN 'Top Tier'
           WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
           ELSE 'Low Tier'
       END AS SaleCategory
FROM Sales;
--15
SELECT CustomerID
FROM Orders
EXCEPT
SELECT CustomerID
FROM Invoices;
--16
SELECT CustomerID, Quantity,
       CASE
           WHEN Quantity = 1 THEN '3%'
           WHEN Quantity > 1 AND Quantity <= 3 THEN '5%'
           ELSE '7%'
       END AS DiscountPercentage
FROM Orders;
