USE FinancialCrimeDB;
GO

--(Remove Old Table)
--DROP TABLE → Existing table-ah completely remove pannum.
--IF EXISTS → Table already irundha mattum remove pannum. Illana error avoid pannum.

CREATE TABLE Transactions
(
    TransactionID INT PRIMARY KEY,
    Time FLOAT NOT NULL,

    V1 FLOAT,
    V2 FLOAT,
    V3 FLOAT,
    V4 FLOAT,
    V5 FLOAT,
    V6 FLOAT,
    V7 FLOAT,
    V8 FLOAT,
    V9 FLOAT,
    V10 FLOAT,
    V11 FLOAT,
    V12 FLOAT,
    V13 FLOAT,
    V14 FLOAT,
    V15 FLOAT,
    V16 FLOAT,
    V17 FLOAT,
    V18 FLOAT,
    V19 FLOAT,
    V20 FLOAT,
    V21 FLOAT,
    V22 FLOAT,
    V23 FLOAT,
    V24 FLOAT,
    V25 FLOAT,
    V26 FLOAT,
    V27 FLOAT,
    V28 FLOAT,

    Amount DECIMAL(10,2) NOT NULL,
    Class INT NOT NULL
);
GO

--(Create transactional table)

CREATE TABLE Transactions
(
    TransactionID INT PRIMARY KEY,
    Time FLOAT NOT NULL,

    V1 FLOAT,
    V2 FLOAT,
    V3 FLOAT,
    V4 FLOAT,
    V5 FLOAT,
    V6 FLOAT,
    V7 FLOAT,
    V8 FLOAT,
    V9 FLOAT,
    V10 FLOAT,
    V11 FLOAT,
    V12 FLOAT,
    V13 FLOAT,
    V14 FLOAT,
    V15 FLOAT,
    V16 FLOAT,
    V17 FLOAT,
    V18 FLOAT,
    V19 FLOAT,
    V20 FLOAT,
    V21 FLOAT,
    V22 FLOAT,
    V23 FLOAT,
    V24 FLOAT,
    V25 FLOAT,
    V26 FLOAT,
    V27 FLOAT,
    V28 FLOAT,

    Amount DECIMAL(10,2) NOT NULL,
    Class INT NOT NULL
);
GO

-- Check Total Number of Rows
SELECT COUNT(*) AS TotalRows
FROM Transactions;

-- Check Minimum and Maximum Transaction ID
SELECT
    MIN(TransactionID) AS MinID,
    MAX(TransactionID) AS MaxID
FROM Transactions;


-- Check First 25 Transaction IDs
SELECT TOP 25 TransactionID
FROM Transactions
ORDER BY TransactionID;


-- Check Fraud and Legitimate Transactions
SELECT
    Class,
    COUNT(*) AS TransactionCount
FROM Transactions
GROUP BY Class
ORDER BY Class;


-- Check Duplicate Transaction IDs
SELECT
    TransactionID,
    COUNT(*) AS DuplicateCount
FROM Transactions
GROUP BY TransactionID
HAVING COUNT(*) > 1;


-- Check NULL Values
SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN TransactionID IS NULL THEN 1 ELSE 0 END) AS Null_TransactionID,
    SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS Null_Time,
    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS Null_Amount,
    SUM(CASE WHEN Class IS NULL THEN 1 ELSE 0 END) AS Null_Class
FROM Transactions;


-- Check Invalid Class Values
SELECT
    COUNT(*) AS InvalidClassCount
FROM Transactions
WHERE Class NOT IN (0, 1);


-- Check Unique Class Values
SELECT DISTINCT Class
FROM Transactions;


-- Check Negative Transaction Amounts
SELECT
    COUNT(*) AS NegativeAmountCount
FROM Transactions
WHERE Amount < 0;


-- Check Transaction Amount Statistics
SELECT
    MIN(Amount) AS MinimumAmount,
    MAX(Amount) AS MaximumAmount,
    AVG(Amount) AS AverageAmount
FROM Transactions;

--fraud percentage

SELECT
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS FraudTransactions,
    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudPercentage
FROM Transactions;

--Ippo fraud transactions and legitimate transactions amount-wise compare pannanum

SELECT
    Class,
    COUNT(*) AS TransactionCount,
    MIN(Amount) AS MinimumAmount,
    MAX(Amount) AS MaximumAmount,
    AVG(Amount) AS AverageAmount
