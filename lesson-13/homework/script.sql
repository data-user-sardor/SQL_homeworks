--1. You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.
SELECT CONCAT(EMPLOYEE_ID, '-', first_name, ' ', last_name) AS employee_info
FROM employees
WHERE EMPLOYEE_ID = 100;

--2. Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'
UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');
select * from Employees

--3. That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)
SELECT 
  first_name AS "First Name",
  LEN(first_name) AS "Name Length"
FROM 
  employees
WHERE 
  first_name LIKE 'A%' OR
  first_name LIKE 'J%' OR
  first_name LIKE 'M%'
ORDER BY 
  first_name;

--4. Write an SQL query to find the total salary for each manager ID.(Employees table)
SELECT 
  manager_id,
  SUM(salary) AS total_salary
FROM 
  employees
GROUP BY 
  manager_id;

--5. Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table
SELECT 
  Year1,
  GREATEST(Max1, Max2, Max3) AS highest_value
FROM 
  TestMax;

--6. Find me odd numbered movies and description is not boring.(cinema)
SELECT *
FROM cinema
WHERE id % 2 = 1  -- odd numbered movies
  AND LOWER(description) <> 'boring';

--7. You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)
SELECT *
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 9999 ELSE Id END;

--8. Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)
SELECT 
    id,
    COALESCE(ssn, passportid, itin) AS FirstNonNullValue
FROM person;

--9. Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)
SELECT 
  PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS Firstname,
  PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS Middlename,
  PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS Lastname
FROM 
  Students;

--10. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)
SELECT *
FROM Orders o
WHERE o.DeliveryState = 'TX'
  AND o.CustomerID IN (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE DeliveryState = 'CA'
);

--11. Write an SQL statement that can group concatenate the following values.(DMLTable)
SELECT STRING_AGG(String, ' ') WITHIN GROUP (ORDER BY SequenceNumber) AS ConcatenatedString
FROM DMLTable;

--12. Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times.
SELECT *
FROM Employees
WHERE 
    (LEN(first_name + last_name) - LEN(REPLACE(LOWER(first_name + last_name), 'a', ''))) >= 3;

--13. The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)
SELECT
    department_id,
    COUNT(*) AS total_employees,
    ROUND(
        100.0 * SUM(CASE WHEN hire_date <= DATEADD(year, -3, GETDATE()) THEN 1 ELSE 0 END) * 1.0 / COUNT(*),
        2
    ) AS pct_more_than_3_years
FROM
    Employees
GROUP BY
    department_id;
 
--14. Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)
WITH MaxExp AS (
    SELECT JobDescription, SpacemanID, MissionCount
    FROM Personal p1
    WHERE MissionCount = (
        SELECT MAX(MissionCount)
        FROM Personal p2
        WHERE p2.JobDescription = p1.JobDescription
    )
),
MinExp AS (
    SELECT JobDescription, SpacemanID, MissionCount
    FROM Personal p1
    WHERE MissionCount = (
        SELECT MIN(MissionCount)
        FROM Personal p2
        WHERE p2.JobDescription = p1.JobDescription
    )
)
SELECT 
    mx.JobDescription,
    mx.SpacemanID AS MostExperiencedID,
    mn.SpacemanID AS LeastExperiencedID
FROM MaxExp mx
JOIN MinExp mn ON mx.JobDescription = mn.JobDescription;

--15. Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.
DECLARE @input VARCHAR(100) = 'tf56sd#%OqH';
DECLARE @i INT = 1;
DECLARE @len INT = LEN(@input);
DECLARE @char CHAR(1);
DECLARE @upper VARCHAR(100) = '';
DECLARE @lower VARCHAR(100) = '';
DECLARE @number VARCHAR(100) = '';
DECLARE @other VARCHAR(100) = '';
WHILE @i <= @len
BEGIN
    SET @char = SUBSTRING(@input, @i, 1);
    
    IF ASCII(@char) BETWEEN 65 AND 90
        SET @upper += @char;
    ELSE IF ASCII(@char) BETWEEN 97 AND 122
        SET @lower += @char;
    ELSE IF ASCII(@char) BETWEEN 48 AND 57
        SET @number += @char;
    ELSE
        SET @other += @char;
    
    SET @i += 1;
END

SELECT 
    @upper AS UppercaseLetters,
    @lower AS LowercaseLetters,
    @number AS Numbers,
    @other AS OtherCharacters;

--16. Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)
SELECT
  StudentID,
  FullName,
  Grade,
  SUM(Grade) OVER (ORDER BY StudentID ROWS UNBOUNDED PRECEDING) AS RunningTotalGrade
FROM Students
ORDER BY StudentID;

--17. You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)
DECLARE @Equation VARCHAR(200);
DECLARE @SQL NVARCHAR(MAX);
DECLARE @Result INT;

DECLARE cur CURSOR FOR
    SELECT Equation FROM Equations;

CREATE TABLE #Results (
    Equation VARCHAR(200) PRIMARY KEY,
    TotalSum INT
);
OPEN cur;
FETCH NEXT FROM cur INTO @Equation;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'SELECT @ResultOut = ' + @Equation;
    EXEC sp_executesql
        @SQL,
        N'@ResultOut INT OUTPUT',
        @ResultOut = @Result OUTPUT;
    INSERT INTO #Results (Equation, TotalSum)
    VALUES (@Equation, @Result);
    FETCH NEXT FROM cur INTO @Equation;
END
CLOSE cur;
DEALLOCATE cur;
SELECT * FROM #Results ORDER BY Equation;
DROP TABLE #Results;

--18. Given the following dataset, find the students that share the same birthday.(Student Table)
SELECT 
    StudentName,
    Birthday
FROM Student
WHERE Birthday IN (
    SELECT Birthday
    FROM Student
    GROUP BY Birthday
    HAVING COUNT(*) > 1
)
ORDER BY Birthday, StudentName;

--19. You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)
SELECT
  CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1,
  CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2,
  SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY
  CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
  CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END
ORDER BY Player1, Player2;
