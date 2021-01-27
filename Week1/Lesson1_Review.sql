USE tennis;

SELECT PLAYERNO, NAME, BIRTH_DATE
FROM PLAYERS
WHERE TOWN='Stratford'
ORDER BY NAME;

SELECT PLAYERNO, NAME, BIRTH_DATE
FROM PLAYERS
WHERE JOINED > 1980
OR TOWN = 'Stratford'
ORDER BY PLAYERNO;
