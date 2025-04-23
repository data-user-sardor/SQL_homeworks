--1
1)SELECT distinct col1, col2
FROM InputTbl;
2)SELECT col1, col2
FROM InputTbl
GROUP BY col1, col2;
--2
SELECT * FROM TestMultipleZero
Where A<>0 or B<>0 or C<>0 or D<>0
--3
SELECT *
FROM section1
WHERE id % 2 = 1;
--4
SELECT *
FROM section1
WHERE id = (SELECT MIN(id) FROM section1);
--5
SELECT *
FROM section1
WHERE id = (SELECT Max(id) FROM section1);
--6
SELECT *
FROM section1
where name like 'b%'
--7
SELECT * 
FROM ProductCodes
WHERE code LIKE '%!_%' ESCAPE '!';
