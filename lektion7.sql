USE master;

DROP DATABASE IF EXISTS PermTest;
GO

DROP LOGIN TestUser;
GO

CREATE DATABASE PermTest;
GO

USE PermTest;
GO

CREATE TABLE test_table (id INT, val INT);
GO

CREATE LOGIN TestUser
WITH PASSWORD = 'someP4ssword', CHECK_EXPIRATION = OFF;
GO

CREATE USER TestUser FOR LOGIN TestUser WITH DEFAULT_SCHEMA = dbo;
GO

CREATE ROLE test_role;
GO

ALTER ROLE test_role ADD MEMBER TestUser;
GO

GRANT SELECT ON SCHEMA :: dbo TO test_role;
GO

GRANT INSERT ON OBJECT :: dbo.test_table TO test_role;
GO

CREATE LOGIN TestUser2 WITH PASSWORD = 'someP4assword';
GO

CREATE USER TestUser2 FOR LOGIN TestUser2;
GO

ALTER ROLE test_role ADD MEMBER TestUser2;
GO

REVOKE INSERT ON OBJECT :: dbo.test_table TO test_role;
GO

CREATE SCHEMA test;
GO

CREATE VIEW test.small_numbers
AS
    SELECT id, val FROM dbo.test_table WHERE id < 500;
GO

SELECT * FROM test.small_numbers;

REVOKE SELECT ON SCHEMA :: dbo TO test_role;
GRANT SELECT ON SCHEMA :: test TO test_role;
GO

CREATE PROCEDURE test.doSomeStuff
AS
BEGIN
    INSERT INTO dbo.test_table VALUES (RAND()*1000, RAND()*555);
END
GO

GRANT EXECUTE ON SCHEMA :: test TO test_role;
GO

REVOKE EXECUTE ON SCHEMA :: test FROM test_role;
GRANT EXECUTE ON OBJECT :: test.doSomeStuff TO test_role;

DENY INSERT ON OBJECT :: test.small_numbers TO test_role;
