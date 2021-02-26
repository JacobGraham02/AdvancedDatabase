/*
Similar to a method or function in Java. Must specify parameters for the procedure
datatype
3 different ways to pass things into procedure - IN, OUT, INOUT
Pass parameter by value - Passes value to procedure for utilization; do not update original value
Pass parameter by reference - Passes value to procedure by pointer; does update original value

IN - Pass by value.
OUT - 
INOUT - 
*/
CREATE PROCEDURE P_LESSON_5 (in PARAM1 int, out PARAM2 varchar(10), inout PARAM3 date)

SET @DATE_IN = '2021-02-09';
-- Pass in values to use procedure
-- @variable - Passed variable into procedure  
CALL P_LESSON_5 (22, @Saying, @DATE_IN);
SELECT @SAYING, @DATE_IN;

/*
How to contain the procedure
CREATE PROCEDURE P_LESSON_5 (in PARAM1 int, out PARAM2 varchar(10), inout PARAM3 date)
SQL runs procedure up to semicolon by default. Tell compiler to use different delimeter for ending block of code
*/
DELIMITER // 
CREATE PROCEDURE P_LESSON_5 (in PARAM1 int, out PARAM2 varchar(10), inout PARAM3 date)
BEGIN
	BEGIN
		BEGIN
			SET PARAM3 = '2021-09-04';
        END
    END
END
//

SET @INPUTVAL = 'Hello';
SET @DATE_IN = '2021-02-09';

DELIMITER //
CREATE PROCEDURE TEST (OUT NUMBER1 INTEGER)
BEGIN
	DECLARE NUMBER2 INTEGER DEFAULT 100;
	SET NUMBER1 = NUMBER2;
END
//

CALL TEST(@NUMBER);
SELECT @NUMBER;

DELIMETER //
CREATE PROCEDURE DIFFERENCE
	(IN P1 INTEGER,
    IN P2 INTEGER,
    OUT P3 INTEGER)
BEGIN
	IF P1 > P2 THEN
		SET P3 = 1;
	ELSEIF P1 = P2 THEN
		SET P3 = 2;
	ELSE
		SET P3 = 3;
	END IF;
END
// 
/*
Steps:
1. Define stored procedure and any variables, delimeters, etc. 
2. Put code inside of the procedure
3. Compile the code procedure 
4. Call the code procedure and supply it with any created variables
*/
DELIMITER //
CREATE PROCEDURE FIBONNACI
	(INOUT NUMBER1 INTEGER,
    INOUT NUMBER2 INTEGER,
    INOUT NUMBER3 INTEGER)
BEGIN
	SET NUMBER3 = NUMBER1 + NUMBER2;
    IF NUMBER3 > 10000 THEN
		SET NUMBER3 = NUMBER3 - 10000;
	END IF;
    SET NUMBER1 = NUMBER2;
	SET NUMBER2 = NUMBER3;
END
//

SET @A=16, @B=27;

CALL FIBONNACI(@A, @B, @C);

SELECT @C;

DELIMITER //
CREATE PROCEDURE LARGEST
	(OUT T CHAR(10))
BEGIN
	IF (SELECT COUNT(*) FROM PLAYERS) >
		(SELECT COUNT(*) FROM PENALTIES) THEN
        SET T = 'PLAYERS';
	ELSEIF (SELECT COUNT(*) FROM PLAYERS) = 
			(SELECT COUNT(*) FROM PENALTIES) THEN
		SET T = 'EQUAL';
	ELSE
		SET T = 'PENALTIES';
	END IF;
END
//


