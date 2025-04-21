--1
select top 5 [EmployeeID], [FirstName], [LastName], [DepartmentName], [Salary], [HireDate], [Age], [Email], [Country] from employees
--2
SELECT DISTINCT ProductName
FROM Products;
--3
SELECT *
FROM Products
WHERE Price > 100;
--4
SELECT *
FROM Customers
WHERE firstname LIKE 'A%';
--5
SELECT *
FROM Products
ORDER BY Price ASC;
--6
SELECT *
FROM Employees
WHERE Salary >= 60000 AND Departmentname = 'HR';
--7
SELECT ISNULL(Email, 'noemail@example.com') AS Email
FROM Employees;
--8
SELECT *
FROM Products
WHERE Price BETWEEN 50 AND 100;
--9
SELECT DISTINCT Category, ProductName
FROM Products;
--10
SELECT DISTINCT Category, ProductName
FROM Products
ORDER BY ProductName DESC;
--11
SELECT TOP 10 *
FROM Products
ORDER BY Price DESC;
--12
SELECT COALESCE(FirstName, LastName) AS Name
FROM Employees;
--13
SELECT DISTINCT Category, Price
FROM Products;
--14
SELECT *
FROM Employees
WHERE (Age BETWEEN 30 AND 40)
   OR DepartmentName = 'Marketing';
--15
SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;
--16
SELECT *
FROM Products
WHERE Price <= 1000
  AND StockQuantity > 50
ORDER BY StockQuantity ASC;
--17
SELECT *
FROM Products
WHERE ProductName LIKE '%e%'
--18
SELECT *
FROM Employees
WHERE DepartmentName IN ('HR', 'IT', 'Finance');
--19
SELECT *
FROM Customers
ORDER BY City ASC, PostalCode DESC;
--20
SELECT TOP 10 *
FROM Sales
ORDER BY SaleAmount DESC;
--21
SELECT FirstName + ' ' + LastName AS FullName
FROM Employees;
--22
SELECT DISTINCT Category, ProductName, Price
FROM Products
WHERE Price > 50;
--23
SELECT *
FROM Products
WHERE Price < (SELECT AVG(Price) * 0.10 FROM Products);
--24
SELECT *
FROM Employees
WHERE Age < 30
  AND DepartmentName IN ('HR', 'IT');
--25
SELECT *
FROM Customers
WHERE Email LIKE '%@gmail.com';
--26
SELECT *
FROM Employees
WHERE Salary > ALL (SELECT Salary FROM Employees WHERE DepartmentName = 'Sales');
--27
SELECT *
FROM Orders
WHERE OrderDate BETWEEN CAST(GETDATE() - 180 AS DATE) AND CAST(GETDATE() AS DATE);
