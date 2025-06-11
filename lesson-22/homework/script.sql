CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

--1 Compute Running Total Sales per Customer
SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS running_total_sales
FROM sales_data;

--2 Count the Number of Orders per Product Category
SELECT
    product_category,
    COUNT(*) AS number_of_orders
FROM sales_data
GROUP BY product_category;

--3 Find the Maximum Total Amount per Product Category
SELECT
    product_category,
    MAX(total_amount) AS max_total_amount
FROM sales_data
GROUP BY product_category;


--4 Find the Minimum Price of Products per Product Category
SELECT
    product_category,
    MIN(unit_price) AS Min_price_of_products
FROM sales_data
GROUP BY product_category;

--5 Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)
SELECT
    order_date,
    total_amount,
    AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg_3_days
FROM sales_data;

--6 Find the Total Sales per Region
SELECT
    region,
    SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region;

--7 Compute the Rank of Customers Based on Their Total Purchase Amount
SELECT
    customer_id,
    customer_name,
    SUM(total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS customer_rank
FROM sales_data
GROUP BY customer_id, customer_name;


--8 Calculate the Difference Between Current and Previous Sale Amount per Customer
SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    total_amount - LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS sale_diff_from_prev
FROM sales_data;

--9 Find the Top 3 Most Expensive Products in Each Category
SELECT *
FROM (
    SELECT *,
        DENSE_RANK() OVER (
            PARTITION BY product_category
            ORDER BY unit_price DESC
        ) AS price_rank
    FROM sales_data
) ranked
WHERE price_rank <= 3;

--10 Compute the Cumulative Sum of Sales Per Region by Order Date
SELECT
    region,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY region
        ORDER BY order_date
    ) AS cumulative_sales
FROM sales_data;

--11 Compute Cumulative Revenue per Product Category
SELECT
    product_category,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY product_category
        ORDER BY order_date
    ) AS cumulative_revenue
FROM sales_data
ORDER BY product_category, order_date;

--12 Here you need to find out the sum of previous values.
create TABLE Sample (ID INT);
INSERT INTO Sample VALUES (1), (2), (3), (4), (5);
SELECT
    ID,
    SUM(ID) OVER (ORDER BY ID) AS SumPreValues
FROM Sample;

--13 Sum of Previous Values to Current Value
CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);
SELECT
    Value,
    SUM(Value) OVER (ORDER BY Value ROWS BETWEEN 1 PRECEDING and current row) AS SumOfPrevious
FROM OneColumn;

--14 Generate row numbers for the given data. 
--The condition is that the first row number for every partition should be odd number.
CREATE TABLE Row_Nums (
    Id INT,
    Vals VARCHAR(10)
);
INSERT INTO Row_Nums VALUES
(101,'a'), (102,'b'), (102,'c'), (103,'f'), (103,'e'), (103,'q'), (104,'r'), (105,'p');

WITH Numbered AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) AS rn
    FROM Row_Nums
),
GroupStarts AS (
    SELECT Id,
           SUM(COUNT(*)) OVER (ORDER BY MIN(Id)) * 2 - 1 AS start_num
    FROM Row_Nums
    GROUP BY Id
)
SELECT n.Id, n.Vals,
       g.start_num + n.rn - 1 AS RowNumber
FROM Numbered n
JOIN GroupStarts g ON n.Id = g.Id
ORDER BY RowNumber;

--15  Customers Who Purchased from More Than One Product Category
SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;

--16 Customers with Above-Average Spending in Their Region
WITH RegionAvg AS (
    SELECT region, AVG(total_amount) AS avg_spend
    FROM sales_data
    GROUP BY region
)
SELECT s.customer_id, s.customer_name, s.region, s.total_amount
FROM sales_data s
JOIN RegionAvg r ON s.region = r.region
WHERE s.total_amount > r.avg_spend;

--17 Rank Customers by Total Spending Within Each Region (with Ties Allowed)
WITH TotalSpend AS (
    SELECT customer_id, customer_name, region, SUM(total_amount) AS total_spend
    FROM sales_data
    GROUP BY customer_id, customer_name, region
)
SELECT *,
       RANK() OVER (PARTITION BY region ORDER BY total_spend DESC) AS rank_in_region
FROM TotalSpend;

--18 Running Total (Cumulative Sales) per Customer by Order Date
SELECT customer_id, customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data
ORDER BY customer_id, order_date;

--19 Monthly Sales Growth Rate Compared to the Previous Month

--20 Customers Whose total_amount Is Higher Than Their Previous Order
WITH OrderedSales AS (
    SELECT *,
           LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_total
    FROM sales_data
)
SELECT customer_id, customer_name, order_date, total_amount, previous_total
FROM OrderedSales
WHERE total_amount > previous_total;

--21 Identify Products that prices are above the average product price
SELECT DISTINCT product_name, unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

--22 In this puzzle you have to find the sum of val1 and val2 for each group and
--put that value at the beginning of the group in the new column. 
--The challenge here is to do this in a single select. 
CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);
SELECT
    Id,
    Grp,
    Val1,
    Val2,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS Tot
FROM MyData
ORDER BY Grp, Id;

--23 Here you have to sum up the value of the cost column based on the values of Id. 
--For Quantity if values are different then we have to add those values.
CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

SELECT
    ID,
    SUM(Cost) AS Cost,
    CASE
        WHEN COUNT(DISTINCT Quantity) = 1 THEN MAX(Quantity)
        ELSE SUM(Quantity)
    END AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

--24 From following set of integers, write an SQL statement to determine the expected outputs
/*Expected outputs
|Gap Start	|Gap End|
---------------------
|     1     |	6	|
|     8     |	12	|
|     16    |	26	|
|     36    |	51	|
---------------------*/

CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

WITH SeatPairs AS (
    SELECT 
        SeatNumber,
        LEAD(SeatNumber) OVER (ORDER BY SeatNumber) AS NextSeat
    FROM Seats
),
Gaps AS (
    -- Gaps between seats
    SELECT 
        SeatNumber + 1 AS GapStart,
        NextSeat - 1 AS GapEnd
    FROM SeatPairs
    WHERE NextSeat IS NOT NULL AND NextSeat > SeatNumber + 1

    UNION ALL

    -- Gap before minimum seat if it starts > 1
    SELECT 
        1 AS GapStart,
        MIN(SeatNumber) - 1 AS GapEnd
    FROM Seats
    HAVING MIN(SeatNumber) > 1
)
SELECT GapStart, GapEnd
FROM Gaps
ORDER BY GapStart;


--25 In this puzzle you need to generate row numbers for the given data. 
/*The condition is that the first row number for every partition should be even number.
Expected outputs
| Id  | Vals | Changed |
|-----|------|---------|
| 101 | a    | 2       |
| 102 | b    | 4       |
| 102 | c    | 5       |
| 103 | e    | 6       |
| 103 | f    | 7       |
| 103 | q    | 8       |
| 104 | r    | 10      |
| 105 | p    | 12      |*/

CREATE TABLE Table123 (
    Id INT,
    Vals VARCHAR(10)
);

INSERT INTO Table123 (Id, Vals) VALUES
(101, 'a'),
(102, 'b'),
(102, 'c'),
(103, 'f'),
(103, 'e'),
(103, 'q'),
(104, 'r'),
(105, 'p');
