--1. You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.
SELECT CONCAT(emp_id, '-', first_name, ' ', last_name) AS employee_info
FROM employees
WHERE emp_id = 100;

--2. Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'
UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');

--3. That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)
SELECT 
  first_name AS "First Name",
  LENGTH(first_name) AS "Name Length"
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
  year,
  GREATEST(Max1, Max2, Max3) AS highest_value
FROM 
  TestMax;

--6. Find me odd numbered movies and description is not boring.(cinema)
SELECT *
FROM cinema
WHERE MOD(id, 2) = 1
  AND description != 'boring';

--7. You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)
SELECT *
FROM SingleOrder
ORDER BY (id = 0), id;

--8. Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)
SELECT 
  COALESCE(col1, col2, col3) AS first_non_null
FROM 
  person;

--9. Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)
SELECT 
  PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS Firstname,
  PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS Middlename,
  PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS Lastname
FROM 
  Students;

--10. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)
SELECT *
FROM Orders
WHERE state = 'Texas'
  AND customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE state = 'California'
);

--11. Write an SQL statement that can group concatenate the following values.(DMLTable)
SELECT STRING_AGG(column_name, ', ') AS concatenated_values
FROM DMLTable;

--12. Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times.
SELECT *
FROM employees
WHERE LENGTH(CONCAT(first_name, last_name)) - LENGTH(REPLACE(CONCAT(first_name, last_name), 'a', '')) >= 3;

--13. The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)
SELECT 
  department_id,
  COUNT(employee_id) AS total_employees,
  ROUND(
    (SUM(CASE WHEN DATEDIFF(CURDATE(), hire_date) > 3 * 365 THEN 1 ELSE 0 END) / COUNT(employee_id)) * 100,
    2
  ) AS percentage_more_than_3_years
FROM 
  Employees
GROUP BY 
  department_id;

--14. Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)
SELECT 
    spaceman_id,
    job_description,
    DATEDIFF(CURDATE(), hire_date) AS experience_days
FROM 
    Personal
WHERE 
    job_description = 'Spaceman'
ORDER BY 
    experience_days DESC
LIMIT 1;  -- Most experienced

UNION ALL

SELECT 
    spaceman_id,
    job_description,
    DATEDIFF(CURDATE(), hire_date) AS experience_days
FROM 
    Personal
WHERE 
    job_description = 'Spaceman'
ORDER BY 
    experience_days ASC
LIMIT 1;  -- Least experienced

--15. Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.
SELECT
  -- Extract uppercase letters
  REGEXP_REPLACE('tf56sd#%OqH', '[^A-Z]', '') AS uppercase_letters,
  
  -- Extract lowercase letters
  REGEXP_REPLACE('tf56sd#%OqH', '[^a-z]', '') AS lowercase_letters,

  -- Extract numbers
  REGEXP_REPLACE('tf56sd#%OqH', '[^0-9]', '') AS numbers,

  -- Extract other characters (non-alphanumeric)
  REGEXP_REPLACE('tf56sd#%OqH', '[a-zA-Z0-9]', '') AS other_characters;

--16. Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)
SELECT 
  student_id,  -- Assuming you have an ID column
  value + COALESCE(LAG(value) OVER (ORDER BY student_id), 0) AS cumulative_sum
FROM 
  Students;

--17. You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)
SELECT SUM(CAST(YourColumn AS FLOAT)) AS TotalSum
FROM (
  SELECT eval(YourEquationColumn) AS YourColumn
  FROM YourTable) AS EvaluatedEquations;

--18. Given the following dataset, find the students that share the same birthday.(Student Table)
SELECT DateOfBirth, GROUP_CONCAT(StudentName) AS StudentsWithSameBirthday
FROM Student
GROUP BY DateOfBirth
HAVING COUNT(*) > 1;

--19. You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)
SELECT 
    LEAST(PlayerA, PlayerB) AS Player1, 
    GREATEST(PlayerA, PlayerB) AS Player2, 
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY LEAST(PlayerA, PlayerB), GREATEST(PlayerA, PlayerB)
ORDER BY Player1, Player2;
