EXEC dbo.[Sales by Year] '1996-01-01', '1997-12-31';

SELECT  CAST('2000-01-01' AS DATE)

USE Northwind;
GO
CREATE PROCEDURE dbo.stockWithPriceLessThan
    @Price AS MONEY
AS
    SET NOCOUNT ON
    SELECT ProductID, ProductName, UnitPrice 
    FROM Products 
    WHERE UnitPrice < @Price AND UnitsInStock > 0;
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
    SET NOCOUNT ON
    SELECT TOP(1) @HighestID = ProductID, @HighestPrice = UnitPrice 
    FROM Products 
    WHERE UnitPrice < @Price AND UnitsInStock > 0
    ORDER BY UnitPrice DESC;
GO

DECLARE @HP AS MONEY
DECLARE @HID AS INT
EXEC dbo.highestPriceLessThan 2, @HighestPrice = @HP OUTPUT, @HighestID = @HID OUTPUT;
SELECT @HID, @HP;
GO




CREATE PROCEDURE dbo.increasePrice
    @ProductID INT
AS
DECLARE
    @UnitPrice INT,
    @ProductName NVARCHAR(40)
BEGIN
    SELECT @UnitPrice = UnitPrice , @ProductName = ProductName
    FROM Products
    WHERE ProductID = @ProductID
 
    PRINT 'Current UnitPrice is : ' +  CAST(@UnitPrice AS VARCHAR) + ' (' + @ProductName + ')'
 
    IF @UnitPrice >= 50
        BEGIN
            PRINT 'Greater than or equal 50'
            UPDATE Products SET UnitPrice = UnitPrice * 1.1 WHERE ProductID = @ProductID
        END
    ELSE
        BEGIN
            PRINT 'Less than 50'
            UPDATE Products SET UnitPrice = UnitPrice * 1.03 WHERE ProductID = @ProductID
        END

    -- Print new price
    SELECT @UnitPrice = UnitPrice , @ProductName = productName
        FROM products
        WHERE productID = @ProductID
    PRINT 'Current unitPrice is : ' +  CAST(@UnitPrice AS VARCHAR) + ' (' + @ProductName + ')'
END
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


SELECT ROUND(CAST(1212.1223 AS MONEY), 2)
