DELIMITER //
CREATE FUNCTION DOLLARS(AMOUNT DECIMAL(7,2))
   RETURNS DECIMAL(7,2) DETERMINISTIC
BEGIN
     RETURN AMOUNT * (1 / 0.8);
END
//
SELECT   PAYMENTNO, AMOUNT, DOLLARS(AMOUNT)
FROM     PENALTIES
GROUP BY PAYMENTNO


CREATE FUNCTION NUMBER_OF_PLAYERS()
   RETURNS INTEGER
BEGIN
   RETURN (SELECT COUNT(*) FROM PLAYERS);
END


SELECT NUMBER_OF_PLAYERS()




CREATE FUNCTION NUMBER_OF_PENALTIES
   (P_PLAYERNO INTEGER)
   RETURNS INTEGER
BEGIN
   RETURN (SELECT   COUNT(*) 
           FROM     PENALTIES
           WHERE    PLAYERNO = P_PLAYERNO);
END





CREATE FUNCTION NUMBER_OF_MATCHES
   (P_PLAYERNO INTEGER)
   RETURNS INTEGER
BEGIN
   RETURN (SELECT   COUNT(*) 
           FROM     MATCHES
           WHERE    PLAYERNO = P_PLAYERNO);
END



SELECT   PLAYERNO, NAME, INITIALS
FROM     PLAYERS
WHERE    NUMBER_OF_PENALTIES(PLAYERNO) > NUMBER_OF_MATCHES(PLAYERNO)

DELIMITER //
CREATE FUNCTION NUMBER_OF_DAYS
   (START_DATE DATE,
    END_DATE DATE)
    RETURNS INTEGER deterministic
BEGIN
   DECLARE DAYS INTEGER;
   DECLARE NEXT_DATE, PREVIOUS_DATE DATE;
   SET DAYS = 0;
   SET NEXT_DATE = START_DATE + INTERVAL 1 DAY;
   WHILE NEXT_DATE <= END_DATE DO
      SET DAYS = DAYS + 1;
      SET PREVIOUS_DATE = NEXT_DATE;
      SET NEXT_DATE = NEXT_DATE + INTERVAL 1 DAY;
   END WHILE;
   RETURN DAYS;
END;
//

SELECT NUMBER_OF_DAYS('20200101','20210101')

CREATE FUNCTION DELETE_PLAYER
   (P_PLAYERNO INTEGER)
   RETURNS BOOLEAN
BEGIN
   DECLARE NUMBER_OF_PENALTIES INTEGER;
   DECLARE NUMBER_OF_TEAMS  INTEGER;
   DECLARE EXIT HANDLER FOR SQLWARNING RETURN FALSE;
   DECLARE EXIT HANDLER FOR SQLEXCEPTION RETURN FALSE;

   SELECT COUNT(*)
   INTO   NUMBER_OF_PENALTIES
   FROM   PENALTIES
   WHERE  PLAYERNO = P_PLAYERNO;


   SELECT COUNT(*)
   INTO   NUMBER_OF_TEAMS
   FROM   TEAMS
   WHERE  PLAYERNO = P_PLAYERNO;


   IF NUMBER_OF_PENALTIES = 0 AND NUMBER_OF_TEAMS = 0 THEN
      DELETE FROM MATCHES
      WHERE  PLAYERNO = P_PLAYERNO;
      DELETE FROM PLAYERS
      WHERE  PLAYERNO = P_PLAYERNO;
   END IF;

   RETURN TRUE;

END




CREATE FUNCTION NUMBER_OF_PLAYERS ()
   RETURNS INTEGER
BEGIN
   DECLARE NUMBER INTEGER;
   CALL NUMBER_OF_PLAYERS(NUMBER);
   RETURN NUMBER;
END







CREATE TABLE CHANGES
      (USER               CHAR(30) NOT NULL,
       CHA_TIME           TIMESTAMP NOT NULL,
       CHA_PLAYERNO       SMALLINT NOT NULL,
       CHA_TYPE           CHAR(1) NOT NULL,
       CHA_PLAYERNO_NEW   INTEGER,
       PRIMARY KEY        (USER, CHA_TIME,
                          CHA_PLAYERNO, CHA_TYPE))


CREATE TRIGGER INSERT_PLAYERS
   BEFORE 
   INSERT ON PLAYERS FOR EACH ROW
   BEGIN
      INSERT INTO CHANGES
         (USER, CHA_TIME, CHA_PLAYERNO,
          CHA_TYPE, CHA_PLAYERNO_NEW)
      VALUES (USER, CURDATE(), NEW.PLAYERNO, 'I', NULL);
      NEW.FIRSTNAME NEW.LASTNAME
   END

INSERT INTO PLAYERS ( PLAYERNO, FIRSTNAME, LASTNAME) VALUES( 3, 'Darcy','Ricetto')

