/* Assignment 3
   Worth 7.5%
   
   Assignment is out of 100
   
   Complete all of the questions in this SQL file and submit the file for grading
                
                Open this file in SQL Workbench to complete all of the statements
                
                Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
                You will need it to create the queries based on these tables
                
                There is a .jpg file which shows the tables in the database

*/
USE sample;
SET SQL_SAFE_UPDATES = 0;
/*
Question 1 (15 marks)

Create a stored procedure (P_TOTAL_PRICES) that has one OUT parameter (n_total_price).  
Use a loop to iterate through the records in the PRODUCT table.   
Add each price to n_total_price, on each iteration, to output the total cost of the products in the PRODUCTS table.
*/
DELIMITER //
CREATE PROCEDURE P_TOTAL_PRICES (OUT n_total_price DECIMAL(30,2)) 
	BEGIN	
		DECLARE N_PRICE DECIMAL(30,2);
        DECLARE FOUND BOOLEAN DEFAULT TRUE;
        
        DECLARE C_PRICE CURSOR FOR
			SELECT price
            FROM product;
            
        DECLARE CONTINUE HANDLER FOR NOT FOUND
			SET FOUND = FALSE;
            
		OPEN C_PRICE;
        
        SET n_total_price = 0.00;
        WHILE FOUND DO
			FETCH C_PRICE INTO N_PRICE;
			SET n_total_price = n_total_price+N_PRICE;
		END WHILE;
	
    CLOSE C_PRICE;
END
//
CALL P_TOTAL_PRICES(@Z);
SELECT(@Z);			
/*
Question 2 (25 marks)

Create a stored procedure (P_DEL_D11) that CREATES a GLOBAL TEMPORARY TABLE, that is based on the following query 
(SELECT distinct firstname as fname, lastname as lname,workdept as deptnum FROM employee e).  
Then issues a DELETE on the  TEMPORARY table deleting records with deptnum = D11.
*/
DELIMITER //
CREATE PROCEDURE P_DEL_D11()
	BEGIN
		CREATE TEMPORARY TABLE t_emp_info
        SELECT DISTINCT firstnme AS fname, lastname AS lname, workdept AS deptnum
        FROM employee;
        DELETE FROM t_emp_info
        WHERE deptnum = 'D11';
	END
//
CALL P_DEL_D11;
SELECT * FROM t_emp_info;

/*
Question 3 (25 marks) 

Create a stored procedure ( P_DYN_TABLE) that creates a table DYNAMICALLY by having 2 input parameters, 1 which is the SOURCE table for that new table, 
and the second input is the name of the new table.  You will need to define two statements, 1 for the structure of the table, 
AND 1 statement to populate it (Hint for the first statement you will need to build the CREATE statement by concatenating the NEW table name and the SOURCE table.  
For the second statement you will need to use the PREPARE and EXECUTE commands. ).
*/
DELIMITER //
CREATE PROCEDURE P_DYN_TABLE(IN srcTable VARCHAR(30), IN tableName VARCHAR(30))
	LANGUAGE SQL
    BEGIN
		DECLARE new_name VARCHAR(100);
        DECLARE stmt VARCHAR(1000);
        
        DECLARE CONTINUE HANDLER FOR SQLSTATE '42704' -- sql error for undefined object name
			SET stmt = '';
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 	
			SET table_name = "PROCEDURE_FAILED";
            
-- 		SET new_name = CONCAT(srcTable, '_tbl');
 			
            SET @stmt = CONCAT('CREATE TABLE ' , new_name, ' LIKE ' tableName); 
            SET @stmt2 = CONCAT('INSERT INTO ' , new_name, ' SELECT * FROM ' tableName);
            PREPARE s2 FROM @stmt;
            PREPARE s3 FROM @stmt2;
            EXECUTE s2;
            EXECUTE s3;
            
            SET table_name = CONCAT(new_name, ' CREATED SUCCESSFULLY');
	END
//
    
 
/*  
Question 4 (40 marks) 
Write a statement to create a Table called  GREAT_SALES with the same columns as the SALES table.
Write a statement to create a Table called  POOR_SALES with the same columns as the SALES table.

Create a stored procedure ( P_SALES_TYPES) that creates a cursor that SELECTS  SALES_PERSON, REGION and sums up SALES.  
Open the cursor and iterate through the  rows and INSERT a record in the GREAT_SALES table if sales are >= 10 otherwise INSERT into the POOR_SALES table.
If a cursor has row with sales > 10, insert that entire row into GREAT_SALES
If sales < 10, insert entire row into POOR_SALES
*/
CREATE TABLE GREAT_SALES LIKE SALES;
CREATE TABLE POOR_SALES LIKE SALES;

DELIMITER //
CREATE PROCEDURE P_SALES_TYPES() 
	BEGIN
		DECLARE V_RANDOMNAME VARCHAR(15);
        DECLARE V_REGION VARCHAR(15);
        DECLARE N_SALES int;
        DECLARE D_SALESDATE DATE;
        
		DECLARE FOUND BOOLEAN DEFAULT TRUE;
        
        DECLARE C_SALES CURSOR FOR
			SELECT SALES_DATE, SALES_PERSON, REGION, SALES
            FROM sales;
            
        DECLARE CONTINUE HANDLER FOR NOT FOUND
			SET FOUND = FALSE;
            
		OPEN C_SALES;
			WHILE FOUND DO
				FETCH C_SALES INTO D_SALESDATE, V_RANDOMNAME, V_REGION, N_SALES;
					IF (N_SALES >= 10) THEN
						INSERT INTO GREAT_SALES VALUES (D_SALESDATE, V_RANDOMNAME, V_REGION, N_SALES);
					ELSEIF (N_SALES < 10) THEN
						INSERT INTO POOR_SALES VALUES (D_SALESDATE, V_RANDOMNAME, V_REGION, N_SALES);
					END IF;
			END WHILE;
				
        CLOSE C_SALES;
        
	END
//
CALL P_SALES_TYPES;
SELECT * FROM POOR_SALES;