/*
Stored procedures:
	Provide a standard way to call an external program from within an application by using an SQL statement
    
    Types:
		SQL stored procedures
        External stored procedures
			The source code for the host language must be compiled so that a program object is created. The CREATE STATEMENT statement is used to tell the system where to
		find the program object that implements this stored procedure. 
        
	CREATE PROCEDURE can be issued interactively, or embedded in an application program. After it is registered, it can be called from any interface supporting the 
    SQL CALL statement. 
    
    CONTAINS SQL, READS SQL DATA, MODIFIES SQL DATA, or NO SQL
		Set limits in regard to what stored procedures can have inside them
        
	CONTAINS SQL - Contains any SQL statement that is valid when inside a stored procedure
    NO SQL - Does not contain any SQL statements
    READS SQL DATA - Reads data using SQL. Can not do any modifications to the data other than reading
    MODIFIES SQLDATA - Possibly modifies data using SQL. 
    
    
    A stored procedure nameed GET_FREE_EMPLOYEES returns a result set that contains those employees who are currently free from any project engagements. 
    The procedure header includes the count of result sets returned by the procedure. Result sets are returned by including the WITH RETURN clause on the cursor
    definition and then leaving that cursor open before exiting the procedure.  
    
    CREATE PROCEDURE GET_FREE_EMPLOYEES (IN dept CHAR(3))
		BEGIN
			IF dept NOT IN ('D11','D21','ALL') THEN 
				SIGNAL SQLSTATE VALUE '75001' SET MESSAGE_TEXT  = 'Invalid department input';
			END IF;
		SELECT DISTINCT FIRSTNAME AS FNAME, LASTNAME AS LNAME, WORKDEPT AS DEPTNUM
		FROM EMPLOYEE e
        WHERE workdept = dept AND
        ((CURRENT_DATE > ALL (SELECT EMP_ENDDATE FROM EMP_ACTIVEPROJECTS P WHERE e.empno = p.empno AND emp_enddate IS NOT NULL) AND empno NOT IN 
		(SELECT empno FROM emp_activeprojects WHERE emp_enddate IS NULL));
        
		END;
        
	TRIGGER CONCEPTS
		Application independent. 
        Activated by the database manager when a data change is performed in the database
        Mainly intendeed for monitoring database changes and taking appropriate actions as a result of these changes. 
        The advantage of triggers is that they are activated automatically, regardless of the interface that generated the data change
        
        Types of triggers:
			Up to 300 triggers can be defined for a database; they are SQL trigger and external trigger
            
            SQL trigger - Program performing the tests and actions is written using SQL statements. CREATE TRIGGER statement provides a way for the 
            database management system to actively control, monitor, and amange a group of tables whenever an insert, update, or delete operation is performed. An SQL
            trigger may call stored procedures or user-defined functions to perform additional processing when the trigger is executed
            
            An SQL trigger is invoked by the database management system upon the execution of a triggering insert, update, or delete. The trigger definition is stored in the DBMS 
            and invoked by DMS when the table trigger is defined on is modified
            
		Structure of an SQL trigger:
			SQL routine body is the executable part of the trigger that is transformed by the database manager into a program. When a trigger is created, SQL creates
            a temporary source file that will contain C source code with embedded SQL statements. 
            
            CREATE TRIGGER name-of-trigger
			ON table-name
				FOR EACH ROW / FOR EACH STATEMENT
					BEGIN
					IF (condition)
						routine body of the trigger
					END
                    
		Components of the sql trigger definition:
			Subject table: Defines the table on which the trigger is defined
            Trigger event: Defines specific SQL operation that modifies the subject table. Operations can be to DELETE, INSERT, or UPDATE a row.
            
		Activation time: Defines whether the trigger should be activated before or after the trigger event is performed on the subject table
        
        A table can be associated with six types of SQL triggers:
			Before delete trigger
            Before insert trigger
            Before update trigger
            After delete trigger
            After insert trigger
            After update trigger
            
		Trigger granularity: Defines whether the actions of trigger will be performed once FOR EACH STATEMENT or once FOR EACH ROW in the set of affected rows.
        Correlation variables: May refer to the values in the set of affected rows. 
                    
                    
			
	
    
Defining a cursor:
	CREATE TRIGGER trigger_name
	BEFORE | AFTER	  INSERT|UPDATE|DELETE
	ON table_name FOR EACH ROW
	{ trigger_body }            
	
    To distinguish between the value of the columns BEFORE and AFTER the DML has fired (the trigger), you use the NEW and OLD modifiers before variable names
		If you update the column 'description', in the trigger body, you can access the value of it BEFORE the update OLD.description and the new value AFTER the update
        as NEW.description
			INSERT has no OLD modifier, and DELETE has no NEW modifier
            
		CREATE TRIGGER before_workcenters_insert
        BEFORE INSERT
        ON WorkCenters FOR EACH ROW
        BEGIN 
			DECLARE rowcount INT;
			
            SELECT COUNT(*)
            INTO rowcount
            FROM WorkCenterStats;
            
            IF rowcount > 0 THEN
				UPDATE WorkCenterStats 
                SET totalCapacity = totalCapacity + NEW.capacity;
			ELSE
				INSERT INTO WorkCenterStats(totalCapacity)
				VALUES (NEW.capacity);
			END IF;
            
		END
        
        
        CREATE TRIGGER after_members_insert
        AFTER INSERT
        ON members FOR EACH ROW
        BEGIN
			IF NEW.birthDate IS NULL THEN
				INSERT INTO reminders(memberId, message)
                VALUES (NEW.id, CONCAT('Hi ', NEW.name, ', please update your date of birth.'));
			END IF;
		END;
*/ 