CREATE PROCEDURE INSERT_CHANGE
   (IN CPNO       INTEGER,
    IN CTYPE      CHAR(1),
    IN CPNO_NEW   INTEGER)
BEGIN
   INSERT INTO CHANGES (USER, CHA_TIME, CHA_PLAYERNO,
                        CHA_TYPE, CHA_PLAYERNO_NEW)
   VALUES (USER, CURDATE(), CPNO, CTYPE, CPNO_NEW);
END


CREATE TRIGGER INSERT_PLAYER
   AFTER INSERT ON PLAYERS FOR EACH ROW
   BEGIN
      CALL INSERT_CHANGE(NEW.PLAYERNO, 'I', NULL);
   END


CREATE TRIGGER DELETE_PLAYER
   AFTER DELETE ON PLAYERS FOR EACH ROW
   BEGIN
      CALL INSERT_CHANGE (OLD.PLAYERNO, 'D', NULL);
   END



CREATE TRIGGER UPDATE_PLAYER
   AFTER UPDATE ON PLAYERS FOR EACH ROW
   BEGIN
      CALL INSERT_CHANGES
         (NEW.PLAYERNO, 'U', OLD.PLAYERNO);
   END


CREATE TRIGGER UPDATE_PLAYER2
   AFTER UPDATE(LEAGUENO) ON PLAYERS FOR EACH ROW
   BEGIN
      CALL INSERT_CHANGE
         (NEW.PLAYERNO, 'U', OLD.PLAYERNO);
   END


CREATE TRIGGER UPDATE_PLAYER
   AFTER UPDATE OF PLAYERS FOR EACH ROW
   WHEN ( NEW.LEAGUENO <> OLD.LEAGUENO )
   BEGIN
      INSERT INTO CHANGES
      (USER, CHA_TIME, CHA_PLAYERNO, CHA_TYPE, 
          CHA_PLAYERNO_OLD)
      VALUES (USER, SYSDATE, NEW.PLAYERNO, 'U',
          OLD.PLAYERNO);
   END


CREATE TABLE PLAYERS_MAT
     (PLAYERNO INTEGER NOT NULL PRIMARY KEY,
      NUMBER_OF_MATCHES INTEGER NOT NULL)


INSERT INTO PLAYERS_MAT (PLAYERNO, NUMBER_OF_MATCHES)
SELECT   PLAYERNO, 
        (SELECT   COUNT(*)
         FROM     MATCHES AS M
         WHERE    P.PLAYERNO = M.PLAYERNO)
FROM     PLAYERS AS P




CREATE TRIGGER INSERT_PLAYERS
   AFTER INSERT ON PLAYERS FOR EACH ROW
   BEGIN
      INSERT INTO PLAYERS_MAT
      VALUES(NEW.PLAYERNO, 0);
   END





CREATE TRIGGER DELETE_PLAYERS
   AFTER DELETE ON PLAYERS FOR EACH ROW
   BEGIN
      DELETE FROM PLAYERS_MAT
      WHERE PLAYERNO = OLD.PLAYERNO;
   END


CREATE TRIGGER INSERT_MATCHES
   AFTER INSERT ON MATCHES FOR EACH ROW
   BEGIN
      UPDATE PLAYERS_MAT
      SET    NUMBER_OF_MATCHES = NUMBER_OF_MATCHES + 1
      WHERE  PLAYERNO = NEW.PLAYERNO;
   END





CREATE TRIGGER DELETE_MATCHES
   AFTER DELETE ON MATCHES FOR EACH ROW
   BEGIN
      UPDATE PLAYERS_MAT
      SET    NUMBER_OF_MATCHES = NUMBER_OF_MATCHES - 1
      WHERE  PLAYERNO = OLD.PLAYERNO;
   END




CREATE TRIGGER SUM_PENALTIES_INSERT
   AFTER INSERT ON PENALTIES FOR EACH ROW
   BEGIN
      DECLARE TOTAL DECIMAL(8,2);

      SELECT   SUM(AMOUNT)
      INTO     TOTAL
      FROM     PENALTIES
      WHERE    PLAYERNO = NEW.PLAYERNO;

      UPDATE   PLAYERS
      SET      SUM_PENALTIES = TOTAL
      WHERE    PLAYERNO = NEW.PLAYERNO

   END




CREATE TRIGGER SUM_PENALTIES_DELETE
   AFTER DELETE, UPDATE ON PENALTIES FOR EACH ROW
   BEGIN
      DECLARE TOTAL DECIMAL(8,2);

      SELECT   SUM(AMOUNT)
      INTO     TOTAL
      FROM     PENALTIES
      WHERE    PLAYERNO = OLD.PLAYERNO;

      UPDATE   PLAYERS
      SET      SUM_PENALTIES = TOTAL
      WHERE    PLAYERNO = OLD.PLAYERNO
   END


