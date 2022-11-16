/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [EmployeeID]
      ,[Jobtitle]
      ,[Salary]
  FROM [SQL Tutorial].[dbo].[EmployeeSalary]

  --SELECT Firstname, Lastname, Age,
  --(CASE
  --    WHEN Age > 30 THEN 'Old'
	 -- WHEN Age BETWEEN 27 AND 30 THEN 'Young'
	 -- ELSE 'Baby'
  --END)
  --FROM EmployeeDemographics
  --WHERE Age IS NOT NULL
  --ORDER BY Age 

  SELECT EmployeeID, Jobtitle, Salary
  FROM EmployeeSalary
  WHERE EmployeeID in (
        SELECT      
  
  )
 