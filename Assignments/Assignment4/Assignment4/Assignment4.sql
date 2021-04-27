/* Assignment 4
   Worth 7.5%
   
   Assignment is out of 80
   
   Complete all of the questions in this SQL file and submit the file for grading
                
                Open this file in SQL Workbench to complete all of the statements
                
                Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
                You will need it to create the queries based on these tables
                
                There is a .jpg file which shows the tables in the database

*/
USE sample;
/*
General Questions on Triggers and Functions (Total marks 20)

Question 1: What is a definition of a trigger?(2 marks) 

A MySQL trigger is a stored program, with queries, that is executed automatically in response to a specific event performed on a table.
Examples being BEFORE or AFTER INSERT, DELETE, or UPDATE clauses on tables

Question 2:  What are the 2 types of triggers?(2 marks)

SQL trigger and external trigger

Question 3:  Each type of trigger can be activated / fired in 3 ways.  What are the 3 ways to activate a trigger? (3 marks)

BEFORE, AFTER, INSTEAD OF

Question 4:  Name 2 benefits of using triggers? ( 3 marks )

Alternative way to run scheduled tasks, because they are invoked automatically BEFORE or AFTER a change is made to data in a table
They handle errors from the database layer

Question 5:  What are the 2 main differences in using Functions when compared to Stored Procedures? ( 2 marks )

Functions must return a single value, where a stored procedure can return 0, 1, or multiple values
A transaction cannot be used inside a function, while in a stored procedure can be used

Question 6: What is a definition of a user-defined function?( 2 marks)

Routines that accept parameters, perform an action such as a calculation, and returns the result of that calculation
Extending MySQL with a new function that works like a native MySQL function. 

Question 7:  What are the 3 types of user-defined functions? (3 marks)

Scalar-valued
Table-valued
Multi-statement table-valued

Question 8:  Name 2 benefits of using user-defined functions.(2 marks)

Help decompose a large program into small segments which makes a program easier to understand

*/


 

/*
Create Trigger and Function Questions (Total marks 60)
Question 1 (10 marks)

Create a trigger called SALARY_CHANGE_UPD.   

It is an AFTER UPDATE TRIGGER on the SALARY COLUMN OF THE EMPLOYEE TABLE.   
Compare the OLD salary record with the NEW record to check whether they are different and whether the salary has been increased more than 10%.   
If they are INSERT a record into the following table, which you will have to create :

CREATE TABLE SALARY_CHANGES(EMPNO NUMBER, NEW_SALARY DECIMAL (10,2), OLD_SALARY DECIMAL(10,2), GREATER_THAN_10 BOOLEAN, TIMESTMP DATE);
*/
DELIMITER //
CREATE TRIGGER SALARY_CHANGE_UPD
	AFTER UPDATE ON EMPLOYEE FOR EACH ROW
		BEGIN
			IF ((OLD.SALARY != NEW.SALARY) AND (OLD.SALARY * 1.1 > NEW.SALARY)) THEN
				INSERT INTO SALARY_CHANGES (EMPNO, NEW_SALARY, OLD_SALARY, GREATER_THAN_10, CUR_TIME) 
                VALUES (1, 78000.25, 77000.25, TRUE, CURRENT_TIMESTAMP());
            END IF;
		END;
    //
    
CREATE TABLE SALARY_CHANGES (
EMPNO INT,
NEW_SALARY DECIMAL(10,2),
OLD_SALARY DECIMAL(10,2),
GREATER_THAN_10 BOOLEAN,
TIMESTAMP date
);

/*
Question 2 (10 marks)
Create a trigger called PREVENT_UPDATE.   
It is a BEFORE UPDATE TRIGGER on the HIREDATE COLUMN OF THE EMPLOYEE TABLE.   
Compare to see if the old  HIREDATE  with the NEW record to check whether they are different.   
If they are PREVENT the update from happening by creating an error (hint use SIGNAL SQLSTATE).
*/
DELIMITER //
CREATE TRIGGER PREVENT_UPDATE
	BEFORE UPDATE ON EMPLOYEE FOR EACH ROW
		BEGIN
			DECLARE hiredates_not_equal CONDITION FOR SQLSTATE '45000';
			IF (OLD.HIREDATE <> NEW.HIREDATE) THEN
				SIGNAL hiredates_not_equal SET MESSAGE_TEXT = 'New and old hire dates are not equal';
			-- On HIREDATE column, check if OLD and NEW HIREDATE are different. If so, create an SQLSTATE update 				
            END IF;
        END
	//