UPDATE   PLAYERS
SET      SUM_PENALTIES = (SELECT   SUM(AMOUNT)
                         FROM     PENALTIES
                          WHERE    PLAYERNO = NEW.PLAYERNO)

WHERE    PLAYERNO = NEW.PLAYERNO



CREATE TRIGGER BIRTHJOINED
   BEFORE INSERT, UPDATE(BIRTH_DATE, JOINED) OF PLAYERS
      FOR EACH ROW
   WHEN (YEAR(NEW.BIRTH_DATE) >= NEW.JOINED)
   BEGIN
      ROLLBACK WORK;
   END;




CREATE TRIGGER BIRTHJOINED
   BEFORE INSERT, UPDATE ON PLAYERS FOR EACH ROW
   BEGIN
      IF YEAR(NEW.BIRTH_DATE) >= NEW.JOINED) THEN
         ROLLBACK WORK;
      END IF;
   END;



CREATE TRIGGER FOREIGN_KEY1
   BEFORE INSERT, UPDATE(PLAYERNO) OF PENALTIES FOR EACH ROW
   BEGIN
      DECLARE NUMBER INTEGER;
      SELECT  COUNT(*)
      INTO    NUMBER
      FROM    PLAYERS
      WHERE   PLAYERNO = NEW.PLAYERNO;

      IF NUMBER = 0 THEN
         ROLLBACK WORK;
      END IF;

   END


CREATE TRIGGER FOREIGN_KEY1
   BEFORE INSERT, UPDATE ON PENALTIES FOR EACH ROW
   BEGIN
      IF (SELECT COUNT(*) FROM PLAYERS
         WHERE PLAYERNO = NEW.PLAYERNO) = 0 THEN
         ROLLBACK WORK;
      END IF;

   END




CREATE TRIGGER FOREIGN_KEY2
   BEFORE DELETE, UPDATE(PLAYERNO) OF PLAYERS FOR EACH ROW
   BEGIN
      DELETE
      FROM     PENALTIES
      WHERE    PLAYERNO = OLD.PLAYERNO;
      
      IF SALARY > 5%
		SET NEW.SALARY = SALARY *1.05
      
      
      SET NEW.GAMES_PLAYED = 10;
      
   END


CREATE TRIGGER FOREIGN_KEY2
   BEFORE DELETE, UPDATE ON PLAYERS FOR EACH ROW
   BEGIN
      DELETE
      FROM     PENALTIES
      WHERE    PLAYERNO = OLD.PLAYERNO;

   END







CREATE TRIGGER MAX1
   AFTER INSERT, UPDATE(POSITION) OF COMMITTEE_MEMBERS
      FOR EACH ROW
   BEGIN

     SELECT   COUNT(*)
      INTO     NUMBER_MEMBERS
      FROM     COMMITTEE_MEMBERS
      WHERE    PLAYERNO IN
              (SELECT   PLAYERNO
               FROM     COMMITTEE_MEMBERS
               WHERE    CURRENT DATE BETWEEN
                        BEGIN_DATE AND END_DATE
               GROUP BY POSITION
               HAVING   COUNT(*) > 1)

      IF NUMBER_MEMBERS > 0 THEN
         ROLLBACK WORK;
      ENDIF;

   END;




CREATE TRIGGER SUM_PENALTIES_250
   AFTER INSERT, UPDATE(AMOUNT) OF PENALTIES
      FOR EACH ROW
   BEGIN
      SELECT   COUNT(*)
      INTO     NUMBER_PENALTIES
      FROM     PENALTIES
      WHERE    PLAYERNO IN
              (SELECT   PLAYERNO
               FROM     PENALTIES
               GROUP BY PLAYERNO
               HAVING   SUM(AMOUNT) > 250);

      IF NUMBER_PENALTIES > 0 THEN
         ROLLBACK WORK;
      ENDIF;

   END;




CREATE TRIGGER NUMBER_MATCHES_INSERT
   AFTER INSERT OF MATCHES FOR EACH ROW
   BEGIN
      UPDATE   TEAMS
      SET      NUMBER_MATCHES =
              (SELECT   COUNT(*)
               FROM     MATCHES
               WHERE    PLAYERNO = NEW.PLAYERNO)
      WHERE    PLAYERNO = NEW.PLAYERNO

END;


CREATE TRIGGER NUMBER_MATCHES_DELETE
   AFTER DELETE, UPDATE OF MATCHES FOR EACH ROW
   BEGIN
      UPDATE   TEAMS
      SET      NUMBER_MATCHES =
              (SELECT   COUNT(*)
               FROM     MATCHES
               WHERE    PLAYERNO = OLD.PLAYERNO)
      WHERE    PLAYERNO = OLD.PLAYERNO

END;

