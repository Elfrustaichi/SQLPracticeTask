USE HomeworkDB

SELECT Products.*,Categories.Name,(SELECT COUNT(*) FROM Orders WHERE Orders.ProductId=Products.Id) AS OrderCount FROM Products
JOIN Categories ON Products.CategoryId=Categories.Id

SELECT Orders.*,(SELECT (SUM(SalePrice)*Orders.Count) FROM Products WHERE Orders.Id=Products.Id) FROM Orders

CREATE PROCEDURE USP_SaleProfitCalc
@OrderId INT
AS
SELECT (SELECT (SUM(SalePrice-CostPrice)*Orders.Count) FROM Products WHERE Orders.Id=Products.Id) AS OrderProfit FROM Orders
WHERE @OrderId=Orders.Id

EXEC USP_SaleProfitCalc 1

CREATE VIEW VW_AllProductsInfo
AS
SELECT Products.*,Categories.Name AS CategoryName,(SalePrice-CostPrice) AS ProductProfit FROM Products
JOIN Categories ON Products.CategoryId=Categories.Id

SELECT * FROM VW_AllProductsInfo

CREATE PROCEDURE USP_OrderTime
@FirstDate DATETIME2,@SecondDate DATETIME2
AS
SELECT Orders.*,Orders.Count*Products.SalePrice AS TotalValue FROM Orders
JOIN Products ON Orders.ProductId=Products.Id
WHERE CreatedAt BETWEEN @FirstDate AND @SecondDate

EXEC USP_OrderTime 	'2019-11-11','2020-11-11'


SELECT * FROM Products

SELECT * FROM Categories

SELECT * FROM Orders