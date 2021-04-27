/* Assignment 2 
   Worth 7.5%
   
   Assignment is out of 100
   
   Complete all of the questions in this SQL file and submit the file for grading
                
                Open this file in SQL Workbench to complete all of the statements
                
                Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
                You will need it to create the queries based on these tables
                
                There is a .jpg file which shows the tables in the database

*/
USE sample;

/*Create Table, Index and View Questions:

Question 1 (15 marks)

Create a View (V_EMP_DEPT_PROJ) statement that joins the EMPLOYEE and EMPPROJACT (join on EMPNO)  and PROJECT table (join on PROJNO).  Limit the view to contain :
o	Empno - employee, empprojact
o	Name (FirstName and Lastname) - employee
o	WorkDept - employee
o	Salary - employee
o	ACTNO - empprojact
o	PROJNO - empprojact, project
o	PROJNAME - project
o	Where Salary < 100000
*/
CREATE VIEW V_EMP_DEPT_PROJ AS SELECT employee.empno, employee.firstnme, employee.lastname, 
employee.workdept, employee.salary, empprojact.actno, empprojact.projno, project.projname
FROM employee
INNER JOIN empprojact
ON employee.empno = empprojact.empno
INNER JOIN project
ON empprojact.projno = project.projno
WHERE employee.salary < 100000;

/*
Question 2 (10 marks)
Create an INDEX statement that would speed up the following query on the EMPLOYEE table.
    select * from employee where hiredate > '2001-01-01';
*/
CREATE INDEX optimized_hiredate ON employee(hiredate);
select * from employee where hiredate > '2001-01-01';
/*
Create an INDEX statement that would speed up the following query on the STAFF table.
    select * from staff where YEARS > 3 AND SALARY BETWEEN 45000 AND 100000 ;
*/
CREATE INDEX indexName ON staff(years, salary);
select * from staff where YEARS > 3 AND SALARY BETWEEN 45000 AND 100000 ;

/*Question 3 (25 marks )
	Write the 3 CREATE TABLE statements for the tables in the Question3.jpg file with Primary Keys  and Foreign Keys 
	( Make sure columns are defined with appropriate data types  (Dt column would be a Date), and configure the PK to 
	create an ID number automatically on insert) (auto-increment).  Create 5 INSERT statements for each of the tables and  
	Create a SELECT statement that gets the following columns  CaseManagerID, SupervisorID, AuditedDt, UpdatedBy, FName, LName.
*/
CREATE TABLE CaseManagers (
	CaseManagerID MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
    FName VARCHAR(50),
    LName VARCHAR(50),
    PRIMARY KEY(CaseManagerID)
);

CREATE TABLE CMSupervisors (
	SupervisorID MEDIUMINT UNSIGNED NOT NULL,
    CaseManagerID MEDIUMINT UNSIGNED NOT NULL,
    PRIMARY KEY (SupervisorID, CaseManagerID),
    FOREIGN KEY (CaseManagerID)
		REFERENCES CaseManagers(CaseManagerID)
);

CREATE TABLE CaseAudits (
	CaseAuditID MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
	AuditedCaseManagerID MEDIUMINT UNSIGNED NOT NULL,
    AuditingSupervisorID MEDIUMINT UNSIGNED,
    AuditedOffenderCd SMALLINT UNSIGNED,
    AuditedDt DATE,
    LastUpdated DATE,
    UpdatedBy VARCHAR(50),
    PRIMARY KEY (CaseAuditID)
);

ALTER TABLE CaseAudits 
ADD FOREIGN KEY (AuditedCaseManagerID) REFERENCES CaseManagers(CaseManagerID);

/*Question 4 (25 marks)
Create a stored procedure (P_SYS_TABLE) that lists TABLE_NAME, TABLE_ROWS, COLUMN_NAME and DATA_TYPE for the TABLES in the SAMPLE database 
that have VARCHAR columns with a CHARACTER_MAXIMUM_LENGTH > 5.  You will find this information by using a SELECT on the INFORMATION_SCHEMA.  
*/
DELIMITER //
CREATE PROCEDURE P_SYS_TABLE (IN CHAR_MAX_LENGTH INT)
BEGIN
	SELECT c.table_name,  c.column_name, c.data_type, t.table_rows, c.CHARACTER_MAXIMUM_LENGTH
   FROM information_schema.columns c
   JOIN information_schema.tables t ON c.table_name = t.table_name
   WHERE t.table_schema = 'SAMPLE' 
   AND CHARACTER_MAXIMUM_LENGTH > 5
   AND c.data_type = 'varchar';
END
//
/*
Question 5 (25 marks)
Create a stored procedure (P_FACT_RESULT)  that accepts one IN parameter (n_factor), and has one OUT parameter (n_result).  Use a CASE structure to control the output:

o	Input is >=  3 , Output is n_factor *1.1
o	Input is >=6 , Output is n_factor*1.3
o	Input is >=12 , Output is n_factor*1.5
o	Input is >=17 , Output is n_factor*1.7
o	Input is >=24 , Output is n_factor*1.9
o	Else Ouput n_factor * 0.5
*/
DELIMITER //
CREATE PROCEDURE P_FACT_RESULT (IN n_factor INTEGER, OUT n_result DECIMAL) 
BEGIN
	CASE n_factor
		WHEN n_factor >= 3 THEN SET n_factor = n_factor * 1.1;
        WHEN n_factor >= 6 THEN SET n_factor = n_factor * 1.3;
        WHEN n_factor >= 12 THEN SET n_factor = n_factor * 1.5;
        WHEN n_factor >= 17 THEN SET n_factor = n_factor * 1.7;
        WHEN n_factor >= 24 THEN SET n_factor = n_factor * 1.9;
        ELSE SET n_factor = n_factor * 0.5;
	END CASE;
END
//
			