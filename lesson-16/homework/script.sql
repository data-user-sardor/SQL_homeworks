--1. Create a numbers table using a recursive query from 1 to 1000.

WITH Numbers AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM Numbers
    WHERE Number < 1000
)
SELECT Number
FROM Numbers
OPTION (MAXRECURSION 1000);

--2. Write a query to find the total sales per employee using a derived table.(Sales, Employees)

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    total_sales.TotalSalesAmount
FROM 
    Employees e
JOIN 
    (
        SELECT 
            EmployeeID, 
            SUM(SalesAmount) AS TotalSalesAmount
        FROM 
            Sales
        GROUP BY 
            EmployeeID
    ) AS total_sales
ON 
    e.EmployeeID = total_sales.EmployeeID;

--3. Create a CTE to find the average salary of employees.(Employees)

WITH AvgSalaryCTE AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM Employees
)
SELECT AverageSalary
FROM AvgSalaryCTE;

--4. Write a query using a derived table to find the highest sales for each product.(Sales, Products)

SELECT 
    p.ProductID,
    p.ProductName,
    highest_sales.MaxSalesAmount
FROM 
    Products p
JOIN 
    (
        SELECT 
            ProductID, 
            MAX(SalesAmount) AS MaxSalesAmount
        FROM 
            Sales
        GROUP BY 
            ProductID
    ) AS highest_sales
ON 
    p.ProductID = highest_sales.ProductID;


--5.Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.

WITH Doubles AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number * 2
    FROM Doubles
    WHERE Number * 2 < 1000000
)
SELECT Number
FROM Doubles;

--6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)

WITH SalesCount AS (
    SELECT 
        EmployeeID,
        COUNT(*) AS NumberOfSales
    FROM Sales
    GROUP BY EmployeeID
    HAVING COUNT(*) > 5
)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    sc.NumberOfSales
FROM 
    Employees e
JOIN 
    SalesCount sc ON e.EmployeeID = sc.EmployeeID;

--7. Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

WITH ProductSales AS (
    SELECT 
        ProductID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
    HAVING SUM(SalesAmount) > 500
)
SELECT 
    p.ProductID,
    p.ProductName,
    ps.TotalSales
FROM 
    Products p
JOIN 
    ProductSales ps ON p.ProductID = ps.ProductID;

--8. Create a CTE to find employees with salaries above the average salary.(Employees)

WITH AvgSalaryCTE AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM Employees
)
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM 
    Employees, AvgSalaryCTE
WHERE 
    Salary > AverageSalary;

--9. Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    sales_counts.OrderCount
FROM 
    Employees e
JOIN 
    (
        SELECT TOP 5
            EmployeeID, 
            COUNT(*) AS OrderCount
        FROM 
            Sales
        GROUP BY 
            EmployeeID
    ) AS sales_counts ON e.EmployeeID = sales_counts.EmployeeID
ORDER BY 
    sales_counts.OrderCount DESC;


--10. Write a query using a derived table to find the sales per product category.(Sales, Products)

SELECT 
    p.CategoryID,
    SUM(s.SalesAmount) AS TotalSales
FROM 
    Sales s
JOIN 
    (
        SELECT ProductID, CategoryID
        FROM Products
    ) AS p ON s.ProductID = p.ProductID
GROUP BY 
    p.CategoryID;


--11. Write a script to return the factorial of each value next to it.(Numbers1)

WITH FactorialCTE AS (
    -- Anchor member: start with 1 for factorial calculation
    SELECT
        Number,
        1 AS Factorial,
        1 AS Counter
    FROM Numbers1
    WHERE Number >= 1

    UNION ALL

    -- Recursive member: multiply factorial by counter until counter = Number
    SELECT
        Number,
        Factorial * (Counter + 1),
        Counter + 1
    FROM FactorialCTE
    WHERE Counter + 1 <= Number
)
SELECT
    Number,
    MAX(Factorial) AS Factorial
FROM FactorialCTE
GROUP BY Number
ORDER BY Number;

