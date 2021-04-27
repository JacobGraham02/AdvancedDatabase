/*Lab Assignment 2 
   Worth 2%
   
   Complete all of the questions in this SQL file and submit the file for grading
                
                Open this file in SQL Workbench to complete all of the statements
                
                Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
                You will need it to create the queries based on these tables
                
                There is a .jpg file which shows the tables in the database

*/



-- Create Indexes
USE sample;
/*
1:  Create an index named JOB_BY_DPT on the EMPLOYEE table. Using WORKDEPT and JOB. 
*/
CREATE INDEX JOB_BY_DPT ON EMPLOYEE (WORKDEPT, JOB);



/*
 2:  Create a unique index named PROJ_RESP_PR on the PROJECT table. Using RESPEMP, PRSTAFF and sort the index in decending order by PRSTAFF.
 */
 CREATE UNIQUE INDEX PROJ_RESP_PR
 ON PROJECT (RESPEMP, PRSTAFF DESC);

 

/*
Create Views

1:  Create a view named AD_PROJ upon the PROJECT table that contains only those rows with a project number (PROJNO) starting with the letters 'AD'. 
*/
CREATE VIEW AD_PROJ  AS SELECT *
FROM PROJECT
WHERE SUBSTR(PROJNO, 1, 2) = 'AD';



/*
2:  Create a view starting with the SELECT from question 1 called AD_PROJ2  selecting projno, projname, and respemp but, in the view, call the RESPEMP column IN_CHARGE. 
*/
CREATE VIEW AD_PROJ2 AS SELECT projno, projname, respemp AS "IN_CHARGE"
FROM project 
WHERE SUBSTR(PROJNO, 1, 2) = 'AD';


/*
3:  Create a view starting with the SELECT from question 2 named PROJ_LEADER that has the same columns from question 2 together with the last name (LASTNAME) 
of the person who is responsible for the project (RESPEMP).  
*/
CREATE VIEW PROJ_LEADER AS SELECT projno, projname, respemp AS "IN_CHARGE", LASTNAME
FROM project 
INNER JOIN employee ON employee.empno = project.respemp
WHERE SUBSTR(projno, 1, 2) = 'AD';
        


/*
4:  Create a view starting with the SELECT from question 3 , add to the columns to show the total pay (SALARY and BONUS  and COMM) of the employee who is responsible. 
Select only the projects with (PRSTAFF) greater than one. 
*/
CREATE VIEW q4 AS SELECT projno, projname, respemp AS "IN_CHARGE", LASTNAME, employee.salary, employee.bonus, employee.comm
FROM project
INNER JOIN employee
ON project.deptno = employee.workdept
WHERE project.prstaff > 1;



 

-- User Creation, GRANTS, REVOKES 
	
/*
1.	Create a statement to define a new user called LAB2_U1 with the password LAB1234#
*/
CREATE USER 'LAB2_U1'@'%' IDENTIFIED BY 'LAB1234#';



/*
2.	Create GRANT statements to give LAB2_U1
a.	SELECT access to the EMPLOYEE table 
b.	SELECT AND INSERT to the ACT table
c.	EVERY privilege to the PROJECT table 
*/
GRANT SELECT
ON employee
TO 'LAB2_U1'@'%';

GRANT SELECT, INSERT
ON act
TO 'LAB2_U1'@'%';

GRANT ALL
ON project
TO 'LAB2_U1'@'%';
/*
3.	Create a statement to define another user called LAB2_U2 with the password LAB4567#
*/
CREATE USER 'LAB2_U2' IDENTIFIED BY 'LAB4567#';

/*
4.	Create GRANT statements to give LAB2_U2
a.	EVERY privilege on the DEPARTMENT table including to GRANT
b.	GRANT SELECT for the DEPARTMENT table for LAB2_U1
c.	REVOKE  SELECT for the DEPARTMENT table for LAB2_U1
d.	GRANT SELECT for the DEPARTMENT table for EVERYONE
*/
GRANT ALL PRIVILEGES ON department.* TO 'LAB2_U2';

GRANT SELECT ON department.* TO 'LAB2_U2';

REVOKE SELECT ON department.* FROM 'LAB2_U2';

/*		
Autonumber
1.	Define the DDL for the following tables in the AutoNumber_table.png file
2.	Define the PKs and FK
3.	Create an autonumber that can be used for the ID columns.
4.	Create 4 insert statement that can be added to the tables using the autonumber. 
*/
CREATE TABLE pages (
	page_id INT AUTO_INCREMENT,
    author_id INT,
    available_to_group_id INT,
    availble_to_access_level_id INT,
    category_id INT,
    title VARCHAR(255),
    body TEXT,
    created_on DATETIME,
    updated_on DATETIME,
    secure_file_name VARCHAR(255),
    purchaseable TINYINT,
    PRIMARY KEY (page_id)
    );
    
CREATE TABLE page_downloads (
	page_download_d INT,
    page_id INT NOT NULL,
    file_id INT,
    PRIMARY KEY(page_download_d)
    );
DROP TABLE page_downloads;

ALTER TABLE pages
ADD FOREIGN KEY(page_id) REFERENCES page_downloads(page_id);
    
    

