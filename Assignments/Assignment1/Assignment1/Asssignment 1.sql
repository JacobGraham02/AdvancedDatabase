/* Assignment 1 
   Worth 7.5%
   
   Assignment is out of 100
   
   Complete all of the questions in this SQL file and submit the file for grading
                
   Open this file in SQL Workbench to complete all of the statements
                
	Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
	You will need it to create the queries based on these tables
                
	There is a .jpg file which shows the tables in the database

*/
DROP DATABASE sample;
USE sample;
/* Union, Arithmetic and Subquery Questions :
Question 1 (8 marks)
Create a query that lists Last name,  Salary, Salary increased by 3 percent, Monthly salary (hint :divide by 12) increased by 5 percent.  
Limit the result to employees whose salary * 1.05, is less than or equal to $55,000 and their LASTNAME contains a N .  Sort the list by annual salary desc and last name . 
(Should get 13 rows) (Tables used EMPLOYEE)
*/
SELECT LASTNAME, SALARY, ROUND((SALARY * 1.03),2) AS 'Salary increased by 3 percent', 
ROUND(((salary / 12) * 1.05), 2) AS 'Monthly salary increased by 5 percent'
FROM employee WHERE salary <= 55000 AND lastname LIKE "%N%"
ORDER BY salary DESC, lastname;

/*Question 2 (8 marks)
Create a query that lists department number, last name, salary. Select all employees matching the following criteria: 
->They belong to department D11

->Salary is more than or equal to 60 percent of $10,500 => 6,300
->Salary is less than or equal to 125 percent of $75,000 => 93,750
-> Sort the list by workdept , LASTNAME DESC, salary
(Should get 11 rows) (Tables used EMPLOYEE)
*/
SELECT workdept AS 'department number', lastname, salary 
FROM employee
WHERE workdept = 'D11' 
AND salary BETWEEN 6300 AND 93750
ORDER BY workdept, lastname DESC, salary;

/*Question 3 (9 marks)
Create a query that lists the department number, employee number, and salaries of all employees in department D11.  
UNION the same information , but this time sum up all the salaries to create a one line summary entry for the D11 department (hint sum the salary).  Sort the list by Salary.
(Should get 12 rows including summary) (Tables used EMPLOYEE)
*/
SELECT workdept, empno, salary
FROM employee
WHERE workdept='D11'
UNION
SELECT workdept, empno = null, SUM(salary) AS 'Summed salaries'
FROM employee
ORDER BY salary;

/*
Question 4  (15 marks)
Create a query that lists the lastname, edlevel , job, the number of years they've worked as of Jan 01/2001 ( hint : year function Jan 01/2001 minus hiredate), and their salary.  
Get the employees that have the same Job and Education level  as the employees first name starts with R  
(hint sub-select from employee    ie (job, edlevel ) =    ). Sort the listing by highest salary first.  
(Should get 4 rows) (Tables used EMPLOYEE)
*/
SELECT lastname, edlevel, job, YEAR("2001-01-01") - YEAR(hiredate) AS 'Years worked', salary 
FROM employee 
WHERE (job, edlevel) IN 
(SELECT job, edlevel FROM employee WHERE firstnme LIKE 'R%' 
AND YEAR("2001-01-01")-YEAR(hiredate) > 0)
ORDER BY salary DESC;

/* 
Join Questions :
Question 5 (15 marks)
Create a query that lists actno, deptno, deptname, lastname and firstnme of employees making more than $30000, and department A00. Then right join to the empprojact table 
(Should get 4 rows) (Tables used EMPLOYEE, DEPARTMENT, EMPPROJACT) INNER JOIN employee and department, right join to empprojact
*/

SELECT empprojact.actno, department.deptno, department.deptname, employee.firstnme, employee.lastname, employee.empno
FROM employee
INNER JOIN department
ON employee.workdept = department.deptno
RIGHT JOIN empprojact
ON employee.empno = empprojact.empno
WHERE employee.salary > 30000
AND employee.workdept = 'A00';

/*
Question 6 (15 marks)
Create a query that lists actno, emstdate, mgrno, projno, firstnme, lastname. Where emstdate is greater than July 6,2002. Order the list the activity number and the emstdate.   
The PROJECT table must be replaced by the following query (  select projno, deptno from PROJECT where deptno = 'E01' )  and left join between the PROJECT select table and department.
(Should get 19 rows) (Tables used EMPLOYEE, DEPARTMENT, EMPPROJACT, PROJECT)
1 query, 2 joins
*/
SELECT empprojact.actno, empprojact.emstdate, department.mgrno, employee.firstnme, employee.lastname
FROM employee
INNER JOIN department -- Join department with employee
ON employee.workdept = department.deptno
INNER JOIN empprojact -- Join empprojact with employee
ON employee.empno = empprojact.empno
LEFT JOIN (select projno, deptno from PROJECT where deptno = 'E01') AS project
ON project.projno = empprojact.projno -- Join project with empprojact
WHERE empprojact.emstdate > '2002-07-06'
ORDER BY empprojact.actno AND empprojact.emstdate;

/*
Question 7 (15 marks)
Create a query that lists empno, projno, emptime, emendate. Where emptime is less than 2.  
Left join the project to the empprojact table and LEFT join the act table and then right join employee table. Where projno is AD3113 
and empno is 000270
 (Should get 7 rows) (Tables used PROJECT, ACT, EMPPROJACT, EMPLOYEE)
*/
SELECT employee.empno, project.projno, empprojact.emptime, empprojact.emendate
FROM project 
LEFT JOIN empprojact -- Join empprojact with project
ON empprojact.projno = project.projno
RIGHT JOIN employee 
ON employee.workdept = project.deptno
WHERE empprojact.emptime < 2
AND empprojact.projno = 'AD3113' AND employee.empno = 000270;

/*
Question 8 (15 marks)
Create the DDL for the tables.png file included in the Assignment 1 folder:
 */
CREATE TABLE Products (
ProductID INT NOT NULL PRIMARY KEY,
ProductName VARCHAR(50) NOT NULL,
SupplierID INT NOT NULL,
CategoryID INT NOT NULL,
QuantityPerUnit INT NOT NULL,
UnitPrice DECIMAL(10, 2) NOT NULL,
UnitsInStock MEDIUMINT UNSIGNED NOT NULL,
UnitsOnOrder MEDIUMINT UNSIGNED NOT NULL,
ReorderLevel SMALLINT UNSIGNED NOT NULL,
Discontinued BOOLEAN NOT NULL
);

CREATE TABLE Order_Details (
OrderID INT NOT NULL,
ProductID INT NOT NULL,
UnitPrice DECIMAL(10, 2) NOT NULL,
Quantity MEDIUMINT UNSIGNED NOT NULL,
Discount INT UNSIGNED NOT NULL,
PRIMARY KEY (OrderID, ProductID)
);

CREATE TABLE Orders (
OrderID INT NOT NULL PRIMARY KEY,
CustomerID INT NOT NULL,
EmployeeID INT NOT NULL,
OrderDate DATETIME NOT NULL,
RequiredDate DATETIME NOT NULL,
ShippedDate DATETIME NOT NULL,
ShipVia VARCHAR(100) NOT NULL,
Freight VARCHAR(100) NOT NULL,
ShipName VARCHAR(100) NOT NULL,
ShipAddress VARCHAR(100) NOT NULL,
ShipCity VARCHAR(100) NOT NULL,
ShipRegion VARCHAR(100) NOT NULL,
ShipPostalCode VARCHAR(10) NOT NULL,
ShipCountry VARCHAR(100) NOT NULL
);

ALTER TABLE Order_Details
ADD FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);

ALTER TABLE Order_Details
ADD FOREIGN KEY (ProductID) REFERENCES Products(ProductID);



