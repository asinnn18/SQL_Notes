USE FinancialCrimeDB;
GO

CREATE TABLE Transactions(
    TransactionID INT PRIMARY KEY,
    Time INT not null,
    V1 float,
    V2 float,
    V3 float,
    V4 float,
    V5 float,
    V6 float,
    V7 float,
    V8 float,
    V9 float,
    V10 float,
    V11 float,
    V12 float,
    V13 float,
    V14 float,
    V15 float,
    V16 float,
    V17 float,
    V18 float,
    V19 float,
    V20 float,
    V21 float,
    V22 float,
    V23 float,
    V24 float,
    V25 float,
    V26 float,
    V27 float,
    V28 float,
    Amount DECIMAL(10,2) not null,
    Class BIT not null
);
GO
SELECT * FROM Transactions;

USE FinancialCrimeDB;
GO
--verifying the created table
SELECT * 
FROM information_schema.tables;