--12. This script uses recursion to split a string into rows of substrings for each character in the string.(Example)

WITH RecursiveSplit AS (
    -- Anchor member: start with position 1 of each string
    SELECT
        Id,
        String,
        SUBSTRING(String, 1, 1) AS Char,
        1 AS Position
    FROM Example
    WHERE LEN(String) > 0

    UNION ALL

    -- Recursive member: get next character until the end of the string
    SELECT
        Id,
        String,
        SUBSTRING(String, Position + 1, 1) AS Char,
        Position + 1
    FROM RecursiveSplit
    WHERE Position < LEN(String)
)
SELECT
    Id,
    Char,
    Position
FROM RecursiveSplit
ORDER BY Id, Position;

--13. Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

WITH MonthlySales AS (
    SELECT
        YEAR(SaleDate) AS SaleYear,
        MONTH(SaleDate) AS SaleMonth,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
),
SalesWithPrev AS (
    SELECT
        SaleYear,
        SaleMonth,
        TotalSales,
        LAG(TotalSales) OVER (ORDER BY SaleYear, SaleMonth) AS PrevMonthSales
    FROM MonthlySales
)
SELECT
    SaleYear,
    SaleMonth,
    TotalSales,
    PrevMonthSales,
    (TotalSales - COALESCE(PrevMonthSales, 0)) AS SalesDifference
FROM SalesWithPrev
ORDER BY SaleYear, SaleMonth;


--14. Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    sales_quarter.Quarter,
    sales_quarter.TotalSales
FROM
    Employees e
JOIN
    (
        SELECT
            EmployeeID,
            DATEPART(QUARTER, SaleDate) AS Quarter,
            SUM(SalesAmount) AS TotalSales
        FROM Sales
        GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
        HAVING SUM(SalesAmount) > 45000
    ) AS sales_quarter ON e.EmployeeID = sales_quarter.EmployeeID
ORDER BY
    e.EmployeeID,
    sales_quarter.Quarter;

--15. This script uses recursion to calculate Fibonacci numbers
WITH Fibonacci (PrevN, N) AS
(
     SELECT 0, 1
     UNION ALL
     SELECT N, PrevN + N
     FROM Fibonacci
     WHERE N < 1000000000
)
SELECT PrevN as Fibo
     FROM Fibonacci
     OPTION (MAXRECURSION 0);
--16.Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

SELECT Id, Vals
FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LEN(Vals) > 1
  AND Vals = REPLICATE(LEFT(Vals, 1), LEN(Vals));


--17. Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)

DECLARE @n INT = 5;

WITH Numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1
    FROM Numbers
    WHERE num < @n
),
SequenceCTE AS (
    SELECT
        num,
        CAST(CAST(num AS VARCHAR(10)) AS VARCHAR(MAX)) AS sequence
    FROM Numbers
    WHERE num = 1
    
    UNION ALL
    
    SELECT
        n.num,
        CAST(s.sequence + CAST(n.num AS VARCHAR(10)) AS VARCHAR(MAX))
    FROM Numbers n
    JOIN SequenceCTE s ON n.num = s.num + 1
)
SELECT num AS n, sequence
FROM SequenceCTE
ORDER BY num;

--18. Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

SELECT e.EmployeeID, e.FirstName, e.LastName, total_sales.TotalSalesAmount
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSalesAmount
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) AS total_sales ON e.EmployeeID = total_sales.EmployeeID
WHERE total_sales.TotalSalesAmount = (
    SELECT MAX(SalesSum)
    FROM (
        SELECT EmployeeID, SUM(SalesAmount) AS SalesSum
        FROM Sales
        WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY EmployeeID
    ) AS sales_per_employee
);

--19. Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)

