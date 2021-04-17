-- CREATE DATABASE [dbTest];
-- GO

-- USE [dbTest];
-- GO

-- -- Först skapar vi highscore-tabellen och sätter in lite data för att ha något att jobba med.

-- DROP TABLE IF EXISTS highscore;
-- CREATE TABLE highscore (id INT IDENTITY(1,1) PRIMARY KEY,
--                         date DATETIME2 NOT NULL,
--                         score INT NOT NULL,
--                         difficulty VARCHAR(7) NOT NULL,
--                         name VARCHAR(10) NOT NULL);
-- GO

-- INSERT INTO highscore (date, score, difficulty, name) VALUES (SYSDATETIME(), FLOOR(RAND()*10000), 'hard',   CONCAT('user', FLOOR(RAND()*10000)));
-- INSERT INTO highscore (date, score, difficulty, name) VALUES (SYSDATETIME(), FLOOR(RAND()*10000), 'normal', CONCAT('user', FLOOR(RAND()*10000)));
-- INSERT INTO highscore (date, score, difficulty, name) VALUES (SYSDATETIME(), FLOOR(RAND()*10000), 'easy',   CONCAT('user', FLOOR(RAND()*10000)));
-- GO 3000

-- Just to make sure it's there
-- SELECT TOP(10) * FROM highscore ORDER BY score DESC;

-- Query to get database stats

-- SELECT DB_NAME(database_id),
--     MAX(user_scans) AS max,
--     AVG(user_scans) AS average
-- FROM sys.dm_db_index_usage_stats
-- GROUP BY db_name(database_id)
-- ORDER BY average DESC;

-- Query to make those stats change a bit

-- SELECT TOP(2) name, score FROM highscore WHERE name LIKE '%98%'; -- First one is a scan
-- SELECT TOP(2) name, score FROM highscore WHERE id = FLOOR(RAND()*4+1) -- This one is a seek
-- GO 20

-- Query to find which indexes has scans

-- SELECT OBJECT_NAME(idx.object_id) AS [table],
--     idx.name AS [index], user_scans, user_seeks,
--     CASE ustat.index_id
--     WHEN 1 THEN 'CLUSTERED'
--     ELSE 'NONCLUSTERED'
--     END AS type
-- FROM sys.dm_db_index_usage_stats AS ustat
--     JOIN sys.indexes idx
--     ON  idx.object_id=ustat.object_id
--         AND idx.index_id=ustat.index_id
--         AND database_id=DB_ID('dbTest') -- don't forget to have the correct db here
-- ORDER BY user_scans DESC;

-- example of a relatively large execution plan

-- USE Northwind;
-- SELECT et.employeeId, e.FirstName, e.LastName, t.territoryDescription, r.regionDescription FROM Employees AS e
-- INNER JOIN [EmployeeTerritories] AS et
--     ON (e.employeeId = et.employeeId)
-- INNER JOIN [Territories] AS t
--     ON (et.territoryId = t.territoryId)
-- INNER JOIN [Region] AS r
--     ON (t.RegionID = r.RegionID)
-- ORDER BY et.employeeId;

-- USE [dbTest];
-- GO

-- Have a look at the following query and how we can change how it behaves with indexes

SELECT TOP(10) name, score, date FROM highscore ORDER BY score ASC;

-- -- utan något index: 0.669704

-- CREATE INDEX highscore_idx ON highscore(score);
-- -- med ovan index 0.0365338

-- CREATE INDEX highscore_idx ON highscore(score DESC, date ASC, name);
-- -- med ovan index 0.0033233

-- -- med ovan index kan vi även sortera på datum utan större kostnad
-- SELECT TOP(10) name, score, date FROM highscore ORDER BY score DESC, date ASC;
-- SELECT name, score, date FROM highscore WHERE score = 120;
-- SELECT TOP(10) score, difficulty FROM highscore ORDER BY score DESC

-- DROP INDEX highscore.highscore_idx;



-- USE Northwind;
-- GO

-- set identity_insert "Employees" off
-- INSERT INTO "Employees" ("LastName","FirstName","Title","TitleOfCourtesy","BirthDate","HireDate","Address","City","Region","PostalCode","Country","HomePhone","Extension","Photo","Notes","ReportsTo","PhotoPath") VALUES('Fuller','Andrew','Vice President, Sales','Dr.','02/19/1952','08/14/1992','908 W. Capital Way','Tacoma','WA','98401','USA','(206) 555-9482','3457', NULL, NULL, NULL, NULL);
-- GO 10000

-- SELECT LastName FROM Employees WHERE LastName = 'Fuller';

-- CREATE INDEX somename_idx ON Employees(LastName, FirstName);
-- DROP INDEX Employees.somename_idx;


CREATE DATABASE [dbHS];
GO

USE [dbHS];
GO

DROP TABLE IF EXISTS highscore;
GO
DROP TABLE IF EXISTS difficulty;
GO
DROP TABLE IF EXISTS player;
GO
CREATE TABLE player (player_id INT IDENTITY(1,1) PRIMARY KEY,
                     email VARCHAR(70) NOT NULL UNIQUE,
                     name VARCHAR(50) NOT NULL);
GO
CREATE TABLE difficulty (difficulty_id INT IDENTITY(1,1) PRIMARY KEY,
                         name VARCHAR(8) NOT NULL);
GO
CREATE TABLE highscore (id INT IDENTITY(1,1) PRIMARY KEY,
                        date DATETIMEOFFSET NOT NULL,
                        score INT NOT NULL,
                        difficulty_id INT FOREIGN KEY REFERENCES difficulty(difficulty_id),
                        player_id INT FOREIGN KEY REFERENCES player(player_id))
GO

-- Sätta in data
INSERT INTO difficulty (name) VALUES ('easy');
INSERT INTO difficulty (name) VALUES ('normal');
INSERT INTO difficulty (name) VALUES ('hard');
GO
INSERT INTO player (email, name) VALUES ('nisse@hult.com', 'Nisse Hult')
INSERT INTO player (email, name) VALUES ('bosse@hult.com', 'Bosse Larsson')
INSERT INTO player (email, name) VALUES ('lena@lamm.se', 'Lena Lamm')
INSERT INTO player (email, name) VALUES ('leya@lamm.se', 'Leya Garcia')
GO
INSERT INTO highscore (date, score, difficulty_id, player_id) VALUES (SYSDATETIMEOFFSET(), 30,  2, 1)  -- normal, nisse
INSERT INTO highscore (date, score, difficulty_id, player_id) VALUES (SYSDATETIMEOFFSET(), 2,   3, 2)  -- hard, nisse
INSERT INTO highscore (date, score, difficulty_id, player_id) VALUES (SYSDATETIMEOFFSET(), 130, 1, 4)  -- normal, leya
INSERT INTO highscore (date, score, difficulty_id, player_id) VALUES (SYSDATETIMEOFFSET(), 221, 1, 3)  -- easy, lena
INSERT INTO highscore (date, score, difficulty_id, player_id) VALUES (SYSDATETIMEOFFSET(), 221, 3, 4)  -- hard, leya
INSERT INTO highscore (date, score, difficulty_id, player_id) VALUES (SYSDATETIMEOFFSET(), 225, 3, 4)  -- hard, leya
INSERT INTO highscore (date, score, difficulty_id, player_id) VALUES (SYSDATETIMEOFFSET(), 225, 3, 3)  -- hard, lena
GO