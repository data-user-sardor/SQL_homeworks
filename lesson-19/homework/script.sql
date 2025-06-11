--1 Create a stored procedure that:
/*Creates a temp table #EmployeeBonus
Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
(BonusAmount = Salary * BonusPercentage / 100)
Then, selects all data from the temp table.*/
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8)

-- Make sure this is the ONLY statement in the batch
GO
CREATE PROCEDURE CalculateEmployeeBonuses
AS
BEGIN
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10, 2),
        BonusAmount DECIMAL(10, 2)
    );

    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        e.EmployeeID, 
        e.FirstName + ' ' + e.LastName AS FullName, 
        e.Department, 
        e.Salary, 
        e.Salary * d.BonusPercentage / 100 AS BonusAmount
    FROM 
        Employees e
    INNER JOIN 
        DepartmentBonus d ON e.Department = d.Department;

    SELECT * FROM #EmployeeBonus;

    DROP TABLE #EmployeeBonus;
END;
GO
EXEC CalculateEmployeeBonuses;

--2 Create a stored procedure that:
/*Accepts a department name and an increase percentage as parameters
Update salary of all employees in the given department by the given percentage
Returns updated employees from that department.*/

GO
CREATE PROCEDURE UpdateDepartmentSalaries
    @DepartmentName NVARCHAR(50),
    @IncreasePercentage DECIMAL(5,2)
AS
BEGIN
    -- Update the salaries
    UPDATE Employees
    SET Salary = Salary + (Salary * @IncreasePercentage / 100)
    WHERE Department = @DepartmentName;

    -- Return the updated employees
    SELECT EmployeeID, FirstName, LastName, Department, Salary
    FROM Employees
    WHERE Department = @DepartmentName;
END;
GO

EXEC UpdateDepartmentSalaries 
    @DepartmentName = 'Sales', 
    @IncreasePercentage = 10;

--3 Perform a MERGE operation that:
/*Updates ProductName and Price if ProductID matches
Inserts new products if ProductID does not exist
Deletes products from Products_Current if they are missing in Products_New
Return the final state of Products_Current after the MERGE.*/

CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);

MERGE Products_Current AS target
USING Products_New AS source
ON target.ProductID = source.ProductID

-- When matched: update name and price
WHEN MATCHED THEN
    UPDATE SET 
        target.ProductName = source.ProductName,
        target.Price = source.Price

-- When not matched by target: insert new rows
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (source.ProductID, source.ProductName, source.Price)

-- When not matched by source: delete rows
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

-- Return the final state
SELECT * FROM Products_Current;

--4 Each node in the tree can be one of three types:
/*"Leaf": if the node is a leaf node.
"Root": if the node is the root of the tree.
"Inner": If the node is neither a leaf node nor a root node.
Write a solution to report the type of each node in the tree*/

create TABLE Tree (
    id INT PRIMARY KEY,
    parent_id INT
);
INSERT INTO Tree (id, parent_id) 
VALUES
(1, NULL),  -- Root node, no parent
(2, 1),     -- Node 2 has Node 1 as its parent
(3, 1),     -- Node 3 has Node 1 as its parent
(4, 2);     -- Node 4 has Node 2 as its parent
(5, 2);     -- Node 5 has Node 2 as its parent

SELECT
    t.id,
    CASE
        WHEN t.parent_id IS NULL THEN 'Root'
        WHEN NOT EXISTS (
            SELECT 1 FROM Tree WHERE parent_id = t.id
        ) THEN 'Leaf'
        ELSE 'Inner'
    END AS Type
FROM Tree t;

--5 Find the confirmation rate for each user. If a user has no confirmation requests, the rate should be 0.
create TABLE Signups (user_id INT, time_stamp DATETIME);
CREATE TABLE Confirmations (
    user_id INT,
    time_stamp DATETIME,
    action VARCHAR(10) CHECK (action IN ('confirmed', 'timeout'))
);

INSERT INTO Signups (user_id, time_stamp) VALUES 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

INSERT INTO Confirmations (user_id, time_stamp, action) VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

SELECT 
    s.user_id,
    COALESCE(
        SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) * 1.0 / 
        NULLIF(COUNT(c.action), 0), 0
    ) AS confirmation_rate
FROM 
    Signups s
LEFT JOIN 
    Confirmations c ON s.user_id = c.user_id
GROUP BY 
    s.user_id


--6 Find employees with the lowest salary
CREATE TABLE employees123 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees123 (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

SELECT id, name, salary
FROM employees123
WHERE salary = (
    SELECT MIN(salary)
    FROM employees123
);
--7 Get Product Sales Summary
-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);
-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');

CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    -- Declare variables for the result
    DECLARE @ProductName NVARCHAR(100);
    DECLARE @TotalQuantity INT;
    DECLARE @TotalSalesAmount DECIMAL(10, 2);
    DECLARE @FirstSaleDate DATE;
    DECLARE @LastSaleDate DATE;

    -- Get the Product Name
    SELECT @ProductName = ProductName
    FROM Products
    WHERE ProductID = @ProductID;

    -- Get the total quantity sold, total sales amount, first sale date, and last sale date
    SELECT 
        @TotalQuantity = SUM(s.Quantity),
        @TotalSalesAmount = SUM(s.Quantity * p.Price),
        @FirstSaleDate = MIN(s.SaleDate),
        @LastSaleDate = MAX(s.SaleDate)
    FROM Sales s
    INNER JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID;

    -- If there were no sales, set the quantities and dates to NULL
    IF @TotalQuantity IS NULL
    BEGIN
        SET @TotalQuantity = NULL;
        SET @TotalSalesAmount = NULL;
        SET @FirstSaleDate = NULL;
        SET @LastSaleDate = NULL;
    END

    -- Return the result
    SELECT 
        @ProductName AS ProductName,
        @TotalQuantity AS TotalQuantitySold,
        @TotalSalesAmount AS TotalSalesAmount,
        @FirstSaleDate AS FirstSaleDate,
        @LastSaleDate AS LastSaleDate;
END;

exec GetProductSalesSummary;
