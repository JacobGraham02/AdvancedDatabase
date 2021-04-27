/*
Databases provide a rich and flexible assortment of data types. Examples are Integer, Char, and Date. Also incldues the ability to create user defined datatypes (UDT's) 
so that you can create complex, non-traditional data types appropriate for many situations. 
4 categories of built-in datatypes: 
UDT's are categorized as distinct, structured, or referenced
numeric;
	smallint, integer, bigint - Integer
		Length of each is 2, 4, and 8 bytes, respectively. 1 byte equals 8 bits, and each INTEGER data type goes from (-2^(bits)/2 to (2^(bits)/2)-1 when signed, 
        and 0 to 2^(bits) when unsigned. 
    decimal - Decimal
		Defined as DECIMAL(p,s); scale and precision. P specifies the total number of digits, and s specifies the total number of decimal places
    real, double - Floating point
string;
	character, string
		Single byte
			Char - Stores fixed length characters up to 254 bytes. 
            Varchar - Stores variable number of chars, with a max length of 32,672 bytes
            Long varchar
            Clob - Character large object
		Double byte
			Graphic - Fixed length double-byte char strings. Max length of 127 chars.
            Vargraphic - variable length double bye character strings. Max length of 16,336 chars.
            Long vargraphic
            Dbclob - double-byte clob
	binary string
		Blob - Binary large objects
        
datetime;
	Values are stored in the database in an internal format. Is manipulated as a string by an application, and represented as a character string when retrieved. 
	Date;
		DAYOFWEEK or DAYNAME to get value for day of the week. DAYS to calculate number of days between the 2 dates. CURRENT DATE returns string representing current system date.
    Time;
    Timestamp;
		Only one form: "yyyy-mm-dd-hh.mm.ss"
	xml;
===================================================================================================================================================================================
Tables
	Consist of one or more columns of various data types. All data is stored in rows (records). System catalog tables hold information about all the objects in a database. Cannot be
    manually updated, and is automatically updated by the DBMS when a table is updated. 
    
    You can create a table that is like another table, or view, in the database. The newly created table takes on the table structure of the old table, but does not copy any data. 
		CREATE TABLE tblNew LIKE tblOld
	
	 The IMPORT utility can only handle a small amount of data to insert into DB. The LOAD utility can handle large volumes of data, in addition to being much faster. 
     
     tables are stored in the database in 'tablespaces'; physical space is allocated (storage). Either specify the table to insert into a given tablespace, or let the database 
     insert the table into one. For example, a tablespace is called 'BOOKINFO'. A tablespace has an effect on the performance and maintainability of a database
		CREATE TABLE BOOKS (
			BOOKID INTEGER,
			BOOKNAME VARCHAR(100),
			ISBN CHAR(10)
		) IN BOOKINFO; - Tablespace

ALTERing a table
	used to change characteristics of a table, such as adding or dropping a primary key, column, one or more unique or referential constraints, or one or more check constraints.
    The following adds a column named BOOKTYPE to the BOOKS table with datatype CHAR of length 1
		ALTER TABLE BOOKS ADD BOOKTYPE CHAR(1)
        
	Can also change characteristics of specific columns in a table:
		Identity attribute, 
        Length of a string column,
        Datatype of,
        Nullability of,
        Constraint of
        
	There are restrictions:
		Can only increase length of a string column
        When converting a datatype, the old one must be compatible with the new one, and must have enough storage. 
        
	The following changes the datatype and nullability of a column
		ALTER TABLE BOOKS 
        ALTER BOOKNAME SET DATA TYPE VARCHAR(200) - Changing datatype
        ALTER ISBN SET NOT NULL - Changing nullability
        
	You cannot change a table's tablespace, order of columns, or datatype of some columns, without saving the table data, dropping it, and recreating it.
    (For some reason the review document specifices autoincrement as 'GENERATED ALWAYS AS IDENTITY')
    Example you should know:
		CREATE TABLE BOOKS (
			BOOKID INTEGER NOT NULL AUTOINCREMENT, - Makes the column auto increment numbers
            BOOKNAME VARCHAR(100) WITH DEFAULT 'TBD', - Generates a default value
            ISBN CHAR(10)
            );
	GENERATED ALWAYS AS constraint to have databases calculate the value of a column automatically. The following defines a table AUTHORS, with columns FICTIONBOOKS and NONFICTIONBOOKS that
    hold counts for fiction and nonfiction books, respectively. TOTALBOOKS will always be calculated now by adding the FICTIONBOOKS and NONFICTIONBOOKS columns.
		CREATE TABLE AUTHORS (AUTHORID INTEGER NOT NULL PRIMARY KEY,
								LNAME VARCHAR(100),
                                FNAME VARCHAR(100),
                                FICTIONBOOKS INTEGER,
                                NONFICTIONBOOKS INTEGER,
                                TOTALBOOKS INTEGER GENERATED ALWAYS AS (FICTIONBOOKS + NONFICTIONBOOKS)
								);
    
Constraints
	Controls what data is stored in column. Unique, referential integrity, and table check. 
		Unique constraints:
			Name implies what it is. Defined as PRIMARY KEY or UNIQUE. Defined when table is created, or when used in an ALTER. 
				CREATE TABLE BOOKS (BOOKID INTEGER NOT NULL PRIMARY KEY,
									BOOKNAME VARCHAR(100),
									ISBN CHAR(10) NOT NULL CONSTRAINT BOOKISBN UNIQUE
                                    );
			A special name is assigned to the constraint, in this case BOOKISBN. Can only define 1 primary key, but multiple constraints for unique. You cannot use both
            PRIMARY KEY and UNIQUE on the same column. 
            
		Referential constraints:
			Define relationships between tables and ensure those relationships remain valid. For example, defining 2 primary keys on a common column in both the BOOKS and
            AUTHORS table, and linking them with a foreign key.
            
            CREATE TABLE AUTHORS (AUTHORID INTEGER NOT NULL PRIMARY KEY,
									LNAME VARCHAR(100),
                                    FNAME VARCHAR(100));
			CREATE TABLE BOOKS (BOOKID INTEGER NOT NULL PRIMARY KEY,
								BOOKNAME VARCHAR(100),
                                ISBN CHAR(10),
                                AUTHORID INTEGER REFERENCES AUTHORS);
            
            The primary key table which relates to another table is called the 'parent table'. The table which the parent table relates to is called the 'dependent table'.
            Referential integrity rules are inforced
				Ensures that only valid data is inserted into columns where referential integrity constraints are defined. A row in the parent table with a key value must be equal to 
                a foreign key value in the row that you are inserting into a dependent table. 
                Deleting:
					4 actions - Restrict, no action, cascade, set null
						If either of first 2 are used, database does not allow the parent table row to be deleted before the child table row
                        If cascade is used, a row deleted in the parent table also deletes the corresponding row in the child table 
                        If set null is used, the parent row is deleted from the parent table and the foreign key value in the dependent rows is set to null

	Table check constraints:
		Verify column data does not violate rules defined for the column. For example, for the BOOKS table, you wish to allow F (fiction) and N (non-fiction) only into the column 
        BOOKTYPE with check constraints as following:
			ALTER TABLE BOOKS ADD BOOKTYPE CHAR(1) CHECK (BOOKTYPE IN ('F','N'));
				You can define these when first creating the table, or add them later using the ALTER TABLE statement
                
	Views:
		Allow different users or applications to look at the same data in different ways. The data presented in a view is derived from another table. A view can be created on an
	existing table, on another view, or some combination of both. 
    
		Creating a view:
			A view that shows only the non-fiction books in our BOOKS table
				CREATE VIEW NONFICTIONBOOKS AS SELECT * FROM BOOKS WHERE BOOKTYPE = 'N';
				
                After defining this view, there are entries for it in SYSCAT.VIEWS, SYSCAT.VIEWDEP, and SYSCAT.TABLES
                
                CREATE VIEW statement specifies column names which differ from those in the base table. 
					CREATE VIEW MYBOOKVIEW (TITLE,TYPE) AS SELECT BOOKNAME, BOOKTYPE FROM BOOKS
					The above creates a view which contains 2 columns, TITLE = BOOKNAME, TYPE = BOOKTYPE. 
				DROP VIEW statement is used to drop a view. If you drop a table or another view which a view is based on, it is still defined in the database, but is rendered
				inoperative. You cannot directly modify a view. You must drop and recreate it. Use ALTER VIEW to modify only reference types. 
                
                A view can be defined as a read-only or updateable view. If you do not want a user to insert rows that are outside the scope of the view, you can define the view using
                WITH CHECK OPTION. This tells the DBMS to check that statements using the view satisfy the conditions of the view. 
					The following defines a view using WITH CHECK OPTION
						CREATE VIEW NONFICTIONBOOKS AS
							SELECT * FROM BOOKS WHERE BOOKTYPE = 'N'
                            WITH CHECK OPTION
                            
				This view restricts the user to only see nonfiction books. Also prevents users from inserting rows that do not have a value of N in the BOOKTYPE column, and updating
                the value of the BOOKTYPE column in existing rows to a value other than N. 
					The following is not allowed
						INSERT INTO NONFICTIONBOOKS VALUES (...,'F');
                        UPDATE NONFICTIONBOOKS SET BOOKTYPE = 'F' WHERE BOOKID = 111
                        
				A check option can be defined as either CASCADED or LOCAL. Cascaded is the default. WITH CASCADED CHECK OPTION requires that all statements executed against the view
                must satisfy the conditions of the view and all underlying views, even those not defined with CHECK OPTION. Suppse a view NONFICTIONBOOKS, and NONFIICTIONBOOKS1 based
                on the view NONFICTIONBOOKS using the CASCADED keyword. 
					CREATE VIEW NONFICTIONBOOKS AS
						SELECT * FROM BOOKS WHERE BOOKTYPE = 'N'
					CREATE VIEW NONFICTIONBOOKS1 AS
						SELECT * FROM NONFICTIONBOOKS WHERE BOOKID > 100
                        WITH CASCADED CHECK OPTION
                        
                        The following would not be allowed because they do not satisfy the conditions of both views
							INSERT INTO NONFICTIONBOOKS1 VALUES( 10,..,'N')
							INSERT INTO NONFICTIONBOOKS1 VALUES(120,..,'F')
							INSERT INTO NONFICTIONBOOKS1 VALUES( 10,..,'F')
                            
				Suppose a view using WITH LOCAL CHECK OPTION is created. Now, statements executed against the view need only satisfy the conditions of views that have the check option
                specified. 
					CREATE VIEW NONFICTIONBOOKS AS
						SELECT * FROM BOOKS WHERE BOOKTYPE = 'N'
					CREATE VIEW NONFICTIONBOOKS2 AS 
						SELECT * FROM NONFICTIONBOOKS WHERE BOOKID > 100
						WITH LOCAL CHECK OPTION.
                        
					Insert statements with a bookid > 100, even if the booktype is 'F', would be allowed to insert into view because of the LOCAL CHECK OPTION on the 2nd view.
                    "Nested views".

	Index:
		Ordered list of the key values of a column or columns in a table. Unique indexes only allow unique key values; nonunique indexes allow multiple duplicate key values. 
        Any query which uses indexes is optimized by the DBMS, and runs faster than a query without any indexes. Created implicitly with PRIMARY KEY or UNIQUE constraint. 
        
        Creating Indexes:
			The following creates a nonunique ascending index on BOOKNAME 
				CREATE INDEX IBOOKNAME ON BOOKS (BOOKNAME)
                
			The following creates an index on AUTHORID and BOOKNAME columns. AUTHORID is sorted descendingly, BOOKNAME is sorted in ascending order for each corresponding AUTHORID.
				CREATE INDEX I2BOOKNAME ON BOOKS (AUTHORID DESC, BOOKNAME ASC);
                
			Bidirectional indexes eliminates the need to create an index in the reverse order you want the data to be ordered in. To create this, add the ALLOW REVERSE SCANS option on
            the CREATE INDEX statement.
				CREATE INDEX BIBOOKNAME ON BOOKS (BOOKNAME) ALLOW REVERSE SCANS
			To modify an existing index on a table, you must drop and re-create the table. There is no way to modify one after creation. 
			Process of creating an index:
				Each row is read to extract data keys
                Each key is sorted
                Sorted key list is written to database
				- If the table is large, than a temporary tablespace is used to sort the keys
                
		Clustering indexes:
			Defines the order in which data is stored in the database. During inserts, the DBMS attemps to place new rows close to rows with similar keys. The data can then be retrieved
            faster. Useful when the table data is referenced in a particular order. 
				Creating a clustering index with the create index statement:
					CREATE INDEX IAUTHBKNAME ON BOOKS (AUTHORID, BOOKNAME) CLUSTER
				This index would improve the performance of queries written to list authors and all the books that they have written
                
		Using included columns in indexes:
			You have the option to include extra column data that is stored with the key upon creation of an index, but is not part of the key itself and is not stored. The main reason
		for this in an index is to improve the performance of certain queries. The DMBS does not need to access the data page to fetch the data, instead looking at the extra column
        data. Includes columns can only be defined for unique indexes. 
			Selecting a list of booknames ordered by bookid
				SELECT BOOKID, BOOKNAME FROM BOOK ORDER BY BOOKID
			Create an index that might improve performance
				CREATE UNIQUE INDEX IBOOKID ON BOOKS (BOOKID) INCLUDE(BOOKNAME);
                
		What indexes should I create?
			Because they are a permanant list of key values, they require space in the database. Creating many of them requires additional space in your db. Determined by the length
            of the key columns. 
            They are copies of values, so they must be updated if the data in the table is updated.
			significantly improve performance of queries when defined on the appropriate columns
            
		Joins
				Used to query data from multiple tables. Adds a number of columns to result set. Usually, it is the number of columns multiplied by the number of tables.
				Inner joins return only rows from the cross join product that meet the join condition. 
                To specify an INNER JOIN, replace the following code,
					SELECT deptnumb, deptname, id AS manager_id, name AS manager
						FROM org, staff
						WHERE manager = id
                        ORDER BY deptnum
                        
				With this:
					.	.	.
					FROM org INNER JOIN staff
                    ON manager = id
					.	.	.
                    
				The result set consists of rows that have matching values for the Manager and ID columns in the left table (org) and the right table (staff). You arbitrarily
                designate one table to both left and right. 
                
                Outer joins return rows generated by an inner join, plus rows not returned by an inner join. 
                3 types of joins:
					A left outer join includes the inner join plus the rows from the left table that are not returned by the inner join. 
                    A right outer join includes the inner join plus the rows from the right table that are not returned by the inner join. 
                    A full outer join includes the inner join plus the rows from both the left table and the right table that are not returned by the inner join. 
                    
				The following generates a list of employees who are responsible for projects, identifying those employees who are also managers by listing the departments they manage
					SELECT empno, deptname, projname
						FROM (employee LEFT OUTER JOIN project ON respemp = empno)
					LEFT OUTER JOIN department
                    ON mgrno = empno
                    
				Using set operators to combine two or more queries into a single query
					Combine 2 or more queries into a single one by using the UNION, EXCEPT or INTERSECT set operators. Set operators process the results of the queries, eliminate duplicates,
                    and return the final result set
						Union set operator generates a result table by combining two oro more other result tables
								SELECT sales_person FROM sales
								WHERE region = 'Ontario-South'
							UNION
								SELECT sales_person FROM sales
								WHERE sales > 3
                        Except set operator generates a result table by including all rows that are returned by the first query, but not by the second or any subsequent queries.
                        Intersect set operator generates a result table by including only rows that are returned by all the queries. 
                        
			Using group by clause to summarize results
				Use the GROUP BY clause to organize rows in a result set. 
					SELECT sales_date, MAX(sales) AS max_sales FROM sales
						GROUP BY sales_date
                        
				A different flavour of 'group by' includes the specification of the grouping sets clause. Grouping sets can be used to analyze data at different levels of aggregation 
                in a single pass. This specifies how the returned data is to be grouped. 
					SELECT YEAR(sales_date) AS year, region, SUM(sales) AS tot_sales
						FROM sales
                        GROUP BY GROUPING SETS (YEAR(sales_date), region, () )
					The pair of empty parenthesis is added to the GROUPING SETS list to get a grand total in the result set. This statement returns the following. 
                    
			The HAVING clause is used with a GROUP BY clause to retrieve results for groups that satisfy only a specific condition. 
				SELECT sales_person, SUM(sales), AS total_sales FROM sales
					GROUP BY sales_person
                    HAVING SUM(sales) > 25
                    
		Commit and Rollback statements and transaction boundaries
			Units of work and savepoints
            
			A unit of work, also known as a transaction, is a recoverable sequence of operations within an application process. A UOW implicity starts when an SQL statement is first 
            issued against a database. All subsequent reads and writes by the same application process are considered part of the same UOW. The application ends the UOW by 
            issuing either a COMMIT or ROLLBACK statement. The commit makes all permanent changes, while the ROLLBACK reverses those changes. If ended explicity without a COMMIT or
            ROLLBACK, the UOW is automatically committed. If abnormally exited before the end of the UOW, that unit of work is rolled back. 
            
		Creating and calling an SQL procedure
			An SQL procedure is a stored procedure whose body is written in SQL. The body contains logic to execute, and can include variable declarations, condition handling, flow 
            control statements, and DML (Data Modelling Language). Multiple SQL statements can be specified within a compound statement, which groups several statements together
            into an executable block. 
            
            A procedure is created with the CREATE PROCEDURE statement, which defines the procedure with an application server. Procedures are a handy way to define more complex
            queries or tasks that can be called whenever they are needed. 
            
				CREATE PROCEDURE sales_status(IN quota INTEGER, OUT sql_state CHAR(5))
                BEGIN
				DECLARE SQLSTATE CHAR(5);
                DECLARE rs CURSOR WITH RETURN FOR
                SELECT sales_person, SUM(sales) AS total_sales
					FROM salesGROUP BY sales_person 
                    HAVING SUM(sales) > quota;
				OPEN rs;
                SET sql_state = SQLSTATE;
                END @
                
            Most SQL procedures accept at least one input parameter. In our example, the input parameter contains a value (quota) that is used in the select statement contained in
            the procedure body.
				Also return at least one output parameter. Our example includes an output parameter (sql_state) that is used to report the success or failure of the SQL procedure. 
                The parameter list for an SQL procedure can specify zero or more parameters, each of which can be one of three possible types:
					IN parameters pass an input value to an SQL procedure; this value cannot be modified within the body of the procedure
                    OUT parameters return an output value from an SQL procedure
                    INOUT parameters pass an input value to an SQL procedure and return an output value from the procedure
                    
				Variables must be declared at the beginning of the SQL procedure body. To declare, assign a unique identifier to and specify a data type for an SQL variable. 
                
                The following flow-of-control statements, structures, and clauses can be used for conditional processing within an SQL procedure body:
					CASE selects an execution path based on the evaluation of one or more conditions
                    FOR executes a block of code for each row of a table
                    GER DIAGNOSTICS returns information about previous SQL statement into an SQL variable
                    GOTO transfers control to a section of one or more statements identified by a unique SQL name followed by a colon
                    IF selects an execution path based on the evaluation of conditions
                    ELSEIF and ELSE enable you to branch or to specify a default action if the other conditions are false
                    ITERATE passes the flow of control to beginning of a labeled loop
                    LEAVE transfers program control out of a loop or block of code
                    LOOP executes a block of code multiple times until a LEAVE, ITERATE, or GOTO statement transfers control outside of the loop
                    REPEAT executes a block of code until a specified serach condition returns true
                    RETURN returns control from the SQL procedure to the caller
                    SET assigns a value to an output parameter or SQL variable
                    WHILE repeatedly executes a block of code while a specified condition is true
                    
			
            
            Practical code examples:
				Create table
                
                CREATE TABLE EMPLOYEE_SALARY
					(DEPTNO CHAR(3) NOT NULL,
                    DEPTNAME VARCHAR(36) NOT NULL,
                    EMPNO CHAR(6) NOT NULL,
                    SALARY DECIMAL(9,2) NOT NULL WITH DEFAULT)
                    
				CREATE TABLE EMPLOYEE
					(ID SMALLINT NOT NULL,
                    NAME VARCHAR(9),
                    DEPT SMALLINT CHECK (DEPT BETWEEN 10 AND 100),
                    JOB CHAR(5) CHECK (JOB IN('Sales','Mgr','Clerk')),
                    HIREDATE DATE,
                    SALARY DECIMAL(7,2),
                    COMM DECIMAL(7,2),
                    PRIMARY KEY (ID),
                    CONSTRAINT YEARSAL CHECK (YEAR(HIREDATE) > 1986 OR SALARY > 40500)
                    
				
                Create view
					CREATE VIEW V1 AS SELECT * FROM T1 UNION ALL SELECT * FROM T2;
                    
                    CREATE VIEW MA_PROJ
						AS SELECT PROJNO, PROJNAME, RESPEMP
						FROM PROJECT
                        WHERE SUBSTR(PROJNO, 1, 2) = 'MA'
					
                    CREATE VIEW PRJ_LEADER
						AS SELECT PROJNO, PROJNAME, DEPTNO, RESPEMP, LASTNAME
                        FROM PROJECT, EMPLOYEE
                        WHERE RESPEMP = EMPNO
                        
					CREATE VIEW PRJ_LEADER
						AS SELECT PROJNO, PROJNAME, DEPTNO, RESPEMP,
							LASTNAME, SALARY+BONUS+COMM AS TOTAL_PAY
						FROM PROJECT, EMPLOYEE
                        WHERE RESMPEMP = EMPNO AND PRSTAFF > 1
                        
					
				Create index
					CREATE INDEX CORPDATA.INX1 
                    ON CORPDATA.EMPLOYEE (LASTNAME)
                    
                    CREATE INDEX UNIQUE_NAM 
                    ON PROJECT (PROJNAME)
                    
                    CREATE UNIQUE INDEX JOB_BY_DEPT
                    ON EMPLOYEE (WORKDEPT, JOB)
                    
                    CREATE INDEX IDX1 ON TAB1 (col1) COLLECT STAISTICS
                    
                    
				Stored Procedures:
					
				Sends out the procedure language defined in the sysprocedures table
					DELIMITER /
					CREATE PROCEDURE OUT_LANGUAGE(OUT procedureLanguage CHAR(8))
                    DYNAMIC RESULT SETS 0
                    LANGUAGE SQL
                    READS SQL DATA
						BEGIN
							SELECT language INTO procedureLanguage
								FROM sysibm.sysprocedures
                                WHERE procname='OUT_LANGUAGE';
						END
					/
                    
				Updates salary for employee number and rate sent in
                    DELIMITER /
                    CREATE OR REPLACE PROCEDURE UPDATE_SALARY
					(IN EMPLOYEE_NUMBER CHAR(10),
                    IN RATE DECIMAL(6,2))
						LANGUAGE SQL
							IF RATE <= 0.50
								THEN UPDATE EMP
								SET SALARY = SALARY * RATE
								WHERE EMPNO = EMPLOYEE_NUMBER
							ELSE UPDATE EMP
								SET SALARY = SALARY * 0.5
								WHERE EMPNO = EMPLOYEE_NUMBER
						END IF
                    /
*/