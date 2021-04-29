EXEC sp_helptext 'sp_helptext';
GO



EXEC dbo.[Sales by Year] '1996-01-01', '1997-12-31';

USE Northwind;
GO

CREATE PROCEDURE dbo.stockWithPriceLessThan
    @Price AS MONEY
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ProductID, ProductName, UnitPrice 
    FROM Products 
    WHERE UnitPrice < @Price AND UnitsInStock > 0;
END
GO

EXEC dbo.stockWithPriceLessThan 20.0;
EXEC dbo.stockWithPriceLessThan 5.0;

DROP PROCEDURE dbo.stockWithPriceLessThan;
DROP PROCEDURE dbo.highestPriceLessThan;

GO

CREATE PROCEDURE dbo.highestPriceLessThan
    @Price AS MONEY,
    @HighestPrice AS MONEY OUTPUT,
    @HighestID AS INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP(1) @HighestID = ProductID, @HighestPrice = UnitPrice 
    FROM Products 
    WHERE UnitPrice < @Price AND UnitsInStock > 0
    ORDER BY UnitPrice DESC;
END
GO

DECLARE @HP AS MONEY
DECLARE @HID AS INT

EXEC dbo.highestPriceLessThan @Price = 5, @HighestPrice = @HP OUTPUT, @HighestID = @HID OUTPUT;

SELECT @HID, @HP;
GO

CREATE PROCEDURE dbo.increasePrice
    @ProductID INT
AS
    DECLARE @UnitPrice MONEY
    SELECT @UnitPrice = UnitPrice
    FROM Products
    WHERE ProductID = @ProductID

    IF @UnitPrice < 50
        UPDATE Products 
        SET UnitPrice = ROUND(UnitPrice * 1.1, 1, 1)
        WHERE ProductID = @ProductID;
    ELSE
        UPDATE Products 
        SET UnitPrice = ROUND(UnitPrice * 1.03, 1, 1)
        WHERE ProductID = @ProductID;
GO

EXEC dbo.increasePrice 9;
GO


EXEC sp_helptext 'sp_addrole';
GO

CREATE PROCEDURE SaveTranExample2
AS  
    IF @@TRANCOUNT > 0  
        THROW 50000, 'Already in transaction', 0;
    
    -- YOUR TRANSACTION HERE
GO

ALTER PROCEDURE dbo.adjustCheapestProduct
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UnitsInStock AS SMALLINT;
    DECLARE @ProductID AS INT;
    DECLARE @UnitPrice AS MONEY;
    
    SELECT TOP(1) 
        @ProductID = ProductID,
        @UnitsInStock = UnitsInStock,
        @UnitPrice = UnitPrice
    FROM Products 
    ORDER BY UnitPrice ASC;

    IF @UnitsInStock > 100 AND @UnitPrice * 0.7 < 1
    BEGIN
        UPDATE Products 
        SET UnitPrice = 1
        OUTPUT inserted.UnitPrice
        WHERE ProductID = @ProductID
    END
    ELSE IF @UnitsInStock > 100
    BEGIN
        UPDATE Products 
        SET UnitPrice = ROUND(UnitPrice * 0.7, 1, 1)
        OUTPUT inserted.UnitPrice
        WHERE ProductID = @ProductID
    END
    ELSE IF @UnitsInStock < 30
    BEGIN
        UPDATE Products 
        SET UnitPrice = ROUND(UnitPrice * 1.3, 1, 1)
        OUTPUT inserted.UnitPrice
        WHERE ProductID = @ProductID
    END
END
GO

SELECT TOP(1) * FROM Products ORDER BY UnitPrice ASC;

EXEC dbo.adjustCheapestProduct;
GO








ALTER PROCEDURE dbo.adjustCheapestProduct
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Id INT
    DECLARE @UnitsInStock SMALLINT
    DECLARE @UnitPrice MONEY
    
    SELECT TOP(1) @Id = ProductID, 
        @UnitsInStock = UnitsInStock, 
        @UnitPrice = UnitPrice 
    FROM Products 
    WHERE UnitsInStock > 0 ORDER BY UnitPrice ASC;

    IF @UnitsInStock > 100 AND @UnitPrice * 0.7 < 1
        UPDATE Products SET UnitPrice = 1.0 WHERE ProductID = @Id
    ELSE IF @UnitsInStock > 100
        UPDATE Products SET UnitPrice = UnitPrice * 0.7 WHERE ProductID = @Id;
    ELSE IF @UnitsInStock < 30
        UPDATE Products SET UnitPrice = UnitPrice * 1.3 WHERE ProductID = @Id;
END
GO