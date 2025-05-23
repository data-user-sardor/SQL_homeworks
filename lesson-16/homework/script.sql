--1. Task: You must provide a report of all distributors and their sales by region. 
/*If a distributor did not have any sales for a region, rovide a zero-dollar value for that day.
Assume there is at least one sale for each region*/

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

SELECT 
  r.Region,
  d.Distributor,
  ISNULL(rs.Sales, 0) AS Sales
FROM 
  (SELECT DISTINCT Region FROM #RegionSales) r
CROSS JOIN 
  (SELECT DISTINCT Distributor FROM #RegionSales) d
LEFT JOIN 
  #RegionSales rs
  ON rs.Region = r.Region AND rs.Distributor = d.Distributor
ORDER BY 
  d.Distributor, r.Region;


--2. Task: Find managers with at least five direct reports

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT 
  managerId
FROM 
  Employee
WHERE 
  managerId IS NOT NULL
GROUP BY 
  managerId
HAVING 
  COUNT(*) >= 5;

--3.  Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

SELECT 
  p.product_name,
  SUM(o.unit) AS total_units
FROM 
  Products p
JOIN 
  Orders o ON p.product_id = o.product_id
WHERE 
  o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY 
  p.product_name
HAVING 
  SUM(o.unit) >= 100;


--4. Task: Write an SQL statement that returns the vendor from which each customer has placed the most orders

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

SELECT 
  o.CustomerID,
  o.Vendor,
  COUNT(*) AS OrderCount
FROM Orders o
GROUP BY o.CustomerID, o.Vendor
HAVING COUNT(*) = (
  SELECT MAX(CNT)
  FROM (
    SELECT COUNT(*) AS CNT
    FROM Orders
    WHERE CustomerID = o.CustomerID
    GROUP BY Vendor
  ) AS VendorCounts
);



--5. Task: You will be given a number as a variable called @Check_Prime check if this number is prime then return 'This number is prime' else eturn 'This number is not prime'
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;
-- Handle numbers less than 2
IF @Check_Prime < 2
BEGIN
    SET @IsPrime = 0;
END
ELSE
BEGIN
    WHILE @i * @i <= @Check_Prime
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END
END

-- Output result
IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';


--6. Task: Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

WITH SignalCounts AS (
  SELECT 
    Device_id,
    Locations,
    COUNT(*) AS SignalCount
  FROM Device
  GROUP BY Device_id, Locations
),
RankedSignals AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY SignalCount DESC) AS rn
  FROM SignalCounts
)
SELECT 
  s.Device_id,
  (SELECT COUNT(DISTINCT Locations) FROM Device d WHERE d.Device_id = s.Device_id) AS TotalLocations,
  s.Locations AS TopLocation,
  (SELECT COUNT(*) FROM Device d WHERE d.Device_id = s.Device_id) AS TotalSignals
FROM RankedSignals s
WHERE rn = 1;



--7. Task: Write a SQL to find all Employees who earn more than the average salary in their corresponding department. Return EmpID, EmpName,Salary in your output
drop table Employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);

SELECT 
  id AS EmpID,
  name AS EmpName,
  salary
FROM 
  employees e
WHERE 
  salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
  );



--8. Task: You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers. If a ticket has some but not all the winning numbers, you win $10. If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.

-- Winning numbers
CREATE TABLE WinningNumbers (Number INT);
INSERT INTO WinningNumbers VALUES (25), (45), (78);

-- Tickets
CREATE TABLE Tickets (TicketID VARCHAR(20), Number INT);
INSERT INTO Tickets VALUES
('A23423', 25), ('A23423', 45), ('A23423', 78),
('B35643', 25), ('B35643', 45), ('B35643', 98),
('C98787', 67), ('C98787', 86), ('C98787', 91);


WITH WinningCounts AS (
  -- Count of winning numbers total
  SELECT COUNT(*) AS TotalWinningNumbers FROM WinningNumbers
),
TicketMatches AS (
  -- Count how many winning numbers each ticket matched
  SELECT 
    t.TicketID,
    COUNT(DISTINCT t.Number) AS MatchedCount
  FROM Tickets t
  JOIN WinningNumbers w ON t.Number = w.Number
  GROUP BY t.TicketID
),
TicketWinnings AS (
  SELECT 
    tm.TicketID,
    CASE 
      WHEN tm.MatchedCount = wc.TotalWinningNumbers THEN 100
      WHEN tm.MatchedCount > 0 THEN 10
      ELSE 0
    END AS Winnings
  FROM TicketMatches tm
  CROSS JOIN WinningCounts wc
)
SELECT SUM(Winnings) AS TotalWinnings
FROM TicketWinnings;



--9.  The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile devices.
/*Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.*/

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);



--10. Task: Write an SQL Statement to de-group the following data.

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

-- Generate numbers from 1 to 10 
WITH RepeatedRows AS (
SELECT Product, Quantity, 1 AS CountSoFar
FROM Grouped
WHERE Quantity > 0

UNION ALL
SELECT Product, Quantity, CountSoFar + 1
FROM RepeatedRows
WHERE CountSoFar + 1 <= Quantity
)

SELECT Product, 1 AS Quantity
FROM RepeatedRows
ORDER BY Product;
