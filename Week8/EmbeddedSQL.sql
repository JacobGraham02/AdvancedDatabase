/*
Cursor - pointer to context area. 
	A context area is the number of rows processed by an SQL statement, and is a pointer to the parsed representation of the statement. 
    Naming convention: c_CursorName, follows standard declaration and scoping
	Types:
		Explicit: user-defined
        Implicit: system-defined
        
Explicit:
	Declare the cursoor
    Open the cursor
    Fetch the results itno PL/SQL variables
    Close the cursor

Defining a cursor:
// 
	DECLARE
		v_StudentID students.id%TYPE; // Declaration of variables where their type is decided by the types of the variables they hold
        v_FirstName students.first_name%TYPE;
        v_LastName students.last_name%TYPE;
        
        CURSOR c_HistoryStudents IS // A context area where a number of rows are processed by an SQL statement
			SELECT id, first_name, last_name
            FROM students
            WHERE major = 'History';
		BEGIN 
			OPEN c_HistoryStudents; // Open the pointer to the cursor and select the data
            LOOP
				FETCH c_HistoryStudents INTO v_StudentID, v_FirstName, v_LastName; 
					DBMS_OUTPUT.PUT_LINE(v_StudentID, v_FirstName, v_LastName); // Output the variables onto 1 line using the Database Management System internal stuff
                EXIT WHEN c_HistoryStudents%NOTFOUND; 	// Exit when no data (rows) to be found in cursor. When entire cursor has been moved over.
					-- Do something with the values in the variables
                END LOOP
						
				CLOSE c_HistoryStudents; -- Close the cursor
		END;
        /
    
    CURSORS have 4 attributes
    Attributes about varaiables, attributes, etc. begin with %
		&FOUND
			True if the previous fetcch returned a row; otherwise, false
		%NOTFOUND
			True if previous fetch did not return a row; otherwise, false
		%ISOPEN
			True if cursor is open or still processing; otherwise, false
		%ROWCOUNT
			Returns number of rows that have been fetched by cursor so far
            
DECLARE
	CURSOR c_HistoryStudents IS
		SELECT id, first_name, last_name
        FROM students
        WHERE major = 'History';
	v_StudentData = c_HistoryStudents%ROWTYPE;
    
BEGIN
	OPEN c_HistoryStudents
    FETCH c_HistoryStudents INTO v_StudentData;
    
    WHILE c_HistoryStudents%FOUND LOOP - The middle term is the condition 
		INSERT INTO registered_students (student_id, department, course)
			VALUES (v_StudentData.ID, 'HIS', 301);
		INSERT INTO temp_Table (num_col, char_col)
			VALUES (v_StudentData.ID, v_StudentData.first_name || '' || v_StudentData.last_name);
		FETCH c_HistoryStudentss INTO v_StudentData;
        
	END LOOP;
    CLOSE c_HistoryStudents;
END;
/

CURSOR with bind variables - Assign a value passed in through a procedure

DECLARE
	v_StudentID students.id%TYPE;
    v_FirstName students.first_name%TYPE;
    v_LastName students.last_name%TYPE;
    v_Major students.major%TYPE;
    
    CURSOR c_HistoryStudents IS
		SELECT id, first_name, last_name
        FROM students
        WHERE major = v_Major;
BEGIN
	v_Major := 'History';
    OPEN c_HistoryStudents;
    
    LOOP
		FETCH c_HistoryStudents INTO v_StudentID, v_FirstName, v_LastName;
        EXIT WHEN c_HistoryStudents%NOTFOUND;
        
	END LOOP
    
    CLOSE c_HistoryStudents;
END;
/
What are bind variables?
	Referenced in the cursor declaration
	Must be declared before
	Values of them are examined only when the cursor is opened at run time
    
Explicit cursors with bind variables
	1. Declare bind variables
    2. Declare cusor
    3. Assign values to bind variables
    4. Open the cursor
    5. Fetch the results into PL/SQL variables
    6. Close the cursor
    
Implicit cursors
	Used for insert, update, delete, select...intro queries
    
    SQL%NOTFOUND, SQL is called implicit cursor
    PL/SQL opens and closes implicit cursors, which is also called SQL cursor
    You do not declare any implicit cursors
    
    If the cursor WHERE clause fails
		for SELECT...INTO, NO_DATA_FOUND error is raised instead of SQL%NOTFOUND
        for UPDATE and DELETE, SQL%NOTFOUND is set to TRUE
        
	Example(s): 
		BEGIN
			UPDATE rooms
            SET number_seats = 100
            WHERE room_id = 99980;
            -- If the previous UPDATE did not match any rows, insert a new row into the 'rooms' table.
		IF SQL%NOTFOUND THEN
			INSERT INTO rooms (room_id, number_seats)
            VALUES (99980, 100);
		END IF;
	END;
    
		BEGIN
			UPDATE rooms
            SET number_seats = 100
            WHERE room_id = 99980;
            -- If the previous UPDATE did not match any rows, insert a new row into the 'rooms' table.
		IF SQL%ROWCOUNT = 0 THEN
			INSERT INTO rooms (room_id, number_seats)
            VALUES (99980, 100);
		END IF;
	END;
    
Example of SELECT...INTO - Allows loading of data from DMBS, then put directly into variables
	DECLARE
		v_RoomData rooms%ROWTYPE;
	BEGIN
		SELECT * 
			INTO v_RoomData
            FROM rooms
            WHERE room_id = -1;
            
		// The following will never be executed, since control passes immeditaley to expection handler
        IF SQL%NOTFOUND THEN
			DBMS_OUTPUT.PUT_LINE('SQL%NOTFOUND is true');
		END IF;
        EXCEPTION
			WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND raised');
	END;
	/
    SHOW ERRORS;
    SQL> SHOW ERRORS;
    
    
    SUMMARY:
		Cursors:
			A pointer to the context area (active set)
            Name begins with c_
            Defined within the DECLARE section
            Types: explicit vs implicit
				Explicit: declare, open, fetch, close
			Bind variables
				Referenced in the crusor declaration
                Must be defined BEFORE the crusor
                Value examined at run time
	
    Exceptions & exception handling
		The method by which a program reacts and deals with runtime errors
        
        How do they work?
			When a runtime error occurs, an exception is raised
			Then control is passed to the exception handler (i.e. the exception section)
			Once control is passed to the exception handler, there is no way to return to the executable section
            
	DECLARE
		e_TooManyStudents EXCEPTION;
        v_CurrentStudents NUMBER(3);
        v_MaxStudents NUMBER(3);
	BEGIN
		-- process data here
	EXCEPTION
		-- handle exceptions here
	END; /
    
    
    DECLARE
		e_TooManyStudents EXCEPTION;
        v_CurrentStudents NUMBER(3);
        v_MaxStudents NUMBER(3);
	BEGIN
		SELECT current_students, max_students
        INTO v_CurrentStudents, v_MaxStudents
        FROM classes
        WHERE department = 'HIS' AND course = 101;
        
        IF v_CurrentStudents > v_MaxStudents THEN
			RAISE e_TooManyStudents;
		END IF;
	EXCEPTION
		-- handle exceptions here
	END;/
    
    
    DECLARE 
		e_TooManyStudents EXCEPTION;
	BEGIN
		-- process data here
	EXCEPTION
		WHEN exception_Name1 THEN
			statements;
		WHEN exception_Name2 THEN
			statements;
		WHEN OTHERS THEN
			statements;
	END;/
    
    
    SQLCODE
		returns error code associated with error
        returns a value of 1 for user defined exceptions
        returns a value of 0 if no error with the last executed statement
        
	SQLERRM
		returns text of the error message
        returns "user defined exceptions" for user-defined exceptions
        
	RAISE_APPLICATION_ERROR
		raise_application_error(error#, error_message);
        valid error #: between -20,000 and -20,999
        error_message must be less than 512 characters
        
Embedded SQL:
	Precompiler is provided by MySQL. If you run precompiler on mysql, the code gets put into a bind file, and can be run with a Java, C#, etc. language program at runtime. 
*/