/*Lab Assignment 5
   Worth 2%
   
   Complete all of the questions in this SQL file and submit the file for grading
                
                Open this file in SQL Workbench to complete all of the statements
                
                Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
                You will need it to create the queries based on these tables
                
                There is a .jpg file which shows the tables in the database
                CREATE TRIGGER DELETE_PLAYER
   AFTER DELETE ON PLAYERS FOR EACH ROW
   BEGIN
      CALL INSERT_CHANGE (OLD.PLAYERNO, 'D', NULL);
   END
*/
USE sample;
/*
Trigger Questions

Question 1
Create a Before Insert trigger that will fire on INSERT of the STAFF table.  Have the trigger set the SALARY as follows using a CASE statement :
Ie  SET NEW.SALARY = 
JOB = CEO AND  SALARY > 95000   THEN 95000
JOB = CEO AND  SALARY > 84000   THEN 84000
JOB = CEO AND  SALARY > 70000   THEN 70000
ELSE NEW.SALARY
*/
DELIMITER //
CREATE TRIGGER INSERT_STAFF
	BEFORE INSERT ON STAFF FOR EACH ROW
		BEGIN
			UPDATE STAFF 
			SET SALARY = NEW.SALARY = 
				CASE
					WHEN JOB = "CEO" AND SALARY > 95000 THEN 95000
					WHEN JOB = "CEO" AND SALARY > 84000 THEN 84000
					WHEN JOB = "CEO" AND SALARY > 70000 THEN 70000
					ELSE NEW.SALARY
				END;
		END 
//    
/*
Question 2 
Create a table called PRODUCT_HST .   It needs to have the PID column from the PRODUCT table and two new columns PRICE_HST and PROMO_PRICE_HST

Create two triggers:

AFTER  INSERT into the PRODUCT TABLE
Insert a record into the PRODUCT_HST table with the PRICE_HST and PROMOPRICE_HST populated with
the NEW Price and Promo_price multiplied by HST.
*/
-- CREATE TABLE PRODUCT_HST (
-- 	PID VARCHAR(10),
--     PRICE_HST DECIMAL (3,2),
--     PROMO_PRICE_HST DECIMAL (3,2)
-- );
CREATE TABLE PRODUCT_HST
AS (SELECT PID FROM PRODUCT);

ALTER TABLE PRODUCT_HST
ADD COLUMN PRICE_HST DECIMAL(25,2),
ADD COLUMN PROMOPRICE_HST DECIMAL(25,5);

DELIMITER //

CREATE TRIGGER T_PRODUCT_ADD_HST
AFTER INSERT ON PRODUCT
FOR EACH ROW
BEGIN
	INSERT INTO PRODUCT_HST (PID, PRICE_HST, PROMOPRICE_HST)
	VALUES (NEW.PID, NEW.PRICE * 1.13, NEW.PROMOPRICE * 1.13);
END
//

DELIMITER //

CREATE TRIGGER T_PRODUCT_UPDATE_HST
AFTER UPDATE ON PRODUCT
FOR EACH ROW
BEGIN
	UPDATE PRODUCT_HST
	SET PRICE_HST = NEW.PRICE * 1.13, PROMOPRICE_HST = NEW.PROMOPRICE * 1.13
    WHERE PID = NEW.PID;
END 
//
DROP TRIGGER INSERT_PRODUCT;
/*
AFTER  UPDATE on PRICE or PROMO_PRICE on the PRODUCT TABLE
Update the PRODUCT_HST table with the PRICE, PROMO_PRICE, PRICE_HST and PROMOPRICE_HST populated with the UPDATED Price and Promo_price multiplied by HST.
*/
DELIMITER //
CREATE TRIGGER UPDATE_PRODUCT_HST 
	AFTER UPDATE ON PRODUCT FOR EACH ROW 
		BEGIN
			SET HST = 1.13;
			UPDATE PRODUCT_HST 
            SET	OLD.PRICE = NEW.PRICE,
            OLD.PROMO_PRICE = NEW.PROMO_PRICE * NEW.PRICE_HST,
            OLD.PROMOPRICE_HST = NEW.PRICE_HST * NEW_PROMOPRICE_HST;
		END
	//
/*
Function Question

Question 3 
Create a user-defined function (F_CONVERT_DATE)  to do the following:
	It will accept 1 input  DTE_INPUT.     This function will take in a Date in String format YYYYMMDD and output the date as  MMYYDD.
*/
CREATE FUNCTION F_CONVERT_DATE(DTE_INPUT VARCHAR(8))
	RETURNS VARCHAR(6) DETERMINISTIC
BEGIN
	RETURN DATE_FORMAT(STR_TO_DATE(DTE_INPUT, '%Y%m%d'), '%m%y%d');
END;
SELECT F_CONVERT_DATE("20170615");

-- CREATE FUNCTION TW(DTE_INPUT VARCHAR(8)) 
-- 	RETURN VARCHAR(6) DETERMINISTIC
-- BEGIN
-- 	RETURN CONCAT(SUBSTRING(DTE_INPUT, 5, 2), SUBSTRING(DTE_INPUT, 7, 2), SUBSTRING(DTE_INPUT, 3, 2));
-- END
-- //
