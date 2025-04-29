--1.Using Products, Suppliers table List all combinations of product names and supplier names.
SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
CROSS JOIN Suppliers;

--2. Using Departments, Employees table Get all combinations of departments and employees.
SELECT Departments.DepartmentName, Employees.Name
FROM Departments
CROSS JOIN Employees;

--3. Using Products, Suppliers table List only the combinations where the supplier actually supplies the product. Return supplier name and product name
SELECT P.ProductName, S.SupplierName
FROM Products as P
INNER JOIN Suppliers as S
ON P.SupplierID = S.SupplierID;

--4. Using Orders, Customers table List customer names and their orders ID.
SELECT C.FirstName, O.OrderID
FROM Orders as O
INNER JOIN Customers as c
ON O.CustomerID = C.CustomerID;

--5. Using Courses, Students table Get all combinations of students and courses.
SELECT S.Name, C.CourseName
FROM Students AS s
CROSS JOIN Courses AS c;

--6. Using Products, Orders table Get product names and orders where product IDs match.
SELECT P.Productname, O.OrderID
FROM Products as P
INNER JOIN Orders as O
ON P.ProductID = O.ProductID;

--7. Using Departments, Employees table List employees whose DepartmentID matches the department.
SELECT E.Name,D.DepartmentName
FROM Employees as E
INNER JOIN Departments as D
ON E.DepartmentID = D.DepartmentID;

--8. Using Students, Enrollments table List student names and their enrolled course IDs.
SELECT S.Name,E.CourseID
FROM Students AS S
INNER JOIN Enrollments AS E
ON S.StudentID = E.StudentID;

--9. Using Payments, Orders table List all orders that have matching payments.
SELECT O.OrderID, P.PaymentID
FROM Orders AS O
INNER JOIN Payments AS P ON O.OrderID = P.OrderID;

--10. Using Orders, Products table Show orders where product price is more than 100.
SELECT O.OrderID, P.ProductName, P.Price
FROM Orders AS O
INNER JOIN Products AS P ON O.ProductID = P.ProductID
WHERE P.Price > 100;

--11. Using Employees, Departments table List employee names and department names where department IDs are not equal. It means: Show all mismatched employee-department combinations.
SELECT E.Name,D.DepartmentName
FROM Employees as E
INNER JOIN Departments as D
ON E.DepartmentID <> D.DepartmentID;

--12. Using Orders, Products table Show orders where ordered quantity is greater than stock quantity.
SELECT O.OrderID, P.ProductName, O.Quantity, P.StockQuantity
FROM Orders AS O
INNER JOIN Products AS P
ON O.ProductID = P.ProductID
WHERE O.Quantity > P.StockQuantity;

--13. Using Customers, Sales table List customer names and product IDs where sale amount is 500 or more.
SELECT C.Firstname, S.ProductID,S.SaleAmount
FROM Customers AS C
INNER JOIN Sales AS S
ON C.CustomerID = S.CustomerID
WHERE S.SaleAmount >= 500;

--14. Using Courses, Enrollments, Students table List student names and course names they’re enrolled in.
SELECT S.Name, C.CourseName
FROM Enrollments AS E
INNER JOIN Students AS S 
ON E.StudentID = S.StudentID
INNER JOIN Courses AS C
ON E.CourseID = C.CourseID;

--15. Using Products, Suppliers table List product and supplier names where supplier name contains “Tech”.
SELECT P.ProductName, S.SupplierName
FROM Products AS P
INNER JOIN Suppliers AS S 
ON P.SupplierID = S.SupplierID
Where S.SupplierName like 'Tech%'

--16. Using Orders, Payments table Show orders where payment amount is less than total amount.
SELECT O.OrderID, O.TotalAmount, P.Amount
FROM Orders AS O
INNER JOIN Payments AS P 
ON O.OrderID = P.OrderID
WHERE P.Amount < O.TotalAmount;

--17. Using Employees table List employee names with salaries greater than their manager’s salary.
SELECT E.Name, E.Salary, M.Name AS ManagerName, M.Salary AS ManagerSalary
FROM Employees AS E
INNER JOIN Employees AS M 
ON E.ManagerID = M.EmployeeID
WHERE E.Salary > M.Salary;

--18. Using Products, Categories table Show products where category is either 'Electronics' or 'Furniture'.
SELECT P.ProductName, C.CategoryName
FROM Products AS P
INNER JOIN Categories AS C 
ON P.Category = C.CategoryID
WHERE C.CategoryName IN ('Electronics', 'Furniture');

--19. Using Sales, Customers table Show all sales from customers who are from 'USA'.
SELECT S.SaleID, S.ProductID, S.SaleAmount, C.FirstName, C.Country
FROM Sales AS S
INNER JOIN Customers AS C ON S.CustomerID = C.CustomerID
WHERE C.Country = 'USA';

--20. Using Orders, Customers table List orders made by customers from 'Germany' and order total > 100.
SELECT O.OrderID, C.FirstName, C.Country, O.TotalAmount
FROM Orders AS O
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE C.Country = 'Germany' AND O.TotalAmount > 100;

--21.Using Employees table List all pairs of employees from different departments.
SELECT E1.Name AS Employee1, E2.Name AS Employee2, 
       E1.DepartmentID AS Dept1, E2.DepartmentID AS Dept2
FROM Employees E1
INNER JOIN Employees E2 ON 
E1.EmployeeID < E2.EmployeeID
WHERE E1.DepartmentID <> E2.DepartmentID;

--22.Using Payments, Orders, Products table List payment details where the paid amount is not equal to (Quantity × Product Price).
SELECT Pa.PaymentID, Pa.OrderID, Pr.ProductName,
       O.Quantity, Pr.Price,
       (O.Quantity * Pr.Price) AS ExpectedAmount,
       Pa.Amount
FROM Payments AS PA
INNER JOIN Orders AS O
ON Pa.OrderID = O.OrderID
INNER JOIN Products AS Pr
ON O.ProductID = Pr.ProductID
WHERE Pa.Amount <> (O.Quantity * Pr.Price);

--23.Using Students, Enrollments, Courses table Find students who are not enrolled in any course.
SELECT S.StudentID, S.Name
FROM Students AS S
LEFT JOIN Enrollments AS E
ON S.StudentID = E.StudentID
WHERE E.CourseID IS NULL;

--24.Using Employees table List employees who are managers of someone, but their salary is less than or equal to the person they manage.
SELECT M.Name AS ManagerName, M.Salary AS ManagerSalary,
       E.Name AS EmployeeName, E.Salary AS EmployeeSalary
FROM Employees AS E
INNER JOIN Employees AS M 
ON E.ManagerID = M.EmployeeID
WHERE M.Salary <= E.Salary;

--25.Using Orders, Payments, Customers table List customers who have made an order, but no payment has been recorded for it.
SELECT C.CustomerID, C.FirstName, O.OrderID
FROM Orders AS O
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
LEFT JOIN Payments AS P ON O.OrderID = P.OrderID
WHERE P.PaymentID IS NULL;
