-- -- Query1
SELECT P.ProductName, ROUND(AVG(NVL(O.Discount, 0)), 2) AS AverageDiscount
  FROM Product P
  LEFT JOIN OrderItems O
  ON P.ProductId = O.ProductId
  GROUP BY P.ProductName
  ORDER BY AverageDiscount DESC;

-- -- Query2
SELECT C.PhoneNo,COUNT(C.CustomerId) AS CountOfCustomers
  FROM Customer C
  GROUP BY C.Phoneno
  HAVING COUNT (C.Customerid) > 1
  ORDER BY CountOfCustomers DESC;


-- -- Query3
SELECT I.ProductId, P.ProductName, S.FirstName, S.LastName
  FROM Inventory I
  LEFT JOIN Product P
  ON I.ProductId = P.ProductId
  LEFT JOIN Supplier S
  ON P.SupplierId = S.SupplierId
  WHERE I.TotalStock = 0
  ORDER BY ProductId ASC;

-- -- Query4
SELECT C.CustomerId, C.LastName, AVG(OI.Discount)
  FROM Orders O
 INNER JOIN OrderItems OI
    ON O.OrderId = OI.OrderId
 INNER JOIN Customer C
    ON O.CustomerId = C.CustomerId
 GROUP BY C.CustomerId, C.LastName
 ORDER BY C.CustomerId;


-- -- Query5
SELECT * FROM (
SELECT P.ProductName AS ProductName, SUM(O.Quantity) AS NumberOfItemsSold
  FROM OrderItems O
  INNER JOIN Product P
  ON O.ProductId = P.ProductId
  GROUP BY ProductName
  ORDER BY NumberOfItemsSold DESC)
WHERE ROWNUM <= 3;
  

-- -- Query6
SELECT DISTINCT C.FirstName AS FirstName, C.LastName AS LastName, C.PhoneNo AS PhoneNo
  FROM Customer C
  INNER JOIN Orders O
  ON C.CustomerId = O.CustomerId AND O.Status = 'delayed'
  ORDER BY C.FirstName ASC;

-- -- Query7
SELECT *
  FROM (
    SELECT O.CustomerId AS CustomerId, SUM(OI.Quantity * OI.UnitPrice * (100 - OI.Discount) / 100) AS Revenue
      FROM Orders O
      INNER JOIN OrderItems OI
      ON O.OrderId = OI.OrderId
      GROUP BY O.CustomerId
      ORDER BY Revenue DESC
  )
  WHERE ROWNUM <= 4;

-- -- Query8
SELECT OIP.Category AS Category, COUNT(O.CustomerId) AS DistinctNumberOfCustomers
  FROM Orders O
  LEFT JOIN (
    SELECT OI.OrderId AS OrderId, P.Category AS Category
      FROM OrderItems OI
      LEFT JOIN Product P
      ON OI.ProductId = P.ProductId
  ) OIP
  ON O.OrderId = OIP.OrderId
  WHERE ROWNUM <= 3
  GROUP BY Category
  ORDER BY DistinctNumberOfCustomers DESC;

-- -- Query9
SELECT C.FirstName AS FirstName, C.LastName AS LastName, O.OrderId AS OrderId, OI.Quantity * OI.UnitPrice * (100 - OI.Discount) / 100 AS TotalAmount
  FROM Orders O
  INNER JOIN OrderItems OI
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
    FROM Supplier S
    INNER JOIN Product P
    ON S.SupplierId = P.SupplierId
    GROUP BY S.SupplierId
    HAVING COUNT(*) > 3
  ) SD
  ON S.SupplierId = SD.SupplierId
  ORDER BY SD.NumberOfDifferentProducts DESC;