FROM Transactions
GROUP BY Class
ORDER BY Class;

--Ippo fraud transactions entha amount range-la adhigama irukku nu analyze pannanum

SELECT
    CASE
        WHEN Amount < 50 THEN 'Below 50'
        WHEN Amount >= 50 AND Amount < 100 THEN '50 - 99.99'
        WHEN Amount >= 100 AND Amount < 500 THEN '100 - 499.99'
        WHEN Amount >= 500 AND Amount < 1000 THEN '500 - 999.99'
        ELSE '1000 and Above'
    END AS AmountRange,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN Amount < 50 THEN 'Below 50'
        WHEN Amount >= 50 AND Amount < 100 THEN '50 - 99.99'
        WHEN Amount >= 100 AND Amount < 500 THEN '100 - 499.99'
        WHEN Amount >= 500 AND Amount < 1000 THEN '500 - 999.99'
        ELSE '1000 and Above'
    END
ORDER BY FraudCount DESC;

--Identifies fraud transactions based on different amount ranges and counts them, Memory: Fraud → Amount Range → Count

 SELECT
    CASE
        WHEN Amount < 50 THEN 'Below 50'
        WHEN Amount >= 50 AND Amount < 100 THEN '50 - 99.99'
        WHEN Amount >= 100 AND Amount < 500 THEN '100 - 499.99'
        WHEN Amount >= 500 AND Amount < 1000 THEN '500 - 999.99'
        ELSE '1000 and Above'
    END AS AmountRange,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN Amount < 50 THEN 'Below 50'
        WHEN Amount >= 50 AND Amount < 100 THEN '50 - 99.99'
        WHEN Amount >= 100 AND Amount < 500 THEN '100 - 499.99'
        WHEN Amount >= 500 AND Amount < 1000 THEN '500 - 999.99'
        ELSE '1000 and Above'
    END
ORDER BY FraudCount DESC;

--Fraud transactions endha time range-la adhigama irukku nu identify pannum, Memory: Fraud → Time Range → Count

SELECT
    CASE
        WHEN Time < 21600 THEN '00:00 - 06:00'
        WHEN Time < 43200 THEN '06:00 - 12:00'
        WHEN Time < 64800 THEN '12:00 - 18:00'
        ELSE '18:00 - 24:00'
    END AS TimeRange,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN Time < 21600 THEN '00:00 - 06:00'
        WHEN Time < 43200 THEN '06:00 - 12:00'
        WHEN Time < 64800 THEN '12:00 - 18:00'
        ELSE '18:00 - 24:00'
    END
ORDER BY FraudCount DESC;
 
--Endha amount range-la fraud percentage adhigama irukku nu identify pannum, 100 - 499.99 range-la 2000 transactions irundhu, 20 fraud irundha → Fraud Percentage = 1%., Memory: Amount Range → Total → Fraud → Percentage

SELECT
    CASE
        WHEN Amount < 50 THEN 'Below 50'
        WHEN Amount < 100 THEN '50 - 99.99'
        WHEN Amount < 500 THEN '100 - 499.99'
        WHEN Amount < 1000 THEN '500 - 999.99'
        ELSE '1000 and Above'
    END AS AmountRange,
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS FraudTransactions,
    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudPercentage
FROM Transactions
GROUP BY
    CASE
        WHEN Amount < 50 THEN 'Below 50'
        WHEN Amount < 100 THEN '50 - 99.99'
        WHEN Amount < 500 THEN '100 - 499.99'
        WHEN Amount < 1000 THEN '500 - 999.99'
        ELSE '1000 and Above'
    END
ORDER BY FraudPercentage DESC;

-- Fraud Transactions by V1 Feature Range, Fraud transactions endha V1 range-la adhigama irukku nu identify pannum.Example: Below -2 range-la 150 fraud transactions irundha, that range has the highest fraud count.Memory: Fraud → V1 Range → Count

SELECT
    CASE
        WHEN V1 < -2 THEN 'Below -2'
        WHEN V1 < 0 THEN '-2 to -0.01'
        WHEN V1 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V1Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V1 < -2 THEN 'Below -2'
        WHEN V1 < 0 THEN '-2 to -0.01'
        WHEN V1 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

