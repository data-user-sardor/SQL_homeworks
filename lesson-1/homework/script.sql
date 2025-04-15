--1
Data:
Raw facts or figures that have not been processed or organized. 
Examples include numbers, text, images, or audio that can be collected and used for analysis or reference.
Database:
An organized collection of data stored electronically, designed to be easily accessed, managed, and updated. 
It allows for efficient retrieval, insertion, and deletion of data.
Relational Database:
A type of database that stores data in structured tables with rows and columns. 
It uses relationships between tables through keys (like primary and foreign keys)
and supports powerful querying with SQL (Structured Query Language).
Table:
A structure within a relational database that organizes data into rows and columns. 
Each row represents a record, and each column represents a field or attribute of the data.
--2
Here are five key features of SQL Server:
1)Data Storage and Management;
2) Backup and Recovery;
3) In-Memory Processing;
4) Data Types and Rich Functions;
5) Virtual tables based on SQL. 
--3
1)Windows Authentication;
2)SQL Server Authentication.
--4
CREATE DATABASE SchoolDB;
use SchoolDB;
go
--5
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT); 
	select * from Students
--6
1) SQL Server
-What it is: A Relational Database Management System (RDBMS) developed by Microsoft;
-Purpose: Stores, manages, and processes data using a database engine;
-Functionality: Handles data storage, security, transactions, backup, and much more;
-Think of it as: The backend system that runs and manages the actual databases.
2) SSMS (SQL Server Management Studio)
-What it is: A graphical user interface (GUI) tool for managing SQL Server instances;
-Purpose: Helps users interact with SQL Server visually—write queries, manage databases, configure security, and more;
-Functionality: Offers tools for writing SQL scripts, viewing data, managing jobs, backups, and performance;
-Think of it as: The control panel or dashboard for working with SQL Server.
3) SQL (Structured Query Language)
-What it is: A programming language used to communicate with databases;
-Purpose: Allows you to create, read, update, and delete data (CRUD operations);
-Functionality: Includes statements like SELECT, INSERT, UPDATE, DELETE, CREATE, and DROP;
-Think of it as: The language you speak to tell SQL Server what to do;
Quick Analogy:
SQL Server is the engine,
SSMS is the dashboard,
SQL is the language you use to drive it.
--7
1) DQL (Data Query Language)
Purpose: Retrieve data from the database.
Main command: SELECT
Example:
SELECT * FROM Employees;
2) DML (Data Manipulation Language)
Purpose: Modify data in existing tables.
Commands: INSERT, UPDATE, DELETE
Examples:
INSERT INTO Employees (Name, Age) VALUES ('Jasur', 30);
UPDATE Employees SET Age = 31 WHERE Name = 'Jasur';
DELETE FROM Employees WHERE Name = 'Jasur';
3) DDL (Data Definition Language)
Purpose: Define or modify the structure of database objects (tables, schemas, etc.).
Commands: CREATE, ALTER, DROP, TRUNCATE
Examples:
CREATE TABLE Employees (ID INT, Name VARCHAR(50), Age INT);
ALTER TABLE Employees ADD Salary DECIMAL(10,2);
DROP TABLE Employees;
4)DCL (Data Control Language)
Purpose: Control access and permissions to data.
Commands: GRANT, REVOKE
Examples:
GRANT SELECT, INSERT ON Employees TO User1;
REVOKE INSERT ON Employees FROM User1;
5) TCL (Transaction Control Language)
Purpose: Manage transactions to ensure data integrity.
Commands: COMMIT, ROLLBACK, SAVEPOINT
Examples:
BEGIN TRANSACTION;
UPDATE Employees SET Salary = 5000 WHERE ID = 1;
COMMIT OR ROLLBACK; --if something goes wrong
SAVEPOINT BeforeUpdate;
UPDATE Employees SET Salary = 6000 WHERE ID = 1;
ROLLBACK TO BeforeUpdate;
--8
INSERT INTO Students (StudentID, Name, Age)
VALUES 
(1, 'Jahongir', 20),
(2, 'Sevara', 22),
(3, 'Bobur', 19);
SELECT * FROM Students;
--9
A. Backup the SchoolDB Database
Using SQL Server Management Studio (SSMS):
1) Open SSMS and connect to your SQL Server instance.
2) In Object Explorer, expand Databases, right-click on SchoolDB.
3) Select Tasks > Back Up…
4) In the Back Up Database window:
-Ensure SchoolDB is selected.
-Backup Type: Choose Full.
-Backup to: Click Remove, then Add to choose a file path (e.g., C\Backups\SchoolDB.bak)
5) Click OK to start the backup.
6) A success message will appear once the backup is completed.

B. Restore the SchoolDB Database
Using SQL Server Management Studio (SSMS):
1) In Object Explorer, right-click on Databases and select Restore Database…
2) In the Restore Database window:
-Select Device, then click the … button.
-Add the backup file (e.g., C:\Backups\SchoolDB.bak)
3) In the Destination section, set the database name (e.g., SchoolDB_Restore).
4) Go to the Options page (on the left) and check:
-Overwrite the existing database (if you’re restoring over an existing one)
-Or adjust the restore path if needed.
5) Click OK to begin the restore.
6) A confirmation message will appear when the restore is successful.
