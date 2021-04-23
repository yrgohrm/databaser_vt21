CREATE DATABASE test_db;
GO

-- USE test_db;
-- GO

CREATE TABLE accounts
(
    id INT PRIMARY KEY,
    balance MONEY NOT NULL
);
GO

INSERT INTO accounts
VALUES
    (1, 10000.00),
    (2, 10000.00);
GO

SELECT *
FROM accounts;
GO


UPDATE accounts SET balance = balance - 5000 WHERE id = 2 AND balance >= 5000;

--- CRASCH!!!!! BOOM BANG!

IF @@ROWCOUNT = 1
    UPDATE accounts SET balance = balance + 5000 WHERE id = 1;






-- UPDATE accounts SET balance = 10000 WHERE id = 1;

BEGIN TRANSACTION;
BEGIN TRY
    UPDATE accounts SET balance = balance - 5000 WHERE id = 1 AND balance >= 5000;
    IF @@ROWCOUNT < 1
        THROW 50000, 'Updaterade inte', 0;
        
    UPDATE accounts SET balance = balance + 5000 WHERE id = 2;
    IF @@ROWCOUNT < 1
        THROW 50000, 'Updaterade inte', 0;
    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
END CATCH

BEGIN TRANSACTION;
UPDATE accounts SET balance = balance + 5000 WHERE id = 2;
UPDATE accounts SET balance = balance - 5000 WHERE id = 1 AND balance >= 5000;
IF @@ROWCOUNT < 1
    ROLLBACK;
ELSE
    COMMIT;


-- difference with xact_abort on/off
USE pubs;

DELETE FROM authors WHERE au_id = '999-99-9999';

SET XACT_ABORT ON;
BEGIN TRAN;
    INSERT INTO authors VALUES ('999-99-9999', 'Bosse', 'Nilsson', '555 555-5555', 'Hemadressen 2', 'Staden', 'CA', '90210', 0);
    INSERT INTO pub_info VALUES ('9999', NULL, 'Sample text');
COMMIT TRAN;

SELECT * FROM authors WHERE au_id = '999-99-9999';


-- För transaktioner

-- USE [dbTest];
-- GO

-- CREATE TABLE tblOne (id INT IDENTITY(1,1) PRIMARY KEY, val INT);
-- CREATE TABLE tblTwo (id INT IDENTITY(1,1) PRIMARY KEY, val INT);
-- GO


-- INSERT INTO tblOne (val) VALUES (1), (2), (3), (4);
-- INSERT INTO tblTwo (val) VALUES (1), (2), (3), (4);

-- -- Deadlock, do with sqlcmd

-- -- 1. In both windows:
-- USE [dbTest];
-- GO

-- -- We only get this deadlock with the following levels:
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- -- 2. In window 1:
-- BEGIN TRAN;
-- UPDATE tblOne SET val = 99 WHERE id = 1;
-- GO

-- -- 3. In window 2:
-- BEGIN TRAN;
-- UPDATE tblTwo SET val = 99 WHERE id = 1;
-- SELECT val FROM tblOne WHERE id = 1;
-- COMMIT TRAN;
-- GO

-- -- 4. In window 1
-- SELECT val FROM tblTwo WHERE id = 1;
-- COMMIT TRAN;
-- GO
