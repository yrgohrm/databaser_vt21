USE [Northwind];
GO

SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.Alphabetical list of products'))
GO

EXEC sp_helptext 'dbo.Alphabetical list of products'
GO

SELECT ProductName 
FROM dbo.[Alphabetical list of products]
WHERE CategoryID = 8
ORDER BY ProductName ASC;
GO

CREATE VIEW dbo.EmployeeAndTerritories
AS
    SELECT e.EmployeeID, e.FirstName, e.LastName, t.TerritoryID, t.TerritoryDescription
    FROM Employees AS e
        JOIN EmployeeTerritories AS et
        ON e.EmployeeID = et.EmployeeID
        JOIN Territories AS t
        ON t.TerritoryID = et.TerritoryID;
GO

SELECT * FROM dbo.EmployeeAndTerritories WHERE EmployeeID = 2;
GO

UPDATE EmployeeAndTerritories SET FirstName = 'Andreeew' WHERE TerritoryID = '01581';
GO

SELECT * FROM Employees WHERE EmployeeID = 2;
GO

-- Otillåten vy
CREATE VIEW dbo.EmployeeNames
AS
    SELECT FirstName, LastName 
    FROM Employees
    ORDER BY LastName;
GO

-- Krypterad Vy
CREATE VIEW dbo.EncEmployeeNames
    WITH ENCRYPTION
AS
    SELECT FirstName, LastName 
    FROM Employees;
GO

SELECT * FROM dbo.EncEmployeeNames;
GO

SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.EncEmployeeNames'))
GO

EXEC sp_helptext 'dbo.EncEmployeeNames'
GO

-- schema binding
DROP VIEW dbo.SbEmployeeNames;
GO

CREATE VIEW dbo.SbEmployeeNames
   -- WITH SCHEMABINDING
AS
    SELECT FirstName, LastName 
    FROM dbo.Employees;
GO

DROP INDEX Employees.LastName;

SELECT * FROM dbo.SbEmployeeNames;
GO

ALTER TABLE Employees DROP COLUMN LastName;
GO

-- check option
CREATE VIEW dbo.CoEmployeeNames
AS
    SELECT FirstName
    FROM Employees
    WHERE FirstName LIKE 'M%'
    WITH CHECK OPTION;
GO

SELECT * FROM dbo.CoEmployeeNames;
GO

INSERT INTO CoEmployeeNames VALUES ('Nisse');
GO

INSERT INTO CoEmployeeNames VALUES ('Misse');
GO

-- partitioned views

CREATE TABLE ForumPosts2018
(
    post_id INT IDENTITY(1,1),
    created DATE CHECK (YEAR(created) = 2018),
    body VARCHAR(MAX),
    PRIMARY KEY (post_id, created)
)
GO

CREATE TABLE ForumPosts2019
(
    post_id INT IDENTITY(1,1),
    created DATE CHECK (YEAR(created) = 2019),
    body VARCHAR(MAX),
    PRIMARY KEY (post_id, created)
)
GO

INSERT INTO ForumPosts2018
VALUES
    ('2018-09-22', 'Hejsan hoppsan!'),
    ('2018-12-22', 'Frist!');

INSERT INTO ForumPosts2019
VALUES
    ('2019-02-12', 'Ojsan!'),
    ('2019-01-21', 'Hoppelihopp!');

GO

CREATE VIEW dbo.ForumPosts
AS
        SELECT *
        FROM ForumPosts2018
    UNION ALL
        SELECT *
        FROM ForumPosts2019;
GO

SELECT *
FROM ForumPosts;

SELECT created, body
FROM ForumPosts
WHERE body LIKE 'H%';
