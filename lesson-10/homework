--1
SELECT E.Name, E.Salary, D.DepartmentName
FROM Employees AS E
INNER JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > 50000;

--2
SELECT C.FirstName, O.OrderDate
FROM Orders AS O
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
WHERE YEAR(O.OrderDate) = 2023;

--3
SELECT E.Name, D.DepartmentName
FROM Employees AS E
LEFT JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID;

--4
SELECT S.SupplierName, P.ProductName
FROM Suppliers AS S
LEFT JOIN Products AS P 
ON S.SupplierID = P.SupplierID;

--5
SELECT O.OrderID, O.OrderDate, P.PaymentDate, P.Amount
FROM Orders AS O
FULL OUTER JOIN Payments AS P
ON O.OrderID = P.OrderID;

--6
SELECT 
    E.Name AS Employee,
    E.Name AS Manager
FROM Employees E
LEFT JOIN Employees M 
ON  E.EmployeeID=M.ManagerID;

--7
SELECT S.Name,C.CourseName
FROM Enrollments AS E
INNER JOIN Students AS S
ON E.StudentID = S.StudentID
INNER JOIN Courses AS C
ON E.CourseID = C.CourseID
WHERE C.CourseName = 'Math 101';

--8
SELECT C.FirstName,C.LastName, SUM(O.Quantity) AS TotalQuantity
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName,C.LastName
HAVING SUM(O.Quantity) > 3;

--9
SELECT E.Name,D.DepartmentName
FROM Employees AS E
INNER JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Human Resources';

--10
SELECT D.DepartmentName, COUNT(E.EmployeeID) AS EmployeeCount
FROM Employees AS E
INNER JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName
HAVING COUNT(E.EmployeeID) > 5;

--11
SELECT P.ProductName
FROM Products AS P
LEFT JOIN Sales AS S
ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL;

--12
SELECT DISTINCT C.FirstName,C.LastName,O.Quantity AS TotalOrders
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID = O.CustomerID;

--13
SELECT E.Name, D.DepartmentName
FROM Employees AS E
INNER JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID;

--14
SELECT E1.Name AS Employee1, E2.Name AS Employee2, E1.ManagerID AS ManagerID
FROM Employees E1
JOIN Employees E2 
ON E1.ManagerID = E2.ManagerID AND E1.EmployeeID < E2.EmployeeID
WHERE E1.ManagerID IS NOT NULL;

--15
SELECT O.OrderID, O.OrderDate, C.FirstName, C.LastName
FROM Orders AS O
JOIN Customers AS C 
ON O.CustomerID = C.CustomerID
WHERE YEAR(O.OrderDate) = 2022;

--16
SELECT E.Name AS EmployeeName, E.Salary, D.DepartmentName
FROM Employees AS E
JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Sales'
AND E.Salary > 60000;

--17
SELECT O.OrderID, O.OrderDate,P.PaymentDate,P.Amount
FROM Orders AS O
JOIN Payments AS P 
ON O.OrderID = P.OrderID;

--18
SELECT P.ProductID,P.ProductName
FROM Products AS P
LEFT JOIN Orders AS O
ON P.ProductID = O.ProductID
WHERE O.OrderID IS NULL;

--19
SELECT Name, Salary
FROM Employees AS E
WHERE Salary > (SELECT AVG(Salary)FROM Employees
WHERE DepartmentID = E.DepartmentID);

--20
SELECT O.OrderID, O.OrderDate
FROM Orders AS O
LEFT JOIN Payments AS P 
ON O.OrderID = P.OrderID
WHERE O.OrderDate < '2020-01-01' AND P.OrderID IS NULL;

--21
SELECT P.ProductID, P.ProductName
FROM Products AS P
LEFT JOIN Categories AS C 
ON P.Category = C.CategoryID
WHERE C.CategoryID IS NULL;

--22
SELECT E1.Name AS Employee1, E2.Name AS Employee2, E1.ManagerID, E1.Salary
FROM Employees AS E1
JOIN Employees AS E2 
ON E1.ManagerID = E2.ManagerID AND E1.EmployeeID < E2.EmployeeID
WHERE E1.Salary > 60000 AND E2.Salary > 60000;

--23
SELECT E.Name, D.DepartmentName
FROM Employees AS E
INNER JOIN Departments AS D 
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName LIKE 'M%';

--24
SELECT S.SaleID, P.ProductName, S.SaleAmount
FROM Sales AS S
INNER JOIN Products AS P 
ON S.ProductID = P.ProductID
WHERE S.SaleAmount > 500;

--25
SELECT S.StudentID, S.Name
FROM Students AS S
WHERE NOT EXISTS (SELECT 1 FROM Enrollments E
JOIN Courses AS C ON E.CourseID = C.CourseID
WHERE E.StudentID = S.StudentID 
AND C.CourseName = 'Math 101'
);

--26
SELECT O.OrderID, O.OrderDate, P.PaymentID
FROM Orders AS O
LEFT JOIN Payments AS P 
ON O.OrderID = P.OrderID
WHERE P.PaymentID IS NULL;

--27
SELECT P.ProductID, P.ProductName, C.CategoryName
FROM Products AS P
JOIN Categories AS C 
ON P.Category = C.CategoryID
WHERE C.CategoryName IN ('Electronics', 'Furniture');
