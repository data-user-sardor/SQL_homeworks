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
