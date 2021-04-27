/* PowerPoint week 2 

Table spaces - Stores related database objects
Segments - Stores an individual database object, such as a table or index
Extent - A continguous unit of storage space within a segment
Data Block - Smallest storage unit that the database can address. 

Tablespaces logically divide a database. Each table space can be online (accessible), or offline (not)
2 default tablespaces - SYSTEM and SYSUAX - exist in every database. 
temporary tablespaces provide performance improvements when you have multiple sorts that are too large to fit into memory. 
All operations that use sorts (joins, unions, index builds, ordering, and aggregates benefit from temporary tablespaces.
The read-only tablespace eliminates the need to perform backup and recovery of large, static portions of a database.

Databases stores data logically in tablespaces and physically in datafiles associated with the corresponding tablespace

The size of a tablespace is the size of the datafiles that constitute the tablespace. The size of a database is the collective size of the tablespaces that constitute the database. 
ALTER TABLE TABLESPACE system
ADD DATAFILE 'DATA2.ORA'

Creating a tablespace:
	CREATE TABLESPACE tablespace_name
	DATAFILE file_name [SIZE [datatype] M]
    DEFAULT STORAGE (
		INITIAL [datatype] M
        NEXT [datatype] M
        MINEXTENDS [datatype]
        MAXEXTENDS [datatype]
        PCTINCREASE [datatype])
        ONLINE [or] OFFLINE
        PERMANENT [or] TEMPORARY;

INITIAL : size for initial extent of the table
NEXT : Any additional extents the table may take through growth
MINEXTENTS, MAXTENTS : Minimum and maximum extents allowed for the table
PCTINCREASE : The percentage each extent will be increased each time the table grows, or takes another extent

CREATE TABLE table_name (
column_name data_type [DEFAULT exp][CONSTRAINT])
TABLESPACE tablespace_name
STORAGE (INITIAL size K or M
		 NEXT size K or M
		 MINEXTENTS value
         MAXEXTENTS value
         PCTINCREASE value);
         
CREATE TABLE maha
id NUMBER CONSTRAINT co_id PRIMARY KEY
name varchar(20))
TABLESPACE tp
STORAGE (INITIAL 7000
		 NEXT 7000
         MINEXTENTS 1
         MAXEXTENTS 5
         PCTINCREASE 5);
         
The level of logical database storage above an extent is called a segment. A segment is a set of extents allocated for a certain logical structure. 
Types of segments:
	Data segments:
		Every table in a database has a single data segment
	Index segments:
		Every index in a database has a single index segment holds all of its data
	Temporary segments:
		When an SQL statement needs a temporary work area to complete execution. When the statement finishes execution, the temporary segments extents are returned to the system for future 
        use.
	Rollback segments:
		Records old values of data that was changed by each transaction
        

	
*/