---- Top 10 Fraud Transactions by Amount, Highest amount irukkura top 10 fraud transactions-a identify pannum. Example: Amount 2125.87 irukkura fraud transaction top-la varum.Memory: Fraud → Top 10 → Highest Amount

SELECT TOP 10
    TransactionID,
    Amount,
    Time,
    Class
FROM Transactions
WHERE Class = 1
ORDER BY Amount DESC;


-- High-Value Fraud Transactions, ₹500-ku mela irukkura fraud transactions-a identify pannum. Example: Amount = 1000 and Class = 1 na, adhu high-value fraud transaction-ah display aagum. Memory: Fraud → Amount > 500 → Identify

SELECT
    TransactionID,
    Amount,
    Time,
    Class
FROM Transactions
WHERE Class = 1
  AND Amount > 500
ORDER BY Amount DESC;

-- Average Transaction Amount by Class, Fraud and legitimate transactions-la average amount evlo nu compare pannum. Example: Class = 0 average ₹88.29, Class = 1 average ₹122.21 na, fraud transactions average amount higher. Memory: Class → Count → Average Amount

SELECT
    Class,
    COUNT(*) AS TransactionCount,
    AVG(Amount) AS AverageAmount
FROM Transactions
GROUP BY Class
ORDER BY Class;

-- Fraud Transactions by V2 Feature Range, Fraud transactions endha V2 range-la adhigama irukku nu identify pannum. Example: V2 < -2 range-la 100 fraud transactions irundha, andha range fraud count 100 nu show aagum. Memory: Fraud → V2 Range → Count

SELECT
    CASE
        WHEN V2 < -2 THEN 'Below -2'
        WHEN V2 < 0 THEN '-2 to -0.01'
        WHEN V2 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V2Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V2 < -2 THEN 'Below -2'
        WHEN V2 < 0 THEN '-2 to -0.01'
        WHEN V2 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

-- Fraud Transactions by V3 Feature Range Fraud transactions endha V3 range-la adhigama irukku nu identify pannum. Example: V3 < -2 range-la 120 fraud transactions irundha, andha range count 120 nu show aagum. Memory: Fraud → V3 Range → Count

SELECT
    CASE
        WHEN V3 < -2 THEN 'Below -2'
        WHEN V3 < 0 THEN '-2 to -0.01'
        WHEN V3 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V3Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V3 < -2 THEN 'Below -2'
        WHEN V3 < 0 THEN '-2 to -0.01'
        WHEN V3 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

-- Fraud Transactions by V4 Feature Range , Fraud transactions endha V4 range-la adhigama irukku nu identify pannum. Example: V4 = -3 na, adhu Below -2 range-la count aagum. Memory: Fraud → V4 Range → Count

SELECT
    CASE
        WHEN V4 < -2 THEN 'Below -2'
        WHEN V4 < 0 THEN '-2 to -0.01'
        WHEN V4 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V4Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V4 < -2 THEN 'Below -2'
        WHEN V4 < 0 THEN '-2 to -0.01'
        WHEN V4 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

