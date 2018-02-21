-- -- Query1
SELECT P.ProductName AS ProductName,AVG(O.Discount) AS AverageDiscount
  FROM Product AS P
  LEFT JOIN OrderItems AS O
  ON P.ProductId = O.ProductId
  GROUP BY P.ProductName
  ORDER BY AverageDiscount DESC;

-- -- Query2
SELECT C.PhoneNo AS PhoneNo,COUNT(C.CustomerId) AS CountOfCustomers
  FROM Customer AS C
  WHERE COUNT(C.CustomerId) > 1
  ORDER BY CountOfCustomers DESC;

-- -- Query3
SELECT I.ProductId AS ProductId, P.ProductName AS ProductName, S.FirstName AS FirstName, S.LastName AS LastName
  FROM Inventory AS I
  LEFT JOIN Product AS P
  ON I.ProductId = P.ProductId
  LEFT JOIN Supplier AS S
  ON I.SupplierId = S.SupplierId
  WHERE I.TotalStock = 0
  ORDER BY ProductId ASC;

-- -- Query4
SELECT OC.CustomerId AS CustomerId, OC.LastName AS LastName, AVG(OI.Discount)
  FROM OrderItems AS OI
  LEFT JOIN (
    SELECT O.OrderId AS OrderId, O.CustomerId AS CustomerId, C.LastName AS LastName
      FROM Orders AS O
      LEFT JOIN Customer AS C
      ON O.CustomerId = C.CustomerId
  ) AS OC
  ORDER BY CustomerId ASC;

-- -- Query5
SELECT P.ProductName AS ProductName, SUM(O.Quantity) AS NumberOfItemsSold
  FROM OrderItems AS O
  LEFT JOIN Product AS P
  ON O.ProductId = P.ProductId
  GROUP BY ProductName
  ORDER BY CustomerId DESC
  WHERE ROWNUM <= 3;

-- -- Query6
SELECT DISTINCT C.FirstName AS FirstName, C.LastName AS LastName, C.PhoneNo AS PhoneNo
  FROM Customer AS C
  INNER JOIN Orders AS O
  ON C.CustomerId = O.CustomerId AND O.Status = 'delayed'
  ORDER BY C.FirstName ASC;

-- -- Query7
SELECT *
  FROM (
    SELECT O.CustomerId AS CustomerId, SUM(OI.Quantity * OI.UnitPrice * (100 - OI.Discount) / 100) AS Revenue
      FROM Orders AS O
      INNER JOIN OrderItems AS OI
      ON O.OrderId = OI.OrderId
      GROUP BY O.CustomerId
      ORDER BY Revenue DESC
  )
  WHERE ROWNUM <= 4;

-- -- Query8
SELECT OIP.Category AS Category, COUNT(O.CustomerId) AS DistinctNumberOfCustomers
  FROM Orders AS O
  LEFT JOIN (
    SELECT OI.OrderId AS OrderId, P.Category AS Category
      FROM OrderItems AS OI
      LEFT JOIN Product AS P
      ON OI.ProductId = P.ProductId
  ) AS OIP
  ON O.OrderId = OIP.OrderId
  WHERE ROWNUM <= 3
  GROUP BY Category
  ORDER BY DistinctNumberOfCustomers DESC;

-- -- Query9
SELECT C.FirstName AS FirstName, C.LastName AS LastName, O.OrderId AS OrderId, OI.Quantity * OI.UnitPrice * (100 - OI.Discount) / 100 AS TotalAmount
  FROM Orders AS O
  INNER JOIN OrderItems AS OI
  ON O.OrderId = OI.OrderId AND O.Status = 'delayed'
  INNER JOIN Customer C
  ON O.CustomerId = C.CustomerId
  WHERE OI.Quantity * OI.UnitPrice * (100 - OI.Discount) / 100 > 1000
  ORDER BY TotalAmount DESC;

-- -- Query10
SELECT S.SupplierId AS SupplierId, S.LastName AS LastName, SD.NumberOfDifferentProducts AS NumberOfDifferentProducts
  FROM Supplier S
  INNER JOIN (
    SELECT S.SupplierId, COUNT(*) AS NumberOfDifferentProducts
    FROM Supplier AS S
    INNER JOIN Product AS P
    ON S.SupplierId = P.SupplierId
    GROUP BY S.SupplierId
    HAVING COUNT(*) > 3
  ) AS SD
  ON S.SupplierId = SD.SupplierId
  ORDER BY SD.NumberOfDifferentProducts DESC;