/* 
Question 3 (5 marks)
Create a user-defined function (F_COUNT_EDUCATION)  to do the following:
	It will accept 1 input Education Level.   Create a SELECT COUNT the number of employees in the EMPLOYEE table that have an education level 
    greater than the one passed to the function and return that number from the function.
*/
DELIMITER //
CREATE FUNCTION F_COUNT_EDUCATION (EDUCATION_LEVEL MEDIUMINT UNSIGNED)
	RETURNS MEDIUMINT DETERMINISTIC
		BEGIN
			DECLARE emps MEDIUMINT;
		-- SELECT COUNT(*) INTO c1 AS 'Employees with education higher than input' WHERE EMPLOYEE.EDLEVEL > EDUCATION_LEVEL;
        SELECT COUNT(*) INTO emps FROM EMPLOYEE WHERE EMPLOYEE.EDLEVEL > EDUCATION_LEVEL;
        
        RETURN emps;
	END
	//
    
SELECT F_COUNT_EDUCATION(1);
DROP FUNCTION IF EXISTS F_COUNT_EDUCATION;
/*
Question 4 (10 marks)
	Create a user-defined function (F_EMPLOYEE_COST)  to do the following:
The function needs one input EMPLOYEE NUMBER.   With that number SELECT the EMPTIME for that employee into a variable FROM the EMPROJACT table.   (put in variable)
Then Create a new select that will Multiply that EMPTIME value by the COMM column, then  add the SALARY and BONUS columns from the EMPLOYEE table for that 
EMPLOYEE to get a return a total cost for that employee.

*/
DELIMITER //
CREATE FUNCTION F_EMPLOYEE_COST (EMPLOYEE_NUMBER MEDIUMINT UNSIGNED)
	RETURNS DECIMAL(9,2) DETERMINISTIC
		BEGIN
			DECLARE emp_time_from_empprojact DECIMAL(9,2);
				SELECT EMPTIME INTO emp_time_from_empprojact FROM EMPPROJACT WHERE EMPLOYEE_NUMBER = EMPNO;
                SELECT emp_time_from_empprojact * COMM INTO emp_time_from_empprojact FROM EMPLOYEE WHERE EMPLOYEE_NUMBER = EMPNO;
				SET emp_time_from_empprojact = (SELECT SALARY + BONUS FROM EMPLOYEE WHERE EMPLOYEE_NUMBER = EMPNO);
			RETURN emp_time_from_empprojact;
        END	
        //
SELECT F_EMPLOYEE_COST(100);
DROP FUNCTION IF EXISTS F_EMPLOYEE_COST;
/*

Question 5 (10 marks )

First : Create a user-defined function (F_CONVERT_TO_EURO)  to do the following:

Convert a Canadian dollar amount to a Euro amount.  You can use the conversion formula 1 CDN Dollar = 0.72 Euros.

The input and output need to be DECIMAL types but you can use whatever size of DECIMAL you want as long as you have 2 decimal places.

    Second :  Create a store procedure (P_STAFF_COSTS_EURO) that selects Name, Department, Salary and Comm from the Staff table.     
    Sum up Salary and Comm for each Name and Department and convert those values to Euro and return records (hint return the select) from the stored procedure.
*/
DELIMITER //
CREATE FUNCTION F_CONVERT_TO_EURO(input DECIMAL(10,2))
	RETURNS DECIMAL(10,2) DETERMINISTIC
		BEGIN
			DECLARE output DECIMAL(10,2);
			SET output = input * 0.72;
            RETURN output;
		END
	//
SELECT F_CONVERT_TO_EURO(100);

DELIMITER //
CREATE PROCEDURE P_STAFF_COSTS_EURO() 
	BEGIN
        SELECT name, dept, F_CONVERT_TO_EURO(SUM(salary)) AS 'sum_salary', F_CONVERT_TO_EURO(SUM(comm)) AS 'sum_comm' 
		FROM staff
		GROUP BY dept;
    END
    //
CALL P_STAFF_COSTS_EURO;

/*
Question 6 (15 marks )

Create a user-defined function (F_GET_LET_NUMB) to do the following:
	It will accept 2 inputs DATA_STRING and L_OR_N.    The DATA_STRING will be a varchar with letters and numbers.   
    The value of L_OR_N will be NUMBER or LETTER.    
	Your function will strip out all the Numbers or all the Letters in the string and return them.  
(Hint : in ('1','2','3','4','5','6','7','8','9','0') )
*/
-- DATA_STRING is the string passed into function that will be stripped
-- L_OR_N dictates whether the returned string will contain letters or numbers
DELIMITER //
CREATE FUNCTION F_GET_LET_NUM(DATA_STRING VARCHAR(50), L_OR_N VARCHAR(6)) 
	-- Keep iterating one character forward until you find a character that is not allowed, then replace or skip it. 
	RETURNS VARCHAR(50) DETERMINISTIC
		BEGIN
			DECLARE RESULT_STRING VARCHAR(50);
            
            IF (length(DATA_STRING) > 0) THEN
				
		END
    //