;WITH SplitDigits AS (
    SELECT
        PawanName,
        LEFT(Pawan_slug_name, CHARINDEX('-', Pawan_slug_name)) AS prefix,
        SUBSTRING(Pawan_slug_name, CHARINDEX('-', Pawan_slug_name) + 1, LEN(Pawan_slug_name)) AS digits
    FROM RemoveDuplicateIntsFromNames
),
DistinctDigits AS (
    -- Anchor part
    SELECT
        PawanName,
        prefix,
        CAST('' AS VARCHAR(1000)) AS distinct_digits,
        digits,
        1 AS pos
    FROM SplitDigits
    WHERE digits IS NOT NULL AND digits <> ''
    
    UNION ALL

    -- Recursive part
    SELECT
        sd.PawanName,
        sd.prefix,
        CASE 
            WHEN CHARINDEX(SUBSTRING(sd.digits, sd.pos, 1), sd.distinct_digits) = 0 
                THEN CAST(sd.distinct_digits + SUBSTRING(sd.digits, sd.pos, 1) AS VARCHAR(1000))
            ELSE CAST(sd.distinct_digits AS VARCHAR(1000))
        END,
        sd.digits,
        sd.pos + 1
    FROM DistinctDigits sd
    WHERE sd.pos <= LEN(sd.digits)
),
FinalResult AS (
    SELECT 
        PawanName,
        prefix,
        distinct_digits,
        LEN(distinct_digits) AS distinct_len,
        digits
    FROM DistinctDigits
    WHERE pos > LEN(digits)
)
SELECT 
    PawanName,
    CASE 
        WHEN distinct_len <= 1 THEN prefix
        ELSE prefix + distinct_digits
    END AS Cleaned_slug_name
FROM FinalResult;







CREATE TABLE Numbers1(Number INT)

INSERT INTO Numbers1 VALUES (5),(9),(8),(6),(7)

CREATE TABLE FindSameCharacters
(
     Id INT
    ,Vals VARCHAR(10)
)
 
INSERT INTO FindSameCharacters VALUES
(1,'aa'),
(2,'cccc'),
(3,'abc'),
(4,'aabc'),
(5,NULL),
(6,'a'),
(7,'zzz'),
(8,'abc')



CREATE TABLE RemoveDuplicateIntsFromNames
(
      PawanName INT
    , Pawan_slug_name VARCHAR(1000)
)
 
 
INSERT INTO RemoveDuplicateIntsFromNames VALUES
(1,  'PawanA-111'  ),
(2, 'PawanB-123'   ),
(3, 'PawanB-32'    ),
(4, 'PawanC-4444' ),
(5, 'PawanD-3'  )





CREATE TABLE Example
(
Id       INTEGER IDENTITY(1,1) PRIMARY KEY,
String VARCHAR(30) NOT NULL
);


INSERT INTO Example VALUES('123456789'),('abcdefghi');


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees (EmployeeID, DepartmentID, FirstName, LastName, Salary) VALUES
(1, 1, 'John', 'Doe', 60000.00),
(2, 1, 'Jane', 'Smith', 65000.00),
(3, 2, 'James', 'Brown', 70000.00),
(4, 3, 'Mary', 'Johnson', 75000.00),
(5, 4, 'Linda', 'Williams', 80000.00),
(6, 2, 'Michael', 'Jones', 85000.00),
(7, 1, 'Robert', 'Miller', 55000.00),
(8, 3, 'Patricia', 'Davis', 72000.00),
(9, 4, 'Jennifer', 'García', 77000.00),
(10, 1, 'William', 'Martínez', 69000.00);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Finance'),
(5, 'IT'),
(6, 'Operations'),
(7, 'Customer Service'),
(8, 'R&D'),
(9, 'Legal'),
(10, 'Logistics');

CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    EmployeeID INT,
    ProductID INT,
    SalesAmount DECIMAL(10, 2),
    SaleDate DATE
);
INSERT INTO Sales (SalesID, EmployeeID, ProductID, SalesAmount, SaleDate) VALUES
-- January 2025
(1, 1, 1, 1550.00, '2025-01-02'),
(2, 2, 2, 2050.00, '2025-01-04'),
(3, 3, 3, 1250.00, '2025-01-06'),
(4, 4, 4, 1850.00, '2025-01-08'),
(5, 5, 5, 2250.00, '2025-01-10'),
(6, 6, 6, 1450.00, '2025-01-12'),
(7, 7, 1, 2550.00, '2025-01-14'),
(8, 8, 2, 1750.00, '2025-01-16'),
(9, 9, 3, 1650.00, '2025-01-18'),
(10, 10, 4, 1950.00, '2025-01-20'),
(11, 1, 5, 2150.00, '2025-02-01'),
(12, 2, 6, 1350.00, '2025-02-03'),
(13, 3, 1, 2050.00, '2025-02-05'),
(14, 4, 2, 1850.00, '2025-02-07'),
(15, 5, 3, 1550.00, '2025-02-09'),
(16, 6, 4, 2250.00, '2025-02-11'),
(17, 7, 5, 1750.00, '2025-02-13'),
(18, 8, 6, 1650.00, '2025-02-15'),
(19, 9, 1, 2550.00, '2025-02-17'),
(20, 10, 2, 1850.00, '2025-02-19'),
(21, 1, 3, 1450.00, '2025-03-02'),
(22, 2, 4, 1950.00, '2025-03-05'),
(23, 3, 5, 2150.00, '2025-03-08'),
(24, 4, 6, 1700.00, '2025-03-11'),
(25, 5, 1, 1600.00, '2025-03-14'),
(26, 6, 2, 2050.00, '2025-03-17'),
(27, 7, 3, 2250.00, '2025-03-20'),
(28, 8, 4, 1350.00, '2025-03-23'),
(29, 9, 5, 2550.00, '2025-03-26'),
(30, 10, 6, 1850.00, '2025-03-29'),
(31, 1, 1, 2150.00, '2025-04-02'),
(32, 2, 2, 1750.00, '2025-04-05'),
(33, 3, 3, 1650.00, '2025-04-08'),
(34, 4, 4, 1950.00, '2025-04-11'),
(35, 5, 5, 2050.00, '2025-04-14'),
(36, 6, 6, 2250.00, '2025-04-17'),
(37, 7, 1, 2350.00, '2025-04-20'),
(38, 8, 2, 1800.00, '2025-04-23'),
(39, 9, 3, 1700.00, '2025-04-26'),
(40, 10, 4, 2000.00, '2025-04-29'),
(41, 1, 5, 2200.00, '2025-05-03'),
(42, 2, 6, 1650.00, '2025-05-07'),
(43, 3, 1, 2250.00, '2025-05-11'),
(44, 4, 2, 1800.00, '2025-05-15'),
(45, 5, 3, 1900.00, '2025-05-19'),
(46, 6, 4, 2000.00, '2025-05-23'),
(47, 7, 5, 2400.00, '2025-05-27'),
(48, 8, 6, 2450.00, '2025-05-31'),
(49, 9, 1, 2600.00, '2025-06-04'),
(50, 10, 2, 2050.00, '2025-06-08'),
(51, 1, 3, 1550.00, '2025-06-12'),
(52, 2, 4, 1850.00, '2025-06-16'),
(53, 3, 5, 1950.00, '2025-06-20'),
(54, 4, 6, 1900.00, '2025-06-24'),
(55, 5, 1, 2000.00, '2025-07-01'),
(56, 6, 2, 2100.00, '2025-07-05'),
(57, 7, 3, 2200.00, '2025-07-09'),
(58, 8, 4, 2300.00, '2025-07-13'),
(59, 9, 5, 2350.00, '2025-07-17'),
(60, 10, 6, 2450.00, '2025-08-01');

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    CategoryID INT,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, CategoryID, ProductName, Price) VALUES
(1, 1, 'Laptop', 1000.00),
(2, 1, 'Smartphone', 800.00),
(3, 2, 'Tablet', 500.00),
(4, 2, 'Monitor', 300.00),
(5, 3, 'Headphones', 150.00),
(6, 3, 'Mouse', 25.00),
(7, 4, 'Keyboard', 50.00),
(8, 4, 'Speaker', 200.00),
(9, 5, 'Smartwatch', 250.00),
(10, 5, 'Camera', 700.00);
