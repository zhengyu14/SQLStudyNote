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

-- solution for question 3
.width 10, 50
SELECT
BBP.Grade,
GROUP_CONCAT(BBP.bookTitle || '(' || STRFTIME('%Y',W.pubDate) || ')') AS Books
FROM
(SELECT DISTINCT
  CASE
    WHEN BP.price >= 150 AND BP.price <= 1999.99 THEN 'Very High'
    WHEN BP.price >= 100 AND BP.price <= 149.99 THEN 'High'
    WHEN BP.price >= 50 AND BP.price <= 99.99 THEN 'Medium'
    WHEN BP.price >= 25 AND BP.price <= 49.99 THEN 'Low'
    WHEN BP.price >= 0 AND BP.price <= 24.99 THEN 'Very Low'
  END AS Grade,
  BP.bookCode, B.bookTitle, MAX(BP.endDate)
FROM BookPrice AS BP
INNER JOIN Book AS B
ON BP.bookCode = B.bookCode
GROUP BY BP.bookCode) as BBP
INNER JOIN Writing AS W
ON BBP.bookCode = W.bookCode
GROUP BY BBP.Grade;

-- solution for question 4
.width 10, 10, 30
CREATE VIEW StaffStatus AS
SELECT SSA.staffFirstName AS Staff, SSA.Status, SSA.Years || ' Year(s) ' || SSA.Months || ' Month(s)' AS Duration
FROM
(SELECT S.staffFirstName,
  CASE
    WHEN SA.endDate >= DATE('NOW') AND SA.startDate <= DATE('NOW')
      THEN 'Active'
    WHEN SA.endDate IS NULL AND SA.startDate <= DATE('NOW')
      THEN 'Active'
    ELSE 'Inactive'
  END AS Status,
  CASE
    WHEN SA.endDate >= DATE('NOW') AND SA.startDate <= DATE('NOW')
      THEN CAST(((JULIANDAY(DATE('NOW')) - JULIANDAY(SA.startDate)) / 365.25) AS INTEGER)
    WHEN SA.endDate IS NULL AND SA.startDate <= DATE('NOW')
      THEN CAST(((JULIANDAY(DATE('NOW')) - JULIANDAY(SA.startDate)) / 365.25) AS INTEGER)
    ELSE CAST(((JULIANDAY(SA.endDate) - JULIANDAY(SA.startDate)) / 365.25) AS INTEGER)
  END AS Years,
  CASE
    WHEN SA.endDate >= DATE('NOW') AND SA.startDate <= DATE('NOW')
      THEN CAST(((JULIANDAY(DATE('NOW')) - JULIANDAY(SA.startDate)) % 365.25 / 30.44) AS INTEGER)
    WHEN SA.endDate IS NULL AND SA.startDate <= DATE('NOW')
      THEN CAST(((JULIANDAY(DATE('NOW')) - JULIANDAY(SA.startDate)) % 365.25 / 30.44) AS INTEGER)
    ELSE CAST(((JULIANDAY(SA.endDate) - JULIANDAY(SA.startDate)) % 365.25 / 30.44) AS INTEGER)
  END AS Months
FROM Staff AS S
LEFT JOIN StaffAssignment AS SA
ON S.staffCode = SA.staffCode) AS SSA
ORDER BY SSA.Status ASC, SSA.Years DESC, SSA.Months DESC;
