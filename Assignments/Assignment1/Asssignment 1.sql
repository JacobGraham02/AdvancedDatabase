/* Assignment 1 
   Worth 7.5%
   
   Assignment is out of 100
   
   Complete all of the questions in this SQL file and submit the file for grading
                
                Open this file in SQL Workbench to complete all of the statements
                
                Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
                You will need it to create the queries based on these tables
                
                There is a .jpg file which shows the tables in the database

*/



/* Union, Arithmetic and Subquery Questions :
Question 1 (8 marks)
Create a query that lists Last name,  Salary, Salary increased by 3 percent, Monthly salary (hint :divide by 12) increased by 5 percent.  
Limit the result to employees whose salary * 1.05, is less than or equal to $55,000 and their LASTNAME contains a N .  Sort the list by annual salary desc and last name . 
(Should get 13 rows) (Tables used EMPLOYEE)
*/


/*Question 2 (8 marks)
Create a query that lists department number, last name, salary. Select all employees matching the following criteria: 
->They belong to department D11
->Salary is more than or equal to 60 percent of $10,500 
->Salary is less than or equal to 125 percent of $75,000 
-> Sort the list by workdept , LASTNAME DESC, salary
(Should get 11 rows) (Tables used EMPLOYEE)
*/



/*Question 3 (9 marks)
Create a query that lists the department number, employee number, and salaries of all employees in department D11.  
UNION the same information , but this time sum up all the salaries to create a one line summary entry for the D11 department (hint sum the salary).  Sort the list by Salary.
(Should get 12 rows including summary) (Tables used EMPLOYEE)
*/




/*
Question 4  (15 marks)
Create a query that lists the lastnme, edlevel , job, the number of years they've worked as of Jan 01/2001 ( hint : year function Jan 01/2001 minus hiredate), and their salary.  
Get the employees that have the same Job and Education level  as the employees first named starts with R  
(hint sub-select from employee    ie (job, edlevel ) =    ). Sort the listing by highest salary first.  
(Should get 4 rows) (Tables used EMPLOYEE)
*/





/* 
Join Questions :

Question 5 (15 marks)
Create a query that lists actno, deptno, deptname, lastname and firstnme of employees making more than $30000, and department A00. Then right join to the empprojact table 
(Should get 4 rows) (Tables used EMPLOYEE, DEPARTMENT, EMPPROJACT)
*/





/*
Question 6 (15 marks)
Create a query that lists actno, emstdate, mgrno, projno, firstnme, lastname. Where emstdate is greater than July 6,2002. Order the list the activity number and the emstdate.   
The PROJECT table must be replaced by the following query (  select projno, deptno from PROJECT where deptno = 'E01' )  and left join between the PROJECT select table and department.
(Should get 19 rows) (Tables used EMPLOYEE, DEPARTMENT, EMPPROJACT PROJECT)
*/





/*
Question 7 (15 marks)
Create a query that lists empno, projno, emptime, emendate. Where emptime is less than 2.  
Left join the project to the empprojact table and LEFT join the act table and then right join employee table. Where projno is AD3113 
and empno is 000270
 (Should get 7 rows) (Tables used PROJECT, ACT, EMPPROJACT, EMPLOYEE)
*/






 
/*
Question 8 (15 marks)
Create the DDL for the tables.png file included in the Assignment 1 folder:

 */

