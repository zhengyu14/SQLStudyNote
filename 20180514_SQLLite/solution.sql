.header on
.mode column

-- solution for question 1
.width 20, 10
SELECT
  B.bookTitle AS Title,
  CASE
    WHEN CI.transactionTypeID IS NULL THEN 0
    ELSE SUM(CI.newQuantity)
    END Stock
FROM Book AS B
LEFT JOIN
(SELECT
  I.bookCode, I.transactionTypeID,
  CASE I.transactionTypeID
    WHEN 2 THEN I.quantity
    ELSE I.quantity * (-1)
  END AS newQuantity
FROM Inventory AS I) AS CI
ON B.bookCode = CI.bookCode
GROUP BY B.bookTitle;

-- solution for question 2
.width 10, 10, 10
SELECT
  CASE S.roleID
    WHEN 1 THEN 'Manager'
    ELSE 'Non-Manager'
  END AS Type,
  '$' || CAST(SUM(S.salary) AS INTEGER) AS Salary,
  ROUND((SUM(S.salary)/NS.TotalSalary * 100), 2) || '%' AS Percentage
FROM StaffAssignment AS S
INNER JOIN
(SELECT SUM(salary) AS TotalSalary FROM StaffAssignment) AS NS
GROUP BY Type;
