/*Lab Assignment 1 
   Worth 2%
   
   Complete all of the questions in this SQL file and submit the file for grading
                
		Open this file in SQL Workbench to complete all of the statements
                
		Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
		You will need it to create the queries based on these tables
                
		There is a .jpg file which shows the tables in the database
*/
USE sample;


/*  1.	Create a query that uses the empprojact table and lists projno and emptime.  
          That totals up the emptime by projno and excludes actno (10 and 60) ( 14 rows)
          
		Write a query that uses the empprojact table and lists projno and emptime, and adds up each project's total emptime, excluding actno 10 and 60
        Must be unique
*/
/* WRITE ANSWER HERE */
SELECT DISTINCT projno, SUM(emptime)
FROM empprojact
WHERE actno != 10 AND actno != 60
GROUP BY projno;

/*
2. Create a query that links all the records from both of these queries:
	- A query that uses the project table and lists  projname, deptno and prstdate.  Exclude majproj = AD3110
	- A query that uses the sales table and lists  sales_person, region, sales_date from the sales table. Include all the Ontario Regions and Quebec	
    (Hint UNION) (46 rows)
    
    UNION ALL will not eliminate duplicate values
    UNION will eliminate duplicate values
*/
-- Query 1:
SELECT DISTINCT projname, deptno, prstdate
FROM project
WHERE majproj <> 'AD3110';

-- Query 2: 
SELECT DISTINCT region, sales_person, sales_date
FROM sales
WHERE region LIKE "Ontario%"
OR region LIKE "Quebec%";

-- Fully unioned statement
SELECT DISTINCT projname, deptno, prstdate
FROM project
WHERE majproj <> 'AD3110'
UNION 
SELECT DISTINCT region, sales_person, sales_date
FROM sales
WHERE region LIKE "Ontario%"
OR region LIKE "Quebec%";

/*
Joins

3. Create a query that  selects projno, emstdate, emendate.  Limit the query by employees that have an edlevel 12 or greater and are greater than 30 years old.
(Hint use the YEAR function and the BIRTHDATE column)
 (Tables EMPLOYEE, EMPPROJACT) (61 rows)
*/

SELECT empprojact.projno, empprojact.emstdate, empprojact.emendate, employee.birthdate
FROM empprojact
LEFT JOIN employee
ON empprojact.empno = employee.empno
WHERE employee.edlevel >= 12 AND (2020-YEAR(employee.birthdate) > 30);

/*
4. Create a query that lists actno, actdesc, emptime, projno  where projno is MA2112 and actno > 50 
          (Tables used ACT, EMPPROJACT)  (6 rows) */
-- Table ACT has actno, actdesc
-- Table EMPPROJACT has emptime, projno
SELECT empprojact.actno, act.actdesc, empprojact.emptime, empprojact.projno
FROM act
LEFT JOIN empprojact
ON act.actno = empprojact.actno
WHERE act.actno > 50 
AND empprojact.projno = "MA2112";

/*
5.   Create a query that lists deptno, lastname, projname, and actno for those employees in work departments C01 through D11.  Sort the list by department number, last name, and activity number. 
           (Tables used EMPLOYEE, PROJECT, EMPPROJACT)  (27 rows) 
           use BETWEEN operator 
           WHERE GRADE BETWEEN 80 AND 90
           EMPLOYEE - lastname
           PROJECT - deptno, projname
           EMPPROJACT - actno
           project and empprojact have the column projno. 
           employee and empprojact have empno column. 
*/
SELECT project.deptno, employee.lastname, project.projname, empprojact.actno
FROM project 
	INNER JOIN empprojact ON project.projno = empprojact.projno
    INNER JOIN employee ON employee.empno = empprojact.empno
WHERE project.deptno BETWEEN 'C01' AND 'D11'
ORDER BY project.deptno, employee.lastname, empprojact.actno;