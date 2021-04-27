/*
Relationships between tables (relations) must be in the form of other relations
	base relations: named and autonomous relations not derived from other relations
	views: named derived relations (no stored data)
    snapshots: like views are named, derived relations, but they do not have stored data
    query results: result of a query - may or may not have name, and no persistent existence.
    
    Within every relation, need to uniquely identify every tuple:
		A primary key of a relation is a unique and minimal identifier for that relation
        Can be a single attribute - or may be a choice of attributes to use
        When primary key of one relatio used as an attribute in another relation it is a foreign key in that relation
        
        
	SQL - Manipulate relations and data in relational databases; structured query language
    DDL - Define, maintain, drop schema objects; data dictionary language which defines the data inside the DMBS and how it is structuured.
    DML - Data manipulation language; manipulates physical data inside a DBMS
    DCL - Data control language; manages security, concurrent access, etc.
    
    Physical and logical database integrity
		1st - Immunity to physical failures, regular backups. 
        2nd - Reconstruction ability; maintain a log of transactions; replay log to restore systems to a previous stable point
    Element integrity
    Auditability
    Access control
    User authentication
    Availability
    
    Security requirements:
		Element integrity
			integrity of database elements is their correctness or accuracy
				field checks
					Allow only acceptable values
				access controls
					Allow only authorized users to update elements
				change log
					Used to undo changes made in error
				Referential integrity (key integrity concerns)
                two phase locking process
			
		Auditability
			log read/write to a database
            
		Access Control (Similar to OS)
			logical separation by user access privileges
            more complicated than OS due to complexity of DB 
		User Authentication
			May be separate from OS
			Can be rigorous
		Availability
			Concurrent users
            Reliability
            
		Slide 10 - 27 TODO
            
		
    
*/