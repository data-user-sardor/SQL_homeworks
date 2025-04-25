--1
SELECT MIN(price) AS MinPrice
FROM Products;

--2
SELECT MAX(Salary) AS MaxSalary
FROM Employees;

--3
SELECT COUNT(*) AS TotalCustomers
FROM Customers;

--4
SELECT COUNT(DISTINCT Category) AS UniqueCategoryCount
FROM Products;

--5
SELECT SUM(SalesAmount) AS TotalSales
FROM Sales
WHERE ProductID = 7;

--6
SELECT AVG(Age) AS AverageAge
FROM Employees;

--7
SELECT Departmentname, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Departmentname;

--8
SELECT Category, 
       MIN(Price) AS MinPrice, 
       MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;

--9
SELECT CustomerID, 
       SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID;

--10
SELECT Departmentname, 
       COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Departmentname
HAVING COUNT(*) > 5;

--11
SELECT ProductID, 
       SUM(SaleAmount) AS TotalSales, 
       AVG(SaleAmount) AS AverageSales
FROM Sales
GROUP BY ProductID;
--12
SELECT COUNT(*) AS HR_EmployeeCount
FROM Employees
WHERE Departmentname = 'HR';

--13
SELECT Departmentname, 
       MAX(Salary) AS MaxSalary, 
       MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Departmentname;

--14
SELECT Departmentname, 
       AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Departmentname

--15
SELECT Departmentname, 
       AVG(Salary) AS AverageSalary, 
       COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Departmentname;

--16
SELECT Category, 
       AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;
--17
SELECT YEAR(SaleDate) AS SaleYear, 
       SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate);
--18 

--19
SELECT DepartmentName, 
       SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentName
HAVING SUM(Salary) > 500000;

--20
SELECT ProductID, 
       AVG(SaleAmount) AS AverageSales
FROM Sales
GROUP BY ProductID
HAVING AVG(SaleAmount) > 200;

--21
SELECT CustomerID, 
       SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount) > 1500;

--22
SELECT Departmentname, 
       SUM(Salary) AS TotalSalary, 
       AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Departmentname
HAVING AVG(Salary) > 65000;

--23
SELECT CustomerID, 
       MAX(TotalAmount) AS MaxOrderValue, 
       MIN(TotalAmount) AS MinOrderValue
FROM Orders
GROUP BY CustomerID
HAVING MAX(TotalAmount) >= 50;

--24
SELECT MONTH(SaleDate) AS SaleMonth, 
       SUM(SaleAmount) AS TotalSales, 
       COUNT(DISTINCT ProductID) AS DistinctProductsSold
FROM Sales
GROUP BY MONTH(SaleDate)
HAVING COUNT(DISTINCT ProductID) > 8;

--25
SELECT YEAR(OrderDate) AS OrderYear,
       MIN(Quantity) AS MinOrderQuantity,
       MAX(Quantity) AS MaxOrderQuantity
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;
