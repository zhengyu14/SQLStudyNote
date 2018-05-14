.header on
.mode column

-- solution for question 1
.width 20, 10
SELECT
  B.bookTitle AS Title,
  CASE
    WHEN CI.transactionTypeID IS NULL THEN 0
    ELSE sum(CI.newQuantity)
    END Stock
FROM Book AS B
LEFT JOIN
(SELECT
  I.bookCode, I.transactionTypeID,
  CASE I.transactionTypeID
    WHEN 2 THEN I.quantity
    WHEN 1 THEN I.quantity * (-1)
    ELSE 0
  END AS newQuantity
FROM Inventory AS I) AS CI
ON B.bookCode = CI.bookCode
GROUP BY B.bookTitle;

-- solution for question 2
