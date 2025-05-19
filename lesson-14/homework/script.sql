--1. Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)
SELECT
  LTRIM(RTRIM(LEFT(Name, CHARINDEX(',', Name) - 1))) AS Name,
  LTRIM(RTRIM(RIGHT(Name, LEN(Name) - CHARINDEX(',', Name)))) AS Surname
FROM TestMultipleColumns
WHERE CHARINDEX(',', Name) > 0;

--2. Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)
SELECT *
FROM TestPercent
WHERE Strs LIKE '%[%]%';

--3. In this puzzle you will have to split a string based on dot(.).(Splitter)
SELECT
    s.Vals,
    value AS Part
FROM Splitter s
CROSS APPLY STRING_SPLIT(s.Vals, '.');


--4. Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)
SELECT 
  TRANSLATE('1234ABC123456XYZ1234567890ADS', '0123456789', 'XXXXXXXXXX') AS MaskedString;

--5. Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)
SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

--6. Write a SQL query to count the spaces present in the string.(CountSpaces)
SELECT 
    texts,
    LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;

--7. write a SQL query that finds out employees who earn more than their managers.(Employee)
SELECT 
    e.ID,
    e.Name AS Name,
    e.Salary AS EmployeeSalary,
    m.ID AS ManagerID,
    m.Name AS ManagerName,
    m.Salary AS ManagerSalary
FROM Employee e
JOIN Employee m ON e.ManagerID = m.ID
WHERE e.Salary > m.Salary;

/*8. Find the employees who have been with the company for more than 10 years, but less than 15 years. 
Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the 
number of years between the current date and the hire date).(Employees)*/
SELECT
    Employee_ID,
    First_Name,
    Last_Name,
    Hire_Date,
    DATEDIFF(year, Hire_Date, GETDATE()) AS YearsOfService
FROM Employees
WHERE 
    DATEDIFF(year, Hire_Date, GETDATE()) > 10
    AND DATEDIFF(year, Hire_Date, GETDATE()) < 15;

--9. Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)
DECLARE @str VARCHAR(100) = 'rtcfvty34redt';

WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < LEN(@str)
),
Separated AS (
    SELECT SUBSTRING(@str, n, 1) AS char_val, n
    FROM Numbers
),
Digits AS (
    SELECT STRING_AGG(char_val, '') WITHIN GROUP (ORDER BY n) AS digits
    FROM Separated
    WHERE char_val LIKE '[0-9]'
),
Letters AS (
    SELECT STRING_AGG(char_val, '') WITHIN GROUP (ORDER BY n) AS letters
    FROM Separated
    WHERE char_val LIKE '[A-Za-z]'
)
SELECT digits, letters
FROM Digits CROSS JOIN Letters;

--10. write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)
SELECT
    Id,
    RecordDate,
    Temperature
FROM (
    SELECT
        Id,
        RecordDate,
        Temperature,
        LAG(Temperature) OVER (ORDER BY RecordDate) AS PrevDayTemp
    FROM weather
) w
WHERE Temperature > PrevDayTemp;


--11. Write an SQL query that reports the first login date for each player.(Activity)
SELECT
    Player_ID,
    MIN(Event_Date) AS FirstLoginDate
FROM Activity
GROUP BY Player_ID;

--12. Your task is to return the third item from that list.(fruits)
SELECT PARSENAME(REPLACE(fruit_list, ',', '.'), 2) AS ThirdFruit
FROM fruits;

--13. Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)
 CREATE TABLE Characters (
    CharPosition INT,
    Character CHAR(1)
);

-- The string to split
DECLARE @inputString VARCHAR(100) = 'sdgfhsdgfhs@121313131';

-- Insert each character as a separate row
INSERT INTO Characters (CharPosition, Character)
SELECT 
    number + 1 AS CharPosition,
    SUBSTRING(@inputString, number + 1, 1) AS Character
FROM master..spt_values
WHERE type = 'P' 
  AND number < LEN(@inputString);

-- Select to check result
SELECT * FROM Characters;


--14. You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)

SELECT 
    p1.id,
    CASE 
        WHEN p1.code = 0 THEN p2.code
        ELSE p1.code
    END AS code
FROM p1
JOIN p2 ON p1.id = p2.id;

/*15. Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. 
The stages are defined as follows:
If the employee has worked for less than 1 year → 'New Hire'
If the employee has worked for 1 to 5 years → 'Junior'
If the employee has worked for 5 to 10 years → 'Mid-Level'
If the employee has worked for 10 to 20 years → 'Senior'
If the employee has worked for more than 20 years → 'Veteran'(Employees)*/
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE,
    DATEDIFF(year, HIRE_DATE, GETDATE()) AS YearsWorked,
    CASE 
        WHEN DATEDIFF(year, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(year, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(year, HIRE_DATE, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(year, HIRE_DATE, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;

--16. Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)
SELECT
    Vals,
    LEFT(Vals, 
        PATINDEX('%[^0-9]%', Vals + 'a') - 1
    ) AS StartingInteger
FROM GetIntegers;
SELECT*FROM GetIntegers;

--17. In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)
SELECT
    vals,
    -- Swap the first two letters only
    CASE 
        WHEN LEN(vals) >= 2 THEN
            SUBSTRING(vals, 2, 1) + SUBSTRING(vals, 1, 1) + SUBSTRING(vals, 3, LEN(vals) - 2)
        ELSE
            vals
    END AS swapped_vals
FROM MultipleVals;

--18. Write a SQL query that reports the device that is first logged in for each player.(Activity)
SELECT
    player_id,
    device_id,
    event_date
FROM Activity A1
WHERE event_date = (
    SELECT MIN(event_date)
    FROM Activity A2
    WHERE A2.player_id = A1.player_id
);

--19. You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. For each week, the total sales will be considered 100%, and the percentage sales for each day of the week should be calculated based on the area sales for that week.(WeekPercentagePuzzle)

WITH DailySales AS (
    SELECT
        Area,
        [Date],
        FinancialWeek,
        FinancialYear,
        ISNULL(SalesLocal, 0) + ISNULL(SalesRemote, 0) AS TotalSales
    FROM WeekPercentagePuzzle
),
WeeklySales AS (
    SELECT
        Area,
        FinancialWeek,
        FinancialYear,
        SUM(TotalSales) AS WeeklyTotalSales
    FROM DailySales
    GROUP BY Area, FinancialWeek, FinancialYear
),
DailySalesAggregated AS (
    SELECT
        Area,
        [Date],
        FinancialWeek,
        FinancialYear,
        SUM(TotalSales) AS DayTotalSales
    FROM DailySales
    GROUP BY Area, [Date], FinancialWeek, FinancialYear
)

SELECT
    dsa.Area,
    dsa.[Date],
    dsa.DayTotalSales,
    ws.WeeklyTotalSales,
    CASE 
        WHEN ws.WeeklyTotalSales = 0 THEN 0
        ELSE CAST(dsa.DayTotalSales * 100.0 / ws.WeeklyTotalSales AS DECIMAL(10,2))
    END AS PercentageOfWeek
FROM DailySalesAggregated dsa
JOIN WeeklySales ws
    ON dsa.Area = ws.Area
    AND dsa.FinancialWeek = ws.FinancialWeek
    AND dsa.FinancialYear = ws.FinancialYear
ORDER BY dsa.Area, dsa.FinancialYear, dsa.FinancialWeek, dsa.[Date];
