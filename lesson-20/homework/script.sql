--1 Find customers who purchased at least one item in March 2024 using EXISTS
CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

SELECT CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.CustomerName = s2.CustomerName
    AND s2.SaleDate BETWEEN '2024-03-01' AND '2024-03-31'
);

--2 Find the product with the highest total sales revenue using a subquery:
SELECT Product
FROM #Sales
GROUP BY Product
ORDER BY SUM(Quantity * Price) DESC
LIMIT 1;

--3 Find the second highest sale amount using a subquery:
SELECT MAX(Quantity * Price) AS SecondHighestSale
FROM #Sales
WHERE (Quantity * Price) < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
);

--4 Find the total quantity of products sold per month using a subquery:
SELECT SaleYear, SaleMonth, 
       (SELECT SUM(Quantity)
        FROM #Sales s2
        WHERE YEAR(s2.SaleDate) = SaleYear AND MONTH(s2.SaleDate) = SaleMonth
       ) AS TotalQuantitySold
FROM (
    SELECT DISTINCT YEAR(SaleDate) AS SaleYear, MONTH(SaleDate) AS SaleMonth
    FROM #Sales
) AS Months;

--5 Find customers who bought the same products as another customer using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.CustomerName != s2.CustomerName
    AND s1.Product = s2.Product
);

--6 Return how many fruits each person has in individual fruit level:
create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

SELECT 
    Name,
    SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
    SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
    SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

--7 Return older people in the family with younger ones
create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)
WITH Ancestors AS (
    SELECT ParentID, ChildID
    FROM Family
    UNION ALL
    SELECT a.ParentID, f.ChildID
    FROM Ancestors a
    JOIN Family f ON a.ChildID = f.ParentID
)
SELECT * FROM Ancestors
ORDER BY ParentID, ChildID;

--8 Write an SQL statement given the following requirements. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas
CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

SELECT *
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND o.CustomerID IN (
      SELECT DISTINCT CustomerID
      FROM #Orders
      WHERE DeliveryState = 'CA'
  )
ORDER BY o.CustomerID, o.OrderID;

--10 Insert the names of residents if they are missing
create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

UPDATE #residents
SET address = address + ' name=' + fullname
WHERE address NOT LIKE '%name=%';

--10 Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes
CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

-- Recursive CTE to build all paths from Tashkent
;WITH RoutePaths AS (
    SELECT 
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
        ArrivalCity,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    SELECT 
        CAST(rp.Route + ' - ' + r.ArrivalCity AS VARCHAR(MAX)),
        r.ArrivalCity,
        rp.Cost + r.Cost
    FROM RoutePaths rp
    JOIN #Routes r ON rp.ArrivalCity = r.DepartureCity
    WHERE rp.Route NOT LIKE '%' + r.ArrivalCity + '%' 
)

SELECT TOP 1 Route, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost ASC  

UNION ALL

SELECT TOP 1 Route, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost DESC 

--11 Rank products based on their order of insertion.
CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

WITH ProductGroups AS
(
    SELECT 
        ID,
        Vals,
        -- Create a group ID that increases every time we encounter 'Product'
        SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) 
            OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS GroupID
    FROM #RankingPuzzle
),
FilteredProducts AS
(
    SELECT 
        GroupID,
        Vals
    FROM ProductGroups
    WHERE Vals <> 'Product'
),
ProductRanks AS
(
    SELECT 
        Vals,
        ROW_NUMBER() OVER (PARTITION BY Vals ORDER BY MIN(GroupID)) AS RankOrder
    FROM FilteredProducts
    GROUP BY Vals
)
SELECT 
    Vals AS Product,
    RANK() OVER (ORDER BY MIN(GroupID)) AS ProductRank
FROM FilteredProducts
GROUP BY Vals
ORDER BY ProductRank;

--12 Find employees whose sales were higher than the average sales in their department
CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

SELECT 
    ES.EmployeeID,
    ES.EmployeeName,
    ES.Department,
    ES.SalesAmount,
    ES.SalesMonth,
    ES.SalesYear
FROM #EmployeeSales ES
WHERE ES.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales AS DeptAvg
    WHERE DeptAvg.Department = ES.Department
);

--13 Find employees who had the highest sales in any given month using EXISTS
SELECT ES1.EmployeeID,
       ES1.EmployeeName,
       ES1.Department,
       ES1.SalesAmount,
       ES1.SalesMonth,
       ES1.SalesYear
FROM #EmployeeSales ES1
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales ES2
    WHERE ES2.SalesMonth = ES1.SalesMonth
      AND ES2.SalesYear = ES1.SalesYear
      AND ES2.SalesAmount > ES1.SalesAmount
);
 
--14 Find employees who made sales in every month using NOT EXISTS
SELECT E.EmployeeID,
       E.EmployeeName
FROM #EmployeeSales E
GROUP BY E.EmployeeID, E.EmployeeName
HAVING NOT EXISTS (
    SELECT 1
    FROM (
        SELECT DISTINCT SalesMonth
        FROM #EmployeeSales
    ) AS M
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales ES
        WHERE ES.EmployeeID = E.EmployeeID
          AND ES.SalesMonth = M.SalesMonth
    )
);

--15 Retrieve the names of products that are more expensive than the average price of all products.
CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

SELECT Name
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);


--16 Find the products that have a stock count lower than the highest stock count.
SELECT Name
FROM Products
WHERE Stock < (
    SELECT MAX(Stock)
    FROM Products
);

--17 Get the names of products that belong to the same category as 'Laptop'.
SELECT Name
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE Name = 'Laptop'
);

--18  Retrieve products whose price is greater than the lowest price in the Electronics category.
SELECT Name
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
);

--19 Find the products that have a higher price than the average price of their respective category.
SELECT Name
FROM Products P
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
    WHERE Category = P.Category
);

--20  Find the products that have been ordered at least once.
CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');

SELECT DISTINCT P.Name
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID;

--21 Retrieve the names of products that have been ordered more than the average quantity ordered.
SELECT P.Name
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.ProductID, P.Name
HAVING SUM(O.Quantity) > (
    SELECT AVG(Quantity)
    FROM Orders
);

--22 Find the products that have never been ordered.
SELECT P.Name
FROM Products P
LEFT JOIN Orders O ON P.ProductID = O.ProductID
WHERE O.OrderID IS NULL;

--23 Retrieve the product with the highest total quantity ordered.
SELECT TOP 1 P.Name
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.ProductID, P.Name
ORDER BY SUM(O.Quantity) DESC;
