/*Lab Assignment 4 
   Worth 2%
   
   Complete all of the questions in this SQL file and submit the file for grading
                
                Open this file in SQL Workbench to complete all of the statements
                
                Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
                You will need it to create the queries based on these tables
                
                There is a .jpg file which shows the tables in the database

*/
USE sample;

/*
1. Create a new stored procedure P_COMMISH_UPD that will update the commission column (COMM) of the employee table 
giving employees who currently get a commission >= 2000 to now get  a commission = 8000 and employees who currently 
get a commission < 2000 to now get a commission = 4000.

Use a CURSOR to grab columns EMPNO AND COMM, and read all the records from the EMPLOYEE table.

Use an IF statement to handle each of the conditions
*/ 
DELIMITER //
CREATE PROCEDURE P_COMMISH_UPD()
BEGIN
DECLARE N_COMM decimal(9,2);
DECLARE N_EMPNO char(6);
DECLARE FOUND BOOLEAN DEFAULT TRUE;

DECLARE C_EmpCommision CURSOR FOR
    SELECT EMPNO, COMM
    FROM employee;
    
DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET FOUND = FALSE;

OPEN C_EmpCommision;
    
WHILE FOUND DO
    FETCH C_EmpCommision INTO N_EMPNO, N_COMM;
    IF N_COMM >= 2000 THEN
            UPDATE EMPLOYEE
            SET COMM = 8000
            WHERE EMPNO = N_EMPNO;
    ELSEIF  N_COMM < 2000 THEN
        UPDATE EMPLOYEE
        SET COMM = 4000
        WHERE EMPNO = N_EMPNO;
    END IF;
END WHILE;

CLOSE C_EmpCommision;
    
END //
DELIMITER ;
CALL P_COMMISH_UPD();
/*
2. Create a procedure P_UPD_ACT_DSC 

Use a CURSOR to read all records from the ACT table.

Use a CASE statement to change each record read in by the FOR statement.  

In the CASE statement, check the ACTNO column:

             When the ACTNO value is < 70   then make ACTDESC = 'FIRST ACCOUNT'.
             When the ACTNO value is > 130  then make ACTDESC = 'THIRD ACCOUNT'.
             When the ACTNO value is other than those 2 choices then make ACTDESC = 'SECOND ACCOUNT'.
             DELIMITER //  
*/
DELIMITER //
CREATE PROCEDURE P_UPD_ACT_DSC()
	BEGIN
		DECLARE N_ACTNO INT;
        DECLARE N_ACTDESC VARCHAR(50);
        DECLARE FOUND BOOLEAN DEFAULT TRUE;
        
        DECLARE C_ACT_TABLE_ALL CURSOR FOR
			SELECT ACTNO, ACTDESC 
            FROM ACT;
		
        DECLARE CONTINUE HANDLER FOR NOT FOUND
			SET FOUND = FALSE;
            
		OPEN C_ACT_TABLE_ALL;
			
		WHILE FOUND DO
			FETCH C_ACT_TABLE_ALL INTO N_ACTNO, N_ACTDESC;
				UPDATE ACT SET N_ACTDESC = CASE
					WHEN N_ACTNO < 70 THEN 'FIRST ACCOUNT'
                    WHEN N_ACTNO > 70 THEN 'SECOND ACCOUNT'
                    ELSE 'SECOND ACCOUNT'
				END;
		END WHILE;
	END;
    //
/*
3.  Create a Stored Procedure P_DEPT_BONUS_LIST  that takes IN  parameter DEPARTMENT_NUMB CHAR(3) and OUT empno_bonus VARCHAR (4000)

Create a cursor that selects EMPNO,BONUS from the EMPLOYEE table based on the DEPTNO sent IN

Return the concatenated values of EMPNO and BONUS in empno_bonus separated by commas

000150500,000160400,000170500,000180500,000190400,000200600,000210400,000220600,200170500,200220600,000060500,

*/
DROP PROCEDURE P_DEPT_BONUS_LIST;
DELIMITER //
CREATE PROCEDURE P_DEPT_BONUS_LIST(IN DEPARTMENT_NUMBER CHAR(3), OUT empno_bonus VARCHAR(4000))
	BEGIN
		DECLARE N_EMPNO CHAR(6);
        DECLARE N_BONUS INT;
        DECLARE FOUND BOOLEAN DEFAULT TRUE;
        
        DECLARE C_EmpBonus CURSOR FOR
			SELECT EMPNO, BONUS
            FROM employee
            WHERE WORKDEPT = DEPARTMENT_NUMBER;
            
		DECLARE CONTINUE HANDLER FOR NOT FOUND
			SET FOUND = FALSE;
            
		SET empno_bonus = "";
        OPEN C_EmpBonus;
        
        WHILE FOUND DO 
			FETCH C_EmpBonus INTO N_EMPNO, N_BONUS;
				IF FOUND THEN
					SET empno_bonus = CONCAT(empno_bonus, CONCAT(N_EMPNO, N_BONUS), ", ");
				END IF;
		END WHILE;
        
        CLOSE C_EmpBonus;
	END;
