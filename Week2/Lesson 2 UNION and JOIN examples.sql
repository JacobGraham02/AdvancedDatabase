
-- drop the database is one exists by the same name
DROP DATABASE IF EXISTS db_jobs;
-- create the database
CREATE DATABASE db_jobs;
-- use the database
USE db_jobs;


-- create the table structure to store information about clients/contacts
CREATE TABLE tbl_my_contacts
(
	contact_id	INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	last_name  	VARCHAR(30) NOT NULL ,
	first_name	VARCHAR(20) NOT NULL,
	phone 		CHAR(13),
	email		VARCHAR(50) NOT NULL,
	gender		ENUM('M','F') NOT NULL ,
	birthday	DATE NOT NULL,
	zip 		CHAR(5) NOT NULL
);


-- insert client/contact data into the table
INSERT INTO tbl_my_contacts(last_name, first_name, phone,email, gender,birthday,zip)
VALUES
('Anderson','Jillian','(555)555-3214','jill_anderson@breakneckpizza.com','F','1980-09-05','12345'),
('Kenton','Leo','(567)565-5514','lkenton@starbuzzcoffee.com','M','1974-01-10','55467'),
('McGavin','Darrin','(678)559-7890',' captainlove@headfirsttheater.com','M','1966-01-23','64578'),
('Franklin','Joe','(578)543-4235','joe_franklin@leapinlimos.com','M','1977-04-28','32456'),
('Hamilton','Jamie','(789)542-3768','dontbother@starbuzzcoffee.com','F','1964-09-10','55467'),
('Chevrolet','Maurice','(235)521-3344','bookman4u@objectville.net','M','1962-07-01','25790'),
('Kroger','Renee','(556)546-1234','poorrenee@mightygumball.net','F','1976-12-03','55467'),
('Mendoza','Angelina','(545)523-3456','angelina@starbuzzcoffee.com','F','1979-08-19','77567'),
('Murphy','Donald','(225)325-3544','padraic@tikibeanlounge.com','M','1967-01-23','12345'),
('Spatner','John','(550)125-1114','jpoet@objectville.net','M','1963-04-18','34125');

-- create the table structure to store information on contact/client current job
CREATE TABLE tbl_job_current
(
	contact_id      INT UNSIGNED  PRIMARY KEY,
	title 		VARCHAR(30) NOT NULL ,
	salary 		DEC(8,2) UNSIGNED NOT NULL,
	start_date 	DATE NOT NULL,

	CONSTRAINT tbl_my_contacts_contact_id_fk1
	FOREIGN KEY (contact_id)
	REFERENCES tbl_my_contacts(contact_id)
);
-- insert data in the job current table
INSERT INTO tbl_job_current
VALUES
(1,'Technical Writer',80000.00,'2010-01-01'),
(2,'Manager',110000.00,'2000-05-31'),
(3,'Web Designer',75000.00,'1986-05-05'),
(4,'Software Sales',60000.00,'2003-06-19'),
(5,'System Administrator',120000.00, '1990-01-01'),
(6,'Bookshop Owner',90000.00,'1992-07-18'),
(8,'UNIX Sysadmin',110000.00,'2005-10-10'),
(9,'Baker',80000.00,'1987-10-26');

-- create the table structure to store job desired by a client/contact
CREATE TABLE tbl_job_desired
(
	contact_id 	INT UNSIGNED  PRIMARY KEY,
	title 		VARCHAR(30),
	salary_low 	DEC(8,2) UNSIGNED NOT NULL,	-- ready to take salary this low
	salary_high DEC(8,2) UNSIGNED NOT NULL,  -- the expected salary
	years_exp 	TINYINT UNSIGNED DEFAULT 0,

	CONSTRAINT tbl_my_contacts_contact_id_fk2
	FOREIGN KEY (contact_id)
	REFERENCES tbl_my_contacts(contact_id)
);

-- insert data in the job desired table
INSERT INTO tbl_job_desired
VALUES
(7,'Computer Programmer',80000.00, 100000.00,10),
(8,'Computer Programmer',90000.00, 150000.00,10),
(4,'Sales Manager',75000.00, 85000.00, 11),
(10,'Baker',60000.00, 70000.00, 2),
(9,'Chef', 90000.00, 100000, 20);


-- create the table structure to store information about job listings in the market
CREATE TABLE tbl_job_listings
(
	job_id 		INT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
	title 		VARCHAR(30) NOT NULL,
	salary 		DEC(8,2) UNSIGNED NOT NULL,
	zip 		CHAR(5) NOT NULL
);

-- insert data in the table job listings table
INSERT INTO tbl_job_listings(title, salary, zip)
VALUES
('Baker', 60000.00,'12345'),
('Clown',50000.00,'34625'),
('Dog Trainer',55000.00,'14624'),
('Hairdresser',70000.00,'67435'),
('Jeweler',66000.00,'45231'),
('Lawyer', 100000.00, '24675'),
('Mechanic',55000.00,'67890'),
('Neurosurgeon',150000.00,'34125'),
('Web Designer',95000.00,'64578'),
('Teacher',60000.00,'25790'),
('Salesman',60000.00,'55467'),
('Artist',67000.00,'46890'),
('Computer Programmer',75000.00,'12345'),
('Manager', 80000.00,'32587');

-- select data from all tables
SELECT * FROM tbl_my_contacts;
SELECT * FROM tbl_job_current;
SELECT * FROM tbl_job_desired;
SELECT * FROM tbl_job_listings;

-- 1) UNION (removes duplicates) and UNION ALL(keeps duplicates)
-- To get all the possible job titles from all the three tables.
SELECT title FROM tbl_job_current
UNION
SELECT title FROM tbl_job_desired
UNION
SELECT title  FROM tbl_job_listings;


-- 2a)INTERSECT/INTERSECT ALL - not supported in MySQL
-- Produce the job titles that are common in the two tables-tbl_job_listings and tbl_job_desired.
-- contact looking for job and it is available 

/*SELECT title  FROM tbl_job_desired
INTERSECT
SELECT title  FROM tbl_job_listings;*/

-- 2b) Which desired jobs are available in job listings?
/*SELECT *
FROM tbl_job_desired INNER JOIN tbl_job_listings ; -- cartesian product*/

-- a 
SELECT tbl_job_desired.title
FROM tbl_job_desired INNER JOIN tbl_job_listings 
WHERE TRIM(tbl_job_desired.title) = TRIM(tbl_job_listings.title);

SELECT tbl_job_desired.title
FROM tbl_job_desired , tbl_job_listings 
WHERE TRIM(tbl_job_desired.title) = TRIM(tbl_job_listings.title);

-- b 
-- if the field names are same and joining condition is equality
-- exact match ; padded blanks are not ignored
/*
-- you can always remove extra padded blanks
UPDATE tbl_job_desired
SET title = TRIM(title);
UPDATE tbl_job_listings
SET title = TRIM(title);
*/

SELECT tbl_job_desired.title
FROM tbl_job_desired NATURAL JOIN tbl_job_listings; 

-- c 
SELECT tbl_job_desired.title
FROM tbl_job_desired INNER JOIN  tbl_job_listings -- CANNOT USE COMMA
USING(title); -- exact match ; padded blanks are not ignored


-- d use alias names
SELECT jd.title
FROM tbl_job_desired JD, tbl_job_listings JL
WHERE TRIM(JD.title) = TRIM(JL.title);

-- e show title only once
SELECT DISTINCT JD.title
FROM tbl_job_desired JD, tbl_job_listings JL
WHERE TRIM(JD.title) = TRIM(JL.title);

-- use left outer join 
SELECT * -- DISTINCT JD.title
FROM tbl_job_desired JD LEFT OUTER JOIN tbl_job_listings JL 
ON JD.title = JL.title
WHERE job_id IS NOT NULL;

-- use right outer join - less efficient - choice of master table is important
SELECT * --  DISTINCT JD.title
FROM tbl_job_desired JD RIGHT OUTER JOIN tbl_job_listings JL 
ON JD.title = JL. title
WHERE contact_id IS NOT NULL;


-- 3) EXCEPT/EXCEPT ALL/MINUS - NOT SUPPORTED IN MySQL
-- A list of job titles that are desired but not in the listings
/*
SELECT title  FROM tbl_job_desired
EXCEPT
SELECT title  FROM tbl_job_listings;

SELECT title  FROM tbl_job_desired
MINUS
SELECT title  FROM tbl_job_listings;
*/
/* incorrect solution
SELECT *
FROM tbl_job_desired JD, tbl_job_listings JL
WHERE TRIM(JD.title) <> TRIM(JL.title);
*/
-- left outer join
-- step 1
SELECT *
FROM tbl_job_desired JD LEFT OUTER JOIN tbl_job_listings JL -- the table on the left is the 'master table'
ON TRIM(JD.title) = TRIM(JL.title);
-- step 2
SELECT *
FROM tbl_job_desired JD LEFT OUTER JOIN tbl_job_listings JL
ON TRIM(JD.title) = TRIM(JL.title)
WHERE job_id IS NULL;
-- step 3
SELECT JD.title
FROM tbl_job_desired JD LEFT OUTER JOIN tbl_job_listings JL
ON TRIM(JD.title) = TRIM(JL.title)
WHERE job_id IS  NULL;

-- right outer join - just switched the tables tbl_job_desired is still the MASTER table
-- step 1
SELECT *
FROM tbl_job_listings JL RIGHT OUTER JOIN tbl_job_desired JD -- the table on the right is the 'master table'
ON TRIM(JD.title) = TRIM(JL.title);
-- step 2
SELECT *
FROM tbl_job_listings JL RIGHT OUTER JOIN tbl_job_desired JD -- the table on the right is the 'master table'
ON TRIM(JD.title) = TRIM(JL.title)
WHERE job_id IS NULL;
-- step 3
SELECT JD.title
FROM tbl_job_listings JL RIGHT OUTER JOIN tbl_job_desired JD -- the table on the right is the 'master table'
ON TRIM(JD.title) = TRIM(JL.title)
WHERE job_id IS  NULL;
-- in the above tbl_job_listings CANNOT be the master table, we want those records that are in tbl_job_desired but not in tbl_job_listings, hence we want to check all records of the tbl_job_desired, not of the tbl_job_listings
-- subquery
SELECT title
FROM tbl_job_desired
WHERE title NOT IN (SELECT title FROM tbl_job_listings);



SELECT jc2.*, mc.*, jc.*, jd.*  FROM tbl_my_contacts mc INNER JOIN tbl_job_current jc 
on mc.contact_id = jc.contact_id
LEFT OUTER JOIN tbl_job_desired jd ON  jd.contact_id = jc.contact_id
RIGHT OUTER JOIN  tbl_job_current JC2 ON JC2.contact_id  = mc.contact_id
WHERE mc.gender = 'M'
--AND MC.CONTACT_ID = 2

SELECT  mc.*, jc.*  FROM tbl_my_contacts mc,  tbl_job_current jc 
where mc.contact_id = jc.contact_id
and mc.gender = 'M'

 
SELECT * FROM tbl_job_desired;