-- Fraud Transactions by V5 Feature Range (Fraud transactions endha V5 range-la adhigama irukku nu identify pannum. Example: V5 = -2.5 na Below -2 range-la count aagum. Memory: Fraud → V5 Range → Count

SELECT
    CASE
        WHEN V5 < -2 THEN 'Below -2'
        WHEN V5 < 0 THEN '-2 to -0.01'
        WHEN V5 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V5Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V5 < -2 THEN 'Below -2'
        WHEN V5 < 0 THEN '-2 to -0.01'
        WHEN V5 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

-- Fraud Transactions by V6 Feature Range (Fraud transactions endha V6 range-la adhigama irukku nu identify pannum. Example: V6 = 1.5 na 0 to 1.99 range-la count aagum.Memory: Fraud → V6 Range → Count)

SELECT
    CASE
        WHEN V6 < -2 THEN 'Below -2'
        WHEN V6 < 0 THEN '-2 to -0.01'
        WHEN V6 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V6Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V6 < -2 THEN 'Below -2'
        WHEN V6 < 0 THEN '-2 to -0.01'
        WHEN V6 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

-- Fraud Transactions by V7 Feature Range (Fraud transactions endha V7 range-la adhigama irukku nu identify pannum. Example: V7 = 2.5 na 2 and Above range-la count aagum. Memory: Fraud → V7 Range → Count

SELECT
    CASE
        WHEN V7 < -2 THEN 'Below -2'
        WHEN V7 < 0 THEN '-2 to -0.01'
        WHEN V7 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V7Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V7 < -2 THEN 'Below -2'
        WHEN V7 < 0 THEN '-2 to -0.01'
        WHEN V7 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

--  Fraud Transactions by V8 Feature Range, Fraud transactions endha V8 range-la adhigama irukku nu identify pannum. Example: V8 = -1.5 na -2 to -0.01 range-la count aagum. Memory: Fraud → V8 Range → Count

SELECT
    CASE
        WHEN V8 < -2 THEN 'Below -2'
        WHEN V8 < 0 THEN '-2 to -0.01'
        WHEN V8 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V8Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V8 < -2 THEN 'Below -2'
        WHEN V8 < 0 THEN '-2 to -0.01'
        WHEN V8 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

--  Fraud Transactions by V9 Feature Range, Fraud transactions endha V9 range-la adhigama irukku nu identify pannum. Example: V9 = 1.5 na 0 to 1.99 range-la count aagum. Memory: Fraud → V9 Range → Count

SELECT
    CASE
        WHEN V9 < -2 THEN 'Below -2'
        WHEN V9 < 0 THEN '-2 to -0.01'
        WHEN V9 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V9Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V9 < -2 THEN 'Below -2'
        WHEN V9 < 0 THEN '-2 to -0.01'
        WHEN V9 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

-- Fraud Transactions by V10 Feature Range , Fraud transactions endha V10 range-la adhigama irukku nu identify pannum.  Example: V10 = -1.5 na -2 to -0.01 range-la count aagum. Memory: Fraud → V10 Range → Count

SELECT
    CASE
        WHEN V10 < -2 THEN 'Below -2'
        WHEN V10 < 0 THEN '-2 to -0.01'
        WHEN V10 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V10Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V10 < -2 THEN 'Below -2'
        WHEN V10 < 0 THEN '-2 to -0.01'
        WHEN V10 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

-- Fraud Transactions by V11 Feature Range, Fraud transactions endha V11 range-la adhigama irukku nu identify pannum. Example: V11 = 1.5 na 0 to 1.99 range-la count aagum. Memory: Fraud → V11 Range → Count

SELECT
    CASE
        WHEN V11 < -2 THEN 'Below -2'
        WHEN V11 < 0 THEN '-2 to -0.01'
        WHEN V11 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V11Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V11 < -2 THEN 'Below -2'
        WHEN V11 < 0 THEN '-2 to -0.01'
        WHEN V11 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

-- Fraud Transactions by V12 Feature Range (Fraud transactions endha V12 range-la adhigama irukku nu identify pannum. Example: V12 = -2.5 na Below -2 range-la count aagum. )Memory: Fraud → V12 Range → Count

SELECT
    CASE
        WHEN V12 < -2 THEN 'Below -2'
        WHEN V12 < 0 THEN '-2 to -0.01'
        WHEN V12 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V12Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V12 < -2 THEN 'Below -2'
        WHEN V12 < 0 THEN '-2 to -0.01'
        WHEN V12 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

-- Fraud Transactions by V13 Feature Range, Fraud transactions endha V13 range-la adhigama irukku nu identify pannum. Example: V13 = 1.5 na 0 to 1.99 range-la count aagum. Memory: Fraud → V13 Range → Count

SELECT
    CASE
        WHEN V13 < -2 THEN 'Below -2'
        WHEN V13 < 0 THEN '-2 to -0.01'
        WHEN V13 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END AS V13Range,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN V13 < -2 THEN 'Below -2'
        WHEN V13 < 0 THEN '-2 to -0.01'
        WHEN V13 < 2 THEN '0 to 1.99'
        ELSE '2 and Above'
    END
ORDER BY FraudCount DESC;

--  Fraud vs Legitimate Transaction Count , Fraud and legitimate transactions evlo irukku nu compare pannum. Example: Fraud = 492, Legitimate = 284315. Memory: Class → Type → Count

SELECT
    CASE
        WHEN Class = 1 THEN 'Fraud'
        ELSE 'Legitimate'
    END AS TransactionType,
    COUNT(*) AS TransactionCount
FROM Transactions
GROUP BY Class
ORDER BY Class;

-- High-Value Fraud Transactions , ₹1000-ku mela irukkura high-value fraud transactions-a identify pannum. Example: Class = 1 and Amount = 1500 na, adhu result-la varum. Memory: Fraud → Amount > 1000 → Identify

SELECT
    TransactionID,
    Amount,
    Time,
    Class
FROM Transactions
WHERE Class = 1
  AND Amount > 1000
ORDER BY Amount DESC;

-- Classify Transactions by Risk Level , ransaction amount and fraud status base panni risk level classify pannum. Example: Class = 1 + Amount = 1500 → High Risk. Memory: Fraud + Amount → Risk Level

SELECT
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 'High Risk'
        WHEN Class = 1 AND Amount > 500 THEN 'Medium Risk'
        WHEN Class = 1 THEN 'Low Risk'
        ELSE 'Legitimate'
    END AS RiskLevel,
    COUNT(*) AS TransactionCount
FROM Transactions
GROUP BY
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 'High Risk'
        WHEN Class = 1 AND Amount > 500 THEN 'Medium Risk'
        WHEN Class = 1 THEN 'Low Risk'
        ELSE 'Legitimate'
    END
ORDER BY TransactionCount DESC;

-- Overall Fraud Summary , Overall transactions, fraud count, legitimate count, fraud percentage, average amount ellam orae summary-la show pannum. Example: Total = 284807, Fraud = 492, Legitimate = 284315, Fraud % = 0.17%. Memory: Total → Fraud → Legitimate → % → Average

SELECT
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS FraudTransactions,
    SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END) AS LegitimateTransactions,
    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudPercentage,
    CAST(AVG(Amount) AS DECIMAL(10,2)) AS AverageTransactionAmount
FROM Transactions;

-- Create Fraud Summary View , Fraud analysis summary-a reusable View-ah create pannum. Example: FraudSummaryView run panna total transactions, fraud count, legitimate count, fraud percentage ellam one row-la varum. Memory: Transactions → Summary → View

USE FinancialCrimeDB;
GO

-- Step 25: Create Fraud Summary View

CREATE OR ALTER VIEW FraudSummaryView
AS
SELECT
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS FraudTransactions,
    SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END) AS LegitimateTransactions,
    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(10,2)
    ) AS FraudPercentage,
    CAST(AVG(Amount) AS DECIMAL(10,2)) AS AverageTransactionAmount
FROM Transactions;
GO

-- Check the View

SELECT *
FROM FraudSummaryView;
GO
-- Calculate Risk Score , Fraud status and amount base panni each transaction-ku risk score assign pannum. Example: Class = 1 + Amount = 1500 → RiskScore = 100. Memory: Fraud + Amount → Risk Score

SELECT
    TransactionID,
    Amount,
    Class,
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 100
        WHEN Class = 1 AND Amount > 500 THEN 75
        WHEN Class = 1 THEN 50
        ELSE 0
    END AS RiskScore
FROM Transactions
ORDER BY RiskScore DESC;

-- Create Risk Score View , Risk score calculation-a reusable View-ah create pannum. Example: Class = 1 + Amount = 1500 → RiskScore = 100. Memory: Transactions → Risk Score → View
  
USE FinancialCrimeDB;
GO

CREATE OR ALTER VIEW RiskScoreView
AS
SELECT
    TransactionID,
    Amount,
    Class,
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 100
        WHEN Class = 1 AND Amount > 500 THEN 75
        WHEN Class = 1 THEN 50
        ELSE 0
    END AS RiskScore
FROM Transactions;
GO

SELECT *
FROM RiskScoreView
ORDER BY RiskScore DESC;
GO

-- Risk Level Summary , Transactions-la endha risk level-la evlo records irukku nu summarize pannum.Example: Amount > 1000 + Class = 1 → High Risk, Memory: Transaction → Risk Level → Count

SELECT
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 'High Risk'
        WHEN Class = 1 AND Amount > 500 THEN 'Medium Risk'
        WHEN Class = 1 THEN 'Low Risk'
        ELSE 'Legitimate'
    END AS RiskLevel,
    COUNT(*) AS TransactionCount
FROM Transactions
GROUP BY
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 'High Risk'
        WHEN Class = 1 AND Amount > 500 THEN 'Medium Risk'
        WHEN Class = 1 THEN 'Low Risk'
        ELSE 'Legitimate'
    END
ORDER BY TransactionCount DESC;

