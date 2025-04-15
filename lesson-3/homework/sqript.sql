--1
BULK INSERT is a Transact-SQL (T-SQL) command in SQL Server used to import large volumes 
of data from a data file (such as a .txt or .csv) directly into a SQL Servertable or view.
The primary purpose of BULK INSERT is to provide a fast and efficient way to import large 
datasets into a SQL Server database. Its key uses include:
-Performance Efficiency: Much faster than individual INSERT statements for large datasets.
-Data Migration: Useful for importing data from legacy systems or external sources.
-ETL Processes: Common in data warehousing to load raw data for processing.
-Log Reduction: Minimal logging when used with TABLOCK, reducing transaction log usage.
--2
1)CSV (Comma-Separated Values)
Most commonly used for flat data exports.
Each row is a line, and columns are separated by commas.
2)TXT (Plain Text Files)
Often used with custom delimiters (like tabs or pipes |).Easily used with BULK INSERT or bcp.
3)XML (eXtensible Markup Language)
Structured format, often used in web applications or data exchange.Can be imported using OPENXML, xml data type, or SSIS.
4)JSON (JavaScript Object Notation)
Lightweight data-interchange format.Can be imported and parsed using SQL Server’s OPENJSON function.
--3
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2)
);
--4
INSERT INTO Products (ProductID, ProductName, Price)
VALUES	 (1, 'Tablet', 299.99),(2, 'Wireless Mouse', 25.75),(3, 'Monitor', 179.49);
select * from Products
--5
1)CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    HireDate DATE
);
In the above table, the HireDate column can have a NULL value, meaning the hiring date is unknown or not yet specified for some employees.
2)INSERT INTO Employees (EmployeeID, EmployeeName, HireDate)
VALUES (1, 'Alice', NULL);  -- HireDate is unknown for Alice
Here, HireDate for Alice is set to NULL, meaning it is missing or not available.
--6
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);
select * from Products
--7
-- This query retrieves all products with a price greater than $100
SELECT * FROM Products
WHERE Price > 100;
--8
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);
--9
The IDENTITY column in SQL Server is used to automatically generate 
unique numeric values for a column—typically for primary keys—when new rows are inserted into a table.
--10
BULK INSERT Products
FROM 'C:\Users\ThinkPad T495s\Desktop\Email_Info.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
--11
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);
--12
Example 1: PRIMARY KEY
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,  -- Primary key ensures uniqueness and non-nullability
    CustomerName VARCHAR(100)
);
In this example, the CustomerID column is a primary key. It ensures that no two customers
will have the same CustomerID and the CustomerID cannot be NULL.
Example 2: UNIQUE KEY
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,    -- Primary key for unique identification
    EmployeeEmail VARCHAR(100) UNIQUE  -- Unique key ensures no duplicate emails, but NULLs are allowed
);
In this example, EmployeeEmail has a unique key constraint, which ensures that all email addresses in 
the table are unique. However, it allows NULL values, so employees without an email can still be inserted with a NULL value in that column.
Example 3: Both PRIMARY and UNIQUE
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,    -- Primary key
    ProductCode VARCHAR(50) UNIQUE  -- Unique key
);
The ProductID is the primary key for uniquely identifying each product.
ProductCode is a unique key, which ensures that no two products have the same code.
--13
ALTER TABLE Products
ADD CONSTRAINT CHK_Price_Positive CHECK (Price > 0);
--14
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;
--15
SELECT ProductID, ProductName, ISNULL(Stock, 0) AS Stock
FROM Products;
--16
The primary purpose of a FOREIGN KEY constraint is to:
-Ensure Referential Integrity: It ensures that the data in the child table corresponds to valid data in the parent table. This prevents invalid or orphaned records in the child table.
-Prevent Invalid Data Entry: The FOREIGN KEY constraint ensures that any value inserted into the child table must exist in the parent table. If an attempt is made to insert a non-existing value, SQL Server will reject it.
When to Use FOREIGN KEY Constraints:
-When you want to relate data between tables (e.g., Products belong to Categories).
-When you want to prevent invalid data from being inserted (e.g., assigning a product to a non-existent category).
-When you want to automatically maintain consistency, such as deleting related rows.
--17
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Age INT CHECK (Age >= 18)
);
--18
CREATE TABLE Example (
    ID INT IDENTITY(100, 10) PRIMARY KEY,
    ItemName VARCHAR(100) NOT NULL
);
--19
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID)
);
--20
1)SELECT CustomerName, ISNULL(Email, 'No Email Provided') AS Email
FROM Customers;
If Email is NULL, it shows 'No Email Provided'.
2)SELECT FirstName, COALESCE(Nickname, FirstName) AS DisplayName
FROM Users;
If Nickname is NULL, it will fallback to FirstName.
--21
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Position VARCHAR(50),
    HireDate DATE
);
--22
Parent Table: Departments
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100)
);
Child Table: Employees (with the FOREIGN KEY)
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(100),
    DeptID INT,
    FOREIGN KEY (DeptID)
        REFERENCES Departments(DeptID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
