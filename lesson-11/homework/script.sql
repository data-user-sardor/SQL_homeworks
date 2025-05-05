--1-task:Show all orders placed after 2022 along with the names of the customers who placed them.
SELECT 
	O.OrderID, 
	C.FirstName,
	C.LastName,
	O.OrderDate 
FROM Orders AS O
INNER JOIN Customers AS C
ON O.CustomerID=C.CustomerID
WHERE O.OrderDate>'2022-12-31'

--2-task:Display the names of employees who work in either the Sales or Marketing department.
SELECT 
	E.Name 
FROM Employees AS E
JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('Sales', 'Marketing');

--3-task:Show the highest salary for each department.
SELECT 
	D.DepartmentName, 
	MAX(E.Salary)AS MaxSalary 
FROM Departments AS D
LEFT JOIN Employees AS E
ON D.DepartmentID=E.DepartmentID
GROUP BY DepartmentName

--4-task:List all customers from the USA who placed orders in the year 2023.
SELECT 
	C.FirstName, 
	C.LastName, 
	O.OrderID, 
	O.OrderDate 
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID=O.CustomerID
WHERE 
	C.Country = 'USA' 
	AND Year(O.OrderDate)=2023;

--5-task:Show how many orders each customer has placed.
SELECT 
    C.FirstName, 
	COUNT(O.OrderID) AS TotalOrders 
FROM Customers AS C
LEFT JOIN Orders AS O 
ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName;

--6-task:Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.
SELECT 
	P.ProductName, 
	S.SupplierName
FROM Products AS P
JOIN Suppliers AS S 
ON P.SupplierID = S.SupplierID
WHERE S.SupplierName IN ('Gadget Supplies', 'Clothing Mart');

--7-task:For each customer, show their most recent order. Include customers who haven't placed any orders.
SELECT 
	C.FirstName, 
	MAX(O.OrderDate) AS MostRecentOrderDate 
FROM Customers AS C
LEFT JOIN Orders AS O 
ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName;

--8-task:Show the customers who have placed an order where the total amount is greater than 500.
SELECT C.FirstName,O.TotalAmount
FROM Orders AS O
JOIN Customers AS C ON O.CustomerID = C.CustomerID
WHERE O.TotalAmount > 500;

--9-task:List product sales where the sale was made in 2022 or the sale amount exceeded 400.
SELECT 
    P.ProductName,
    S.SaleDate,
    S.SaleAmount
FROM Sales AS S
JOIN Products AS P
ON S.ProductID = P.ProductID
WHERE 
	YEAR(S.SaleDate) = 2022 
	OR S.SaleAmount > 400;

--10-task:Display each product along with the total amount it has been sold for.
SELECT 
    P.ProductName,
    SUM(S.SaleAmount) AS TotalSalesAmount
FROM Sales AS S
JOIN Products AS P 
ON S.ProductID = P.ProductID
GROUP BY P.ProductName;

--11-task:Show the employees who work in the HR department and earn a salary greater than 60000.
SELECT 
    E.Name,
    D.DepartmentName,
    E.Salary
FROM Employees AS E
LEFT JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
WHERE 
	D.DepartmentName ='Human Resources' 
	AND E.Salary > 60000;

--12-task:List the products that were sold in 2023 and had more than 100 units in stock at the time.
SELECT 
    P.ProductName,
    S.SaleDate,
    P.StockQuantity
FROM Sales AS S
JOIN Products AS P
ON S.ProductID = P.ProductID
WHERE 
	YEAR(S.SaleDate) = 2023 
	AND P.StockQuantity > 100;

--13-task:Show employees who either work in the Sales department or were hired after 2020.
SELECT 
    E.Name,
    D.DepartmentName,
    E.HireDate
FROM Employees AS E
JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
WHERE 
	D.DepartmentName = 'Sales'
	OR E.HireDate > '2020-01-01';

--14-task:List all orders made by customers in the USA whose address starts with 4 digits.
SELECT 
    C.FirstName,
    O.OrderID,
    C.Address,
    O.OrderDate
FROM Customers AS C
JOIN Orders AS O
ON C.CustomerID = O.CustomerID
WHERE 
	C.Country = 'USA'
	AND C.Address LIKE '____%'  -- Address starts with 4 digits

--15-task:Display product sales for items in the Electronics category or where the sale amount exceeded 350.
SELECT 
    P.ProductName,
    P.Category,
    S.SaleAmount
FROM Sales AS S
JOIN Products AS P
ON S.ProductID = P.ProductID
WHERE 
    P.Category = 'Electronics'
    OR S.SaleAmount > 350;

--16-task:Show the number of products available in each category.
SELECT 
    C.CategoryName,
    COUNT(P.ProductID) AS ProductCount
FROM Categories AS C
LEFT JOIN Products AS P
ON C.CategoryID = P.Category
GROUP BY C.CategoryName;

--17-task:List orders where the customer is from Los Angeles and the order amount is greater than 300.
SELECT 
    C.FirstName,
	C.LastName,
    C.City,
    O.OrderID,
    O.TotalAmount
FROM Customers AS C
JOIN Orders AS O
ON C.CustomerID = O.CustomerID
WHERE 
    C.City = 'Los Angeles'
    AND O.TotalAmount > 300;

--18-task:Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.
SELECT 
    E.Name,
    D.DepartmentName
FROM Employees AS E
JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
WHERE 
    D.DepartmentName IN ('Human Resources', 'Finance')

--19-task:Show employees who are in the Sales or Marketing department and have a salary above 60000.
SELECT 
    E.Name,
    D.DepartmentName,
    E.Salary
FROM Employees AS E
JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
WHERE 
    D.DepartmentName IN ('Sales', 'Marketing')
    AND E.Salary > 60000;
