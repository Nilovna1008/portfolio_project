-- Best Netflix Shows Exploration. --
-- Skills Used: ALIASES, COUNT, DISTINCT, WHERE clause , LIKE and In Operator, 
-- De Morgan's Law, Sub-query, GROUP BY and ORDER BY , COMBINING COLUMNS, HAVING, CASES , 
-- CREATING NEW TABLE , INSERT INTO , AND CREATING VIEWS--

-- Loading data --
SELECT * FROM database_portfolio.bestshowsnetflix AS DF ;

-- Number of distinct genre -- 
SELECT COUNT(DISTINCT MAIN_GENRE) 
FROM database_portfolio.BESTSHOWSNETFLIX;

-- There are 12 distinct genres in the dataset.--

-- THE WHERE CLAUSE TO FILTER DATA--

SELECT COUNT(TITLE) FROM database_portfolio.BESTSHOWSNETFLIX
WHERE MAIN_PRODUCTION = 'JP' AND MAIN_GENRE = 'scifi';

-- There are 12 entries in the dataset where the main production is in Japan and the genre is Sci-fi. --

SELECT COUNT(TITLE) FROM database_portfolio.BESTSHOWSNETFLIX
WHERE NUMBER_OF_SEASONS >= 5 AND MAIN_GENRE != 'comedy' ;

-- There are 52 shows that have more than 5 seasons and  their genre is not comedy --

SELECT COUNT(TITLE) FROM database_portfolio.BESTSHOWSNETFLIX
WHERE DURATION BETWEEN 25 AND 40 ;

-- There are 55 shows whose duration is between 25 and 40 minutes --

SELECT TITLE , RELEASE_YEAR FROM database_portfolio.BESTSHOWSNETFLIX
WHERE TITLE LIKE 'A%'  AND RELEASE_YEAR LIKE '20%' ;

-- This query returns the name of the shows which start with an A and their release year is in the 2000s  --

SELECT * FROM database_portfolio.BESTSHOWSNETFLIX
WHERE MAIN_PRODUCTION IN ( 'IN','CA') ;

-- This query returns the shows that were produced in India and Canada --

SELECT * FROM database_portfolio.BESTSHOWSNETFLIX
WHERE NOT MAIN_PRODUCTION IN ( 'US','JP') ;

-- This query returns the shows where the main production was not in USA and Japan -- 

-- DE MORGAN'S LAW --

SELECT * FROM database_portfolio.BESTSHOWSNETFLIX
WHERE NOT MAIN_PRODUCTION = 'US' OR NOT MAIN_PRODUCTION = 'JP' ;

SELECT * FROM database_portfolio.BESTSHOWSNETFLIX
WHERE NOT (MAIN_PRODUCTION ='US'AND MAIN_PRODUCTION= 'JP');

-- The above two queries show the DE Morgan's Law in working. --


-- HIGHEST SCORE USING SUBQUERY--

SELECT SCORE, TITLE  
FROM 
    (SELECT SCORE, TITLE
     FROM  database_portfolio.BESTSHOWSNETFLIX
     ORDER BY SCORE DESC 
     LIMIT 3) AS TOP3
ORDER BY SCORE DESC
LIMIT 1;

-- This query uses a sub-query to fetch the highest score & title of the show --

-- TOP SHOW IN EACH CATEGORY --

SELECT TITLE, SCORE, MAIN_GENRE 
FROM database_portfolio.BESTSHOWSNETFLIX
WHERE (MAIN_GENRE,SCORE) IN (SELECT MAIN_GENRE, MAX(SCORE)
 FROM  database_portfolio.BESTSHOWSNETFLIX
GROUP BY MAIN_GENRE);

-- This query bring out the highest score and title of the show in each of the 12 distinct category of genre, here you see 13 records as a result of Mindhunter & Making a a Murderer received a score of 8.6 each in the same category 'crime' --

SELECT TITLE, SCORE, MAIN_PRODUCTION 
FROM database_portfolio.BESTSHOWSNETFLIX
WHERE (MAIN_PRODUCTION,SCORE) IN (SELECT MAIN_PRODUCTION, MAX(SCORE)
 FROM  database_portfolio.BESTSHOWSNETFLIX
GROUP BY MAIN_PRODUCTION);

-- This query fetches the highest score of a show in the category of main production, like Attack on titans, Hunter x Hnter and Death Note have 9 as the highest score and their main production is Japan --

SELECT TITLE, NUMBER_OF_SEASONS, MAIN_GENRE 
FROM database_portfolio.BESTSHOWSNETFLIX
WHERE (MAIN_GENRE,NUMBER_OF_SEASONS) IN 
(SELECT MAIN_GENRE, MAX(NUMBER_OF_SEASONS)
 FROM  database_portfolio.BESTSHOWSNETFLIX
GROUP BY MAIN_GENRE) ORDER BY NUMBER_OF_SEASONS DESC;

-- This query fetches the show with the highest number of seasons in each genre --

-- COMBINING COLUMNS --

SELECT TITLE, CONCAT(RELEASE_YEAR, ',', MAIN_PRODUCTION) AS INFO
FROM database_portfolio.BESTSHOWSNETFLIX ;

-- This query combines the two columns RELEASE_YEAR & MAIN_PRODUCTION into a single column named as INFO separated by a , --

-- GROUP BY , HAVING--
SELECT COUNT(TITLE), MAIN_PRODUCTION FROM database_portfolio.BESTSHOWSNETFLIX
GROUP BY MAIN_PRODUCTION
HAVING AVG(DURATION) >= '30' ;

-- This query counts the number of show in each main production whose average duration is greater than equal to 30 --

-- CASES-- 

SELECT TITLE, NUMBER_OF_SEASONS, 
CASE
 WHEN NUMBER_OF_SEASONS > 5 THEN 'WEEB'
WHEN NUMBER_OF_SEASONS <= 5 AND NUMBER_OF_SEASONS >= 3 THEN 'MED'
ELSE 'NOOB'
END AS DOABLE
FROM database_portfolio.BESTSHOWSNETFLIX;

-- This query adds a new column 'DOABLE' based on the cases --


-- NEW TABLE-- 
DROP TABLE  IF EXISTS DG;
CREATE TABLE DG
(
TITLE varchar(255),
NUMBER_OF_SEASONS INT,
DOABLE  VARCHAR (255)) ;

INSERT INTO DG ( TITLE,NUMBER_OF_SEASONS, DOABLE) 
SELECT TITLE, NUMBER_OF_SEASONS, 
CASE
 WHEN NUMBER_OF_SEASONS > 5 THEN 'WEEB'
WHEN NUMBER_OF_SEASONS <= 5 AND NUMBER_OF_SEASONS >= 3 THEN 'MED'
ELSE 'NOOB'
END AS DOABLE
FROM database_portfolio.BESTSHOWSNETFLIX;

-- This query creates a new table where the data is populated using the case query used above -- 

SELECT * FROM DG;
CREATE VIEW  VIZ AS 
SELECT TITLE, NUMBER_OF_SEASONS, 
CASE
 WHEN NUMBER_OF_SEASONS > 5 THEN 'WEEB'
WHEN NUMBER_OF_SEASONS <= 5 AND NUMBER_OF_SEASONS >= 3 THEN 'MED'
ELSE 'NOOB'
END AS DOABLE
FROM database_portfolio.BESTSHOWSNETFLIX;

-- This query creates a View of the table created above --