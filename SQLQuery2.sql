/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT Firstname, Lastname, Salary, Jobtitle,
--CASE
--     WHEN Jobtitle LIKE 'Salesman' THEN Salary + (Salary * .10)
--	 WHEN Jobtitle LIKE 'Accountant' THEN Salary + (Salary * .05)
--	 WHEN Jobtitle LIKE 'H%' THEN Salary + (Salary * .000001)
--	 ELSE Salary + (Salary * .03)
--END AS SalaryAfterRaise
--  FROM EmployeeDemographics AS ED
--  RIGHT JOIN EmployeeSalary AS ES
--  ON ED.EmployeeID=ES.EmployeeID

SELECT Firstname, Lastname, Gender, Salary
, COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
FROM EmployeeDemographics Demo
JOIN EmployeeSalary Sal
ON Demo.EmployeeID=Sal.EmployeeID

SELECT Firstname, Lastname, Gender, Salary, COUNT(Gender) 
FROM EmployeeDemographics Demo
JOIN EmployeeSalary Sal
ON Demo.EmployeeID=Sal.EmployeeID
GROUP BY Firstname, Lastname, Gender, Salary

SELECT Gender, COUNT(Gender) 
FROM EmployeeDemographics Demo
JOIN EmployeeSalary Sal
ON Demo.EmployeeID=Sal.EmployeeID
GROUP BY Gender

SELECT * 
FROM EmployeeSalary;