-- SELECT name, database_id, compatibility_level FROM sys.databases;

-- SELECT * FROM sys.databases;

-- USE Northwind;
-- SELECT so.name as Tabell,
--     sc.name as Fält
-- FROM sys.columns as sc
--     JOIN sys.objects as so
--     ON so.object_id = sc.object_id
-- WHERE
--     so.type ='U'
--     AND so.name <> 'dtproperties'
-- ORDER BY so.name;

-- SELECT db.name, mf.physical_name
-- FROM sys.databases AS db
--     JOIN sys.master_files AS mf
--     ON mf.database_id = db.database_id;


-- EXEC sp_monitor;

-- EXEC sp_helpserver;
-- EXEC sp_help 'region';
-- EXEC sp_helpdb 'pubs';

-- CREATE DATABASE [dbTest];

-- CREATE TABLE CharTest (namn VARCHAR(MAX), annat_namn NVARCHAR(MAX));

-- INSERT INTO CharTest (namn, annat_namn) VALUES ('Bosse', N'Båsse');
-- INSERT INTO CharTest (namn, annat_namn) VALUES ('Båsse', N'Båsse');

-- SELECT * FROM CharTest;

-- EXEC sp_help 'CharTest';

-- DROP TABLE IF EXISTS IdTest;
-- GO
-- CREATE TABLE IdTest (id INT IDENTITY(-2147483645, -1), val INT);
-- GO
-- INSERT INTO IdTest VALUES
--     (1),
--     (2),
--     (3),
--     (4),
--     (5);

-- CREATE TABLE Newsletter (id INT IDENTITY(1,1) PRIMARY KEY, email VARCHAR(70), name VARCHAR(100));

-- CREATE TABLE Newsletter (email VARCHAR(70) PRIMARY KEY, name VARCHAR(100));

-- CREATE TABLE Newsletter (id INT IDENTITY(1,1) PRIMARY KEY, email VARCHAR(70) UNIQUE, name VARCHAR(100));














CREATE TABLE players
(
    player_id INT IDENTITY(1,1) PRIMARY KEY,
    player_name CHAR(3)
);
GO

CREATE TABLE highscores
(
    highscore_id INT IDENTITY(1,1) PRIMARY KEY,
    player_id INT FOREIGN KEY REFERENCES players(player_id),
    [date] DATETIME2,
    difficulty TINYINT,
    score INT
);
GO

INSERT INTO players
VALUES
    ('SQL'),
    ('HRM'),
    ('SGN');
GO

INSERT INTO highscores
VALUES
    (1, '2019-02-13 12:00:00', 1, 10001),
    (1, SYSDATETIME(), 2, 99),
    (2, SYSDATETIME(), 3, 99999),
    (3, SYSDATETIME(), 1, 12);
GO

SELECT p.player_name, h.[date], h.difficulty, h.score
FROM highscores AS h
    JOIN players AS p
    ON p.player_id = h.player_id
ORDER BY h.score DESC, h.[date] ASC;

-- namn, poäng   (senaste spelomgång)
SELECT TOP(1) p.player_name, h.score, h.[date]
FROM highscores AS h
    JOIN players AS p
    ON p.player_id = h.player_id
WHERE p.player_id = 1
ORDER BY h.[date] DESC;

SELECT player_id, MIN([date]) AS min_score FROM highscores WHERE player_id = 1 GROUP BY player_id;