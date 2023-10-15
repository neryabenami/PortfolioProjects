--Our Data
SELECT *
FROM Table1

SELECT *
FROM Table2


--Average salary
SELECT ROUND(AVG(Salary),2) AS Total_Average_Salary
FROM Table2
WHERE Salary is not null 


--Average age
SELECT ROUND(AVG(Age),2) AS Total_Average_Age
FROM Table2


--The number of people who came through linkedIn/friends
SELECT
SUM(CASE WHEN [Arrival To Work]='linkedin' THEN 1 ELSE 0 END ) AS Total_Linkedin,
SUM(CASE WHEN [Arrival To Work]='Friends' THEN 1 ELSE 0 END ) AS Total_Friends
FROM table1


--The number of women/men
SELECT 
SUM(CASE WHEN Gender='Male' THEN 1 ELSE 0 END ) AS Total_Male, 
SUM(CASE WHEN Gender='Female' THEN 1 ELSE 0 END ) AS Total_Female
FROM table1


--Salaries from high to low
SELECT A.Id, A.Gender, A.[Years of Experience], A.[Academic Degree], B.Salary
FROM Table1 A
LEFT JOIN Table2 B
ON A.Id = B.id
WHERE Salary is not null
ORDER BY Salary DESC


--[Corona layoffs]
SELECT [Corona layoffs], COUNT(*) 
FROM Table1
GROUP BY [Corona layoffs]


--Counting by degree
SELECT
SUM(CASE WHEN [Academic Degree]='Behavioral Sciences' THEN 1 ELSE 0 END ) AS Total_Behavioral_Sciences,
SUM(CASE WHEN [Academic Degree]='Economics' THEN 1 ELSE 0 END ) AS Total_Economics,
SUM(CASE WHEN [Academic Degree]='Statistics' THEN 1 ELSE 0 END ) AS Total_Statistics,
SUM(CASE WHEN [Academic Degree]='Industrial Engineering' THEN 1 ELSE 0 END ) AS Total_Industrial_Engineering,
SUM(CASE WHEN [Academic Degree]='Computer Science' THEN 1 ELSE 0 END ) AS Total_Computer_Science,
SUM(CASE WHEN [Academic Degree]='Business Administration' THEN 1 ELSE 0 END ) AS Total_Business_Administration,
SUM(CASE WHEN [Academic Degree]='Other' THEN 1 ELSE 0 END ) AS Total_Other,
SUM(CASE WHEN [Academic Degree]='No Degree' THEN 1 ELSE 0 END ) AS Total_No_Degree
FROM table1


--Salary range
SELECT
SUM(CASE WHEN salary between 0 and 10000 THEN 1 ELSE 0 END ) AS '0-10',
SUM(CASE WHEN salary between 11000 and 15000 THEN 1 ELSE 0 END ) AS '11-15',
SUM(CASE WHEN salary between 16000 and 20000 THEN 1 ELSE 0 END ) AS '16-20',
SUM(CASE WHEN salary between 21000 and 25000 THEN 1 ELSE 0 END ) AS '21-25 ',
SUM(CASE WHEN salary between 26000 and 30000 THEN 1 ELSE 0 END ) AS '26-30 ',
SUM(CASE WHEN salary >30000 THEN 1 ELSE 0 END ) AS '30'
FROM table2


--Use CTE
--Only the men who live in the center and have a salary between 15000 and 20000
WITH Salary1 AS (
SELECT A.Id, A.Gender, A.[Years of Experience], A.[Academic Degree],A.[Living Region], B.Salary
FROM Table1 A
LEFT JOIN Table2 B
ON A.Id = B.id
WHERE Salary is not null
),
Salary2 AS (
SELECT *
FROM Salary1
WHERE Gender = 'male' and [Living Region]='Center' and Salary Between 15000 and 20000
)
SELECT * 
FROM Salary2


--Division of users according to artificial intelligence tools
SELECT [Visualization Tools], COUNT(*) AS Total_User
FROM Table1
GROUP BY [Visualization Tools]
ORDER BY Total_User DESC


--Use subquery
--People over the age of 20 with more than 10 years of work experience and who hold options
SELECT Id, Salary,Age
FROM Table2
WHERE Age > 20 and Id in

(SELECT Id
FROM Table1
WHERE [Years of Experience] >10 and [Options ] = 'Yes')


--Creating a table for side calculation
--Presentation of salaries from lowest to highest and by degree
Create Table #temp12 (
[Academic Degree] nvarchar(255),
salary nvarchar(255),
)
Insert Into #temp12
SELECT a.[Academic Degree], b.Salary
FROM Table1 a
LEFT JOIN Table2 b
ON a.Id = b.id
WHERE Salary is not null

SELECT *
FROM #temp12
ORDER BY [Academic Degree], salary  