--  Top 10 Highest-Risk Transactions , Highest risk score irukkura top 10 fraud transactions-a identify pannum. Example: RiskScore = 100 and Amount = 1500 → top-la varum. Memory: Risk Score → Top 10 → Fraud

SELECT TOP 10
    TransactionID,
    Amount,
    Class,
    RiskScore
FROM RiskScoreView
WHERE RiskScore > 0
ORDER BY RiskScore DESC, Amount DESC;

-- Fraud Transactions by Amount Range , Fraud transactions endha amount range-la adhigama irukku nu summarize pannum. Example: Amount = 750 → 500 - 999.99 range-la count aagum. Memory: Fraud → Amount Range → Count

SELECT
    CASE
        WHEN Amount < 50 THEN 'Below 50'
        WHEN Amount < 100 THEN '50 - 99.99'
        WHEN Amount < 500 THEN '100 - 499.99'
        WHEN Amount < 1000 THEN '500 - 999.99'
        ELSE '1000 and Above'
    END AS AmountRange,
    COUNT(*) AS FraudCount
FROM Transactions
WHERE Class = 1
GROUP BY
    CASE
        WHEN Amount < 50 THEN 'Below 50'
        WHEN Amount < 100 THEN '50 - 99.99'
        WHEN Amount < 500 THEN '100 - 499.99'
        WHEN Amount < 1000 THEN '500 - 999.99'
        ELSE '1000 and Above'
    END
ORDER BY FraudCount DESC;

--  Fraud Summary by Risk Level , Each risk level-la evlo transactions and average amount irukku nu summarize pannum. Example: High Risk → 20 transactions → Average Amount ₹1,250 ,Memory: Risk Level → Count → Average Amount

SELECT
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 'High Risk'
        WHEN Class = 1 AND Amount > 500 THEN 'Medium Risk'
        WHEN Class = 1 THEN 'Low Risk'
        ELSE 'Legitimate'
    END AS RiskLevel,
    COUNT(*) AS TransactionCount,
    CAST(AVG(Amount) AS DECIMAL(10,2)) AS AverageAmount
FROM Transactions
GROUP BY
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 'High Risk'
        WHEN Class = 1 AND Amount > 500 THEN 'Medium Risk'
        WHEN Class = 1 THEN 'Low Risk'
        ELSE 'Legitimate'
    END
ORDER BY TransactionCount DESC;

-- Validate Risk Score View , RiskScoreView-la each risk score-ku evlo transactions irukku nu check pannum. Example: RiskScore = 100 → andha score-ku irukkura transactions count show aagum. Memory: Risk Score → Count → Validate

SELECT
    RiskScore,
    COUNT(*) AS TransactionCount
FROM RiskScoreView
GROUP BY RiskScore
ORDER BY RiskScore DESC;

--  Create Fraud Summary Stored Procedure , Fraud summary analysis-a reusable Stored Procedure-ah create panni execute pannum. Example: EXEC GetFraudSummary run panna total transactions, fraud count, legitimate count, fraud percentage, average amount varum. Memory: Create → Execute → Summary

CREATE OR ALTER PROCEDURE GetFraudSummary
AS
BEGIN

    SELECT
        COUNT(*) AS TotalTransactions,
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS FraudTransactions,
        SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END) AS LegitimateTransactions,
        CAST(
            SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*)
            AS DECIMAL(10,2)
        ) AS FraudPercentage,
        CAST(AVG(Amount) AS DECIMAL(10,2)) AS AverageTransactionAmount
    FROM Transactions;

END;
GO

-- Execute the Stored Procedure

EXEC GetFraudSummary;
GO

-- Fraud summary-a reusable Stored Procedure-ah create panni execute pannum. Example: EXEC GetFraudSummary run panna total transactions, fraud count, legitimate count, fraud percentage, average amount ellam one summary-la varum. Memory: Create → Execute → Summary

USE FinancialCrimeDB;
GO

CREATE OR ALTER PROCEDURE GetFraudSummary
AS
BEGIN
    SELECT
        COUNT(*) AS TotalTransactions,
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS FraudTransactions,
        SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END) AS LegitimateTransactions,
        CAST(
            SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*)
            AS DECIMAL(10,2)
        ) AS FraudPercentage,
        CAST(AVG(Amount) AS DECIMAL(10,2)) AS AverageTransactionAmount
    FROM Transactions;
END;
GO

EXEC GetFraudSummary;
GO