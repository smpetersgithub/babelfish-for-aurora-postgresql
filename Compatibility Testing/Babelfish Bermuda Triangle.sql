SET NOCOUNT ON;
GO

/*----------------------------------------------------
Error: Adding NOT NULL constraints

'NOT NULL in ALTER TABLE ALTER COLUMN' is not currently supported in Babelfish

This is puzzle #3, Fiscal Year Table Constraints

*/----------------------------------------------------
PRINT('1 - Adding NOT NULL constraints')

DROP TABLE IF EXISTS #EmployeePayRecords;
GO

CREATE TABLE #EmployeePayRecords
(
EmployeeID  INTEGER,
FiscalYear  INTEGER,
StartDate   DATE,
EndDate     DATE,
PayRate     MONEY
);
GO

--NOT NULL
ALTER TABLE #EmployeePayRecords ALTER COLUMN EmployeeID INTEGER NOT NULL;
ALTER TABLE #EmployeePayRecords ALTER COLUMN FiscalYear INTEGER NOT NULL;
ALTER TABLE #EmployeePayRecords ALTER COLUMN StartDate DATE NOT NULL;
ALTER TABLE #EmployeePayRecords ALTER COLUMN EndDate DATE NOT NULL;
ALTER TABLE #EmployeePayRecords ALTER COLUMN PayRate MONEY NOT NULL;
GO

--PRIMARY KEY
ALTER TABLE #EmployeePayRecords ADD CONSTRAINT PK_FiscalYearCalendar
                                    PRIMARY KEY (EmployeeID,FiscalYear);
--CHECK CONSTRAINTS
ALTER TABLE #EmployeePayRecords ADD CONSTRAINT Check_Year_StartDate
                                    CHECK (FiscalYear = DATEPART(YYYY,StartDate));
ALTER TABLE #EmployeePayRecords ADD CONSTRAINT Check_Month_StartDate 
                                    CHECK (DATEPART(MM,StartDate) = 01);
ALTER TABLE #EmployeePayRecords ADD CONSTRAINT Check_Day_StartDate 
                                    CHECK (DATEPART(DD,StartDate) = 01);
ALTER TABLE #EmployeePayRecords ADD CONSTRAINT Check_Year_EndDate
                                    CHECK (FiscalYear = DATEPART(YYYY,EndDate));
ALTER TABLE #EmployeePayRecords ADD CONSTRAINT Check_Month_EndDate 
                                    CHECK (DATEPART(MM,EndDate) = 12);
ALTER TABLE #EmployeePayRecords ADD CONSTRAINT Check_Day_EndDate 
                                    CHECK (DATEPART(DD,EndDate) = 31);
ALTER TABLE #EmployeePayRecords ADD CONSTRAINT Check_Payrate
                                    CHECK (PayRate > 0);
GO

DROP TABLE IF EXISTS #EmployeePayRecords;
GO

/*----------------------------------------------------
Error: UNPIVOT

'UNPIVOT' is not currently supported in Babelfish

This is puzzle #8, Workflow Cases
*/----------------------------------------------------
PRINT('2 - UNPIVOT')

DROP TABLE IF EXISTS #WorkflowCases;
GO

CREATE TABLE #WorkflowCases
(
Workflow  VARCHAR(100) PRIMARY KEY,
Case1     INTEGER NOT NULL DEFAULT 0,
Case2     INTEGER NOT NULL DEFAULT 0,
Case3     INTEGER NOT NULL DEFAULT 0
);
GO

INSERT INTO #WorkflowCases (Workflow, Case1, Case2, Case3) VALUES
('Alpha',0,0,0),('Bravo',0,1,1),('Charlie',1,0,0),('Delta',0,0,0);
GO

--Solution 1
--Add each column
SELECT  Workflow,
        Case1 + Case2 + Case3 AS PassFail
FROM    #WorkflowCases;
GO

--Solution 2
--UNPIVOT operator
WITH cte_PassFail AS
(
SELECT  Workflow, CaseNumber, PassFail
FROM    (
        SELECT Workflow,Case1,Case2,Case3
        FROM #WorkflowCases
        ) p UNPIVOT (PassFail FOR CaseNumber IN (Case1,Case2,Case3)) AS UNPVT
)
SELECT  Workflow,
        SUM(PassFail) AS PassFail
FROM    cte_PassFail
GROUP BY Workflow
ORDER BY 1;
GO

DROP TABLE IF EXISTS #WorkflowCases;
GO
/*----------------------------------------------------
Error: TOP # Percent

TOP # PERCENT is not yet supported

This is puzzle #10, Mean, Median, Mode, and Range
*/----------------------------------------------------
PRINT('3 - TOP # PERCENT');
GO

DROP TABLE IF EXISTS #SampleData;
GO

CREATE TABLE #SampleData
(
IntegerValue  INTEGER NOT NULL
);
GO

INSERT INTO #SampleData (IntegerValue) VALUES
(5),(6),(10),(10),(13),(14),(17),(20),(81),(90),(76);
GO

--Median
SELECT
        ((SELECT TOP 1 IntegerValue
        FROM    (
                SELECT  TOP 50 PERCENT IntegerValue
                FROM    #SampleData
                ORDER BY IntegerValue
                ) a
        ORDER BY IntegerValue DESC) +  --Add the Two Together
        (SELECT TOP 1 IntegerValue
        FROM (
            SELECT  TOP 50 PERCENT IntegerValue
            FROM    #SampleData
            ORDER BY IntegerValue DESC
            ) a
        ORDER BY IntegerValue ASC)
        ) * 1.0 /2 AS Median;
GO

--Mean and Range
SELECT  AVG(IntegerValue) AS Mean,
        MAX(IntegerValue) - MIN(IntegerValue) AS [Range]
FROM    #SampleData;
GO

--Mode
SELECT  TOP 1
        IntegerValue AS Mode,
        COUNT(*) AS ModeCount
FROM    #SampleData
GROUP BY IntegerValue
ORDER BY ModeCount DESC;
GO

DROP TABLE IF EXISTS #SampleData;
GO

/*----------------------------------------------------
Error: Recursion

recursive query "cte_permutations" column 1 has type "varchar" in non-recursive term but type text overall

Note, recursion does work in Babelfish and this script does run in SQL Server.  The error received does not
state it is a Babelfish error.

This is puzzle #11, Permutations

*/----------------------------------------------------
PRINT('4 - Recursive SQL');
GO

DROP TABLE IF EXISTS #TestCases;
GO

CREATE TABLE #TestCases
(
TestCase  VARCHAR(1) PRIMARY KEY
);
GO

INSERT INTO #TestCases (TestCase) VALUES
('A'),('B'),('C');
GO

DECLARE @vTotalElements INTEGER = (SELECT COUNT(*) FROM #TestCases);

--Recursion
WITH cte_Permutations (Permutation, Id, Depth)
AS
(
SELECT  CAST(TestCase AS VARCHAR(MAX)),
        CONCAT(CAST(TestCase AS VARCHAR(MAX)),';'),
        1 AS Depth
FROM    #TestCases
UNION ALL
SELECT  CONCAT(a.Permutation,',',b.TestCase),
        CONCAT(a.Id,b.TestCase,';'),
        a.Depth + 1
FROM    cte_Permutations a,
        #TestCases b
WHERE   a.Depth < @vTotalElements AND
        a.Id NOT LIKE CONCAT('%',b.TestCase,';%')
)
SELECT  Permutation
FROM    cte_Permutations
WHERE   Depth = @vTotalElements;
GO


DROP TABLE IF EXISTS #TestCases;
GO

/*----------------------------------------------------
Error: STRING_AGG, FOR XML does not produce the correct results

The string_agg function requires 2 arguments

This is puzzle #15, Group Concatenation

*/----------------------------------------------------
PRINT('5 - STRING AGG');
GO

DROP TABLE IF EXISTS #DMLTable;
GO

CREATE TABLE #DMLTable
(
SequenceNumber  INTEGER PRIMARY KEY,
String          VARCHAR(100) NOT NULL
);
GO

INSERT INTO #DMLTable (SequenceNumber, String) VALUES
(1,'SELECT'),
(2,'Product,'),
(3,'UnitPrice,'),
(4,'EffectiveDate'),
(5,'FROM'),
(6,'Products'),
(7,'WHERE'),
(8,'UnitPrice'),
(9,'> 100');
GO

--Solution 1
--STRING_AGG
SELECT  STRING_AGG(CONVERT(NVARCHAR(MAX),String), ' ') WITHIN GROUP (ORDER BY SequenceNumber ASC)
FROM    #DMLTable;
GO

--Solution 2
--Recursion
WITH cte_DMLGroupConcat(String2,Depth) AS
(
SELECT  CAST('' AS NVARCHAR(MAX)),
        CAST(MAX(SequenceNumber) AS INTEGER)
FROM    #DMLTable
UNION ALL
SELECT  cte_Ordered.String + ' ' + cte_Concat.String2, cte_Concat.Depth-1
FROM    cte_DMLGroupConcat cte_Concat INNER JOIN
        #DMLTable cte_Ordered ON cte_Concat.Depth = cte_Ordered.SequenceNumber
)
SELECT  String2
FROM    cte_DMLGroupConcat
WHERE   Depth = 0;
GO

--Does not output the same results as SQL Server
--Solution 3
--XML Path
SELECT  DISTINCT
        STUFF((
            SELECT  CAST(' ' AS VARCHAR(MAX)) + String
            FROM    #DMLTable U
            ORDER BY SequenceNumber
        FOR XML PATH('')), 1, 1, '') AS DML_String
FROM    #DMLTable;
GO

DROP TABLE IF EXISTS #DMLTable;
GO

/*----------------------------------------------------
ERROR: FOREIGN KEY on temporary table

This will error in Babelfish, but only provides a warning in SQL Server

column "integervalue" referenced in foreign key constraint does not exist

SQL server will give the following warning and not error.
Skipping FOREIGN KEY constraint '#Ungroup' definition for temporary table. FOREIGN KEY constraints are not enforced on local or global temporary tables.

This is puzzle #17, De-grouping
*/----------------------------------------------------
PRINT('6 - FOREIGN KEY');
GO

DROP TABLE IF EXISTS #Ungroup;
DROP TABLE IF EXISTS #Numbers;
GO

CREATE TABLE #Ungroup
(
ProductDescription  VARCHAR(100) PRIMARY KEY,
Quantity            INTEGER NOT NULL
);
GO

INSERT INTO #Ungroup (ProductDescription, Quantity) VALUES
('Pencil',3),('Eraser',4),('Notebook',2);
GO

--Solution 1
--Numbers Table
SELECT IntegerValue
INTO   #Numbers
FROM   (VALUES(1),(2),(3),(4)) a(IntegerValue) 
GO

--Skipping FOREIGN KEY constraint '#Ungroup' definition for temporary table. FOREIGN KEY constraints are not enforced on local or global temporary tables.
ALTER TABLE #Ungroup ADD FOREIGN KEY (Quantity) REFERENCES #Numbers(IntegerValue);
GO

SELECT  a.ProductDescription,
        1 AS Quantity
FROM    #Ungroup a CROSS JOIN
        #Numbers b
WHERE   a.Quantity >= b.IntegerValue;
GO

--Solution 2
--Recursion
WITH cte_Recursion AS
(
SELECT  ProductDescription,Quantity 
FROM    #Ungroup
UNION ALL
SELECT  ProductDescription,Quantity-1 
FROM    cte_Recursion
WHERE   Quantity >= 2
    )
SELECT  ProductDescription,1 AS Quantity
FROM   cte_Recursion
ORDER BY ProductDescription DESC;
GO

DROP TABLE IF EXISTS #Ungroup;
DROP TABLE IF EXISTS #Numbers;
GO

/*----------------------------------------------------
ERROR: INSERT/UPDATE/DELETE with Common Table Expression

relation "cte_duplicates" does not exist

In Babelfish, you cannot DELETE through the use of a CTE

This is puzzle #27, Delete the Duplicates

*/----------------------------------------------------
PRINT('7 - INSERT/UPDATE/DELETE with CTE');
GO

DROP TABLE IF EXISTS #SampleData;
GO

CREATE TABLE #SampleData
(
IntegerValue  INTEGER NOT NULL
);
GO

INSERT INTO #SampleData (IntegerValue) VALUES
(1),(1),(2),(3),(3),(4);
GO

WITH cte_Duplicates AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY IntegerValue ORDER BY IntegerValue) AS Rnk
FROM    #SampleData
)
DELETE FROM cte_Duplicates WHERE Rnk > 1
GO

SELECT * FROM #SampleData;
GO

DROP TABLE IF EXISTS #SampleData;
GO

/*----------------------------------------------------
Error: Computed Column divide by zero

division by zero

Babefish will compute the column during the ALTER statement.

In PostreSQL, a computed column must reference a column in the table.


*/----------------------------------------------------
PRINT('8 - Computed Column');
GO

DROP TABLE IF EXISTS #Products;
GO

CREATE TABLE #Products
(
ProductID    INTEGER PRIMARY KEY,
ProductName  VARCHAR(100) NOT NULL
);
GO

--Add the following constraint
--The following statement will run successfully.
--ALTER TABLE #Products ADD ComputedColumn AS (1/1);
--GO

ALTER TABLE #Products ADD ComputedColumn AS (0/0);
GO

DROP TABLE IF EXISTS #Products;
GO

/*----------------------------------------------------
Answer to Puzzle #56
Numbers Using Recursion

column "value" does not exist

In Babelfish, change "value" to "generate_series".

This is puzzle #56, Numbers Using Recursion

*/----------------------------------------------------
PRINT('9 - GENERATE SERIES');
GO

DECLARE @vTotalNumbers INTEGER = 10;

--Solution 1
--SQL Server has GENERATE SERIES begining with version 2022
SELECT values --generate_series  /*values*/
FROM GENERATE_SERIES(1, 10);


DECLARE @vTotalNumbers INTEGER = 10;

--Solution 2
--Recursion
WITH cte_Number (Number) AS 
(
SELECT  1 AS Number
UNION ALL
SELECT  Number + 1
FROM    cte_Number
WHERE   Number < @vTotalNumbers
)
SELECT  Number
FROM    cte_Number
OPTION (MAXRECURSION 0);--A value of 0 means no limit to the recursion level
GO


/*----------------------------------------------------
Error: STRING_SPLIT

function string_split has too many arguments specified.

This is puzzle #57, Find the Spaces
*/----------------------------------------------------
PRINT('10 - STRING_SPLIT');
GO

DROP TABLE IF EXISTS #Strings;
GO

CREATE TABLE #Strings
(
QuoteId  INTEGER IDENTITY(1,1) PRIMARY KEY,
String   VARCHAR(100) NOT NULL
);
GO

INSERT INTO #Strings (String) VALUES
('SELECT EmpID FROM Employees;'),('SELECT * FROM Transactions;');
GO

WITH cte_StringSplit AS
(
SELECT b.Ordinal AS RowNumber,
       a.QuoteId,
       a.String,
       b.[Value] AS Word,
       LEN(b.[Value]) AS WordLength
FROM   #Strings a CROSS APPLY
       STRING_SPLIT(String,' ', 1) b
)
SELECT RowNumber,
       QuoteID,
       String,
       CHARINDEX(Word, String) AS Starts,
       (CHARINDEX(Word, String) + WordLength) - 1 AS Ends,
       Word
FROM cte_StringSplit;
GO

DROP TABLE IF EXISTS #Strings;
GO

---------------------------------------------------------------------
---------------------------------------------------------------------
--The following is from my Behavior of Nulls documentation
---------------------------------------------------------------------
---------------------------------------------------------------------

DROP TABLE IF EXISTS #TableA;
DROP TABLE IF EXISTS #TableB;
GO

CREATE TABLE #TableA
(
ID          INTEGER,
Fruit       VARCHAR(255),
Quantity    INTEGER
);
GO

CREATE TABLE #TableB
(
ID          INTEGER,
Fruit       VARCHAR(255),
Quantity    INTEGER
);
GO

INSERT INTO #TableA VALUES(1,'Apple',17);
INSERT INTO #TableA VALUES(2,'Peach',20);
INSERT INTO #TableA VALUES(3,'Mango',11);
INSERT INTO #TableA VALUES(4,'Mango',15);
INSERT INTO #TableA VALUES(5,NULL,5);
INSERT INTO #TableA VALUES(6,NULL,3);
GO

INSERT INTO #TableB VALUES(1,'Apple',17);
INSERT INTO #TableB VALUES(2,'Peach',25);
INSERT INTO #TableB VALUES(3,'Kiwi',20);
INSERT INTO #TableB VALUES(4,NULL,NULL);
GO

SELECT * FROM #TableA;
SELECT * from #TableB;
GO


/*----------------------------------------------------
Error: IS <NOT> DISTINCT FROM

Babelfish error.  IS <NOT> DISTINCT FROM is a new feature of SQL Server

syntax error near 'WHERE' at line 5 and character position 0
*/----------------------------------------------------
PRINT('11 - IS <NOT> DISTINCT FROM');
GO

--Method 3
SELECT  *
FROM    #TableA a,
        #TableB b
WHERE   a.Fruit IS DISTINCT FROM b.Fruit;  --Babelfish error
GO
/*----------------------------------------------------
Success: NULL and VALUES keyword

The following will error in SQL Server, but runs without error in Babelfish

Operand data type NULL is invalid for sum operator.

*/----------------------------------------------------
PRINT('12 - NULL and VALUES keyword - Runs successfully in Babelfish, errors in SQL Server');
GO

--Statement 1
WITH cte_MyValues AS
(
SELECT NULL AS MyValue
UNION ALL
SELECT NULL
)
SELECT  SUM(MyValue)
FROM    cte_MyValues;
GO

--Statement 2
SELECT SUM(MyValue) FROM (VALUES (NULL), (NULL)) a(MyValue);
GO

/*----------------------------------------------------
Error: UNIQUE constraint

Nullable UNIQUE constraint is not supported. Please use babelfishpg_tsql.escape_hatch_unique_constraint to ignore or add a NOT NULL constraint
*/----------------------------------------------------
PRINT('13 - UNIQUE constraint');
GO

ALTER TABLE #TableB
ADD CONSTRAINT UNIQUE_NULLConstraints UNIQUE (Fruit);
GO

DROP TABLE IF EXISTS Child;
DROP TABLE IF EXISTS Parent;
GO


/*----------------------------------------------------
Error: FOREIGN KEY, UNIQUE, NOT NULL constraints

Nullable UNIQUE constraint is not supported. Please use babelfishpg_tsql.escape_hatch_unique_constraint to ignore or add a NOT NULL constraint
*/----------------------------------------------------
PRINT('14 - FOREIGN KEY, UNIQUE, NOT NULL constraints');
GO

DROP TABLE IF EXISTS Child;
DROP TABLE IF EXISTS Parent;
GO

CREATE TABLE Parent
(
ParentID INTEGER UNIQUE NOT NULL --Added the NOT NULL for Babelfish to run without error
);
GO

--Babelfish error
--syntax error at or near "FOREIGN"
CREATE TABLE Child
(
ChildID INTEGER IDENTITY(1,1),
ParentID INTEGER FOREIGN KEY REFERENCES Parent (ParentID) --Removed the FOREIGN KEY REFERENCES for Babelfish to run without error
);
GO

INSERT INTO Parent (ParentID) VALUES (1),(2),(3),(4),(5);
GO

INSERT INTO Child (ParentID) VALUES (1),(2),(NULL),(NULL);
GO

SELECT * FROM Parent;
SELECT * FROM Child;
GO

DROP TABLE IF EXISTS Child;
DROP TABLE IF EXISTS Parent;
GO

/*----------------------------------------------------
Error: LAG, LEAD with IGNORE NULLS

--Babelfish error.  IGNORE NULLS is a new feature in SQL Server.
--Applies to: SQL Server (starting with SQL Server 2022 (16.x)), Azure SQL Database, Azure SQL Managed Instance, Azure SQL Edge

--syntax error near 'OVER' at line 56 and character position 38
*/----------------------------------------------------
PRINT('15 - LAG, LEAD with IGNORE NULLS');
GO

WITH cte_Lag_Lead AS
(
SELECT 1 AS ID, 100 AS MyValue
UNION
SELECT 2 AS ID, 200 AS MyValue
UNION
SELECT 3 AS ID, NULL AS MyValue
UNION
SELECT NULL AS ID, 300 AS MyValue
)
SELECT  *,
        LAG(MyValue,1,0) IGNORE NULLS OVER (ORDER BY ID) AS LagIgnoreNulls,
        LEAD(MyValue,1,0) IGNORE NULLS OVER (ORDER BY ID) AS LeadIgnoreNulls,
        LAG(MyValue,1,0) RESPECT NULLS OVER (ORDER BY ID) AS LagRespectNulls,
        LEAD(MyValue,1,0) RESPECT NULLS OVER (ORDER BY ID) AS LeadRespectNulls
FROM    cte_Lag_Lead
ORDER BY ID;
GO


--End Behavior of NULLs section
--End Behavior of NULLs section
--End Behavior of NULLs section
--End Behavior of NULLs section

/*----------------------------------------------------
Error: Global Temporary Table

'GLOBAL TEMPORARY TABLE' is not currently supported in Babelfish
*/----------------------------------------------------
PRINT('16 - Global Temporary Table');
GO

DROP TABLE IF EXISTS ##GlobalTemporaryTable;
GO

CREATE TABLE ##GlobalTemporaryTable
(
HelloWorld  VARCHAR(100)
);
GO

DROP TABLE IF EXISTS ##GlobalTemporaryTable;
GO

/*----------------------------------------------------
Error: Merge Statement

'MERGE' is not currently supported in Babelfish
----------------------------------------------------*/
PRINT('17 - Merge Statement');
GO

SET NOCOUNT ON
GO

DROP TABLE IF EXISTS #SourceTable;
DROP TABLE IF EXISTS #TargetTable;
GO

-- Source Table
CREATE TABLE #SourceTable (
    ID INT NOT NULL,
    TableType VARCHAR(10) NOT NULL,
    EmployeeName NVARCHAR(50) NOT NULL,
    Department VARCHAR(10) NOT NULL,
    ModifiedDate DATETIME DEFAULT GETDATE()
);
GO

-- Target Table
CREATE TABLE #TargetTable (
    ID INT NOT NULL,
    TableType VARCHAR(10) NULL,
    EmployeeName VARCHAR(50) NOT NULL,
    Department VARCHAR(10) NOT NULL,
    IsMatched SMALLINT DEFAULT 0,
    IsNotMatchedByTarget SMALLINT DEFAULT 0,
    IsNotMatchedBySource SMALLINT DEFAULT 0,
    ModifiedDate DATETIME DEFAULT GETDATE()
);
GO

-- INSERT statements for TargetTable
INSERT INTO #TargetTable (ID, TableType, EmployeeName, Department) VALUES (1, 'Target', 'Tommy Target', 'Accounting');
INSERT INTO #TargetTable (ID, TableType, EmployeeName, Department) VALUES (2, 'Target', 'Toni Target', 'Marketing');
INSERT INTO #TargetTable (ID, TableType, EmployeeName, Department) VALUES (4, 'Target', 'Trisha Target', 'IT');

-- INSERT statements for SourceTable
INSERT INTO #SourceTable (ID, TableType, EmployeeName, Department) VALUES (1, 'Source', 'Sally Source', 'Accounting');
INSERT INTO #SourceTable (ID, TableType, EmployeeName, Department) VALUES (2, 'Source', 'Sheila Source', 'Marketing');
INSERT INTO #SourceTable (ID, TableType, EmployeeName, Department) VALUES (3, 'Source', 'Sammy Source', 'Finance');
GO

DROP TABLE IF EXISTS #SourceTable;
DROP TABLE IF EXISTS #TargetTable;
GO

--------------------------------------------------------------------

MERGE #TargetTable AS trgt
USING #SourceTable AS src
ON trgt.ID = src.ID AND trgt.ID > 0 AND src.ID > 0

WHEN MATCHED THEN
    UPDATE SET trgt.IsMatched = 1

WHEN NOT MATCHED BY TARGET AND src.ID > 0 THEN
    INSERT (ID, EmployeeName, Department, IsNotMatchedByTarget)
    VALUES (src.ID, src.EmployeeName, src.Department, 1)

WHEN NOT MATCHED BY SOURCE AND trgt.ID > 0 THEN
    UPDATE SET trgt.IsNotMatchedBySource = 1;

GO

SELECT * FROM #TargetTable;
GO

/*----------------------------------------------------
Error: XML

schema "babelfish_data" does not exist
'XML NODES' is not currently supported in Babelfish

----------------------------------------------------*/
PRINT('18 - XML data type');
GO

DROP TABLE IF EXISTS #SampleXmlTable;
GO

CREATE TABLE #SampleXmlTable
(
    ID INT PRIMARY KEY,
    Data XML
);

INSERT INTO #SampleXmlTable (ID, Data) VALUES
(1, '<Books>
        <Book>
            <Title>SQL Fundamentals</Title>
            <Author>John Doe</Author>
        </Book>
        <Book>
            <Title>Advanced SQL Queries</Title>
            <Author>Jane Smith</Author>
        </Book>
     </Books>'),

(2, '<Books>
        <Book>
            <Title>Learning XML</Title>
            <Author>Alice Johnson</Author>
        </Book>
     </Books>');

--Retrieve the Entire XML Column:
--Does not error
SELECT ID, Data 
FROM #SampleXmlTable;

--Retrieve a Specific Element Value:
--Msg 33557097, Level 16, State 1, Line 829
--schema "babelfish_data" does not exist
SELECT 
  ID, 
  Data.value('(/Books/Book[1]/Title)[1]', 'VARCHAR(100)') AS FirstBookTitle
FROM #SampleXmlTable;


--Retrieve a List of Specific Element Values:
SELECT 
  ID, 
  BookData.value('(Title)[1]', 'VARCHAR(100)') AS BookTitle
FROM 
  #SampleXmlTable
CROSS APPLY 
  Data.nodes('/Books/Book') AS Books(BookData);

--Retrieve Data Based on a Condition in XML:
SELECT 
  ID, 
  Data
FROM 
  #SampleXmlTable
WHERE 
  Data.exist('/Books/Book[Author="John Doe"]') = 1;
GO

DROP TABLE IF EXISTS #SampleXmlTable;
GO

/*----------------------------------------------------
Error: ALTER statements

The following will error per documentation
ALTER DATABASE
ALTER DATABASE SCOPED CONFIGURATION
ALTER DATABASE SCOPED CREDENTIAL
ALTER DATABASE SET HADR
ALTER FUNCTION
ALTER INDEX
ALTER PROCEDURE statement
ALTER SCHEMA
ALTER SERVER CONFIGURATION
ALTER SERVICE, BACKUP/RESTORE SERVICE MASTER KEY clause
ALTER VIEW

'ALTER DATABASE' is not currently supported in Babelfish

----------------------------------------------------*/
PRINT('19 - ALTER statements');
GO

ALTER DATABASE babelfish SET RECOVERY FULL;

/*----------------------------------------------------
Error: INSERT... DEFAULT VALUES

----------------------------------------------------*/
PRINT('20 - DEFAULT VALUES (this runs successfully)');
GO

DROP TABLE IF EXISTS #DefaultValues;
GO

CREATE TABLE #DefaultValues
(
myInt     INTEGER DEFAULT 0,
myDefault VARCHAR(100) DEFAULT 'My Default Value'
);
GO

--According to the AWS documentation, this operation is expected to result in an error; however, it executes without issue in Babelfish.
INSERT INTO #DefaultValues DEFAULT VALUES;

DROP TABLE IF EXISTS #DefaultValues;
GO

/*----------------------------------------------------
Error: READTEXT

'READTEXT' is not currently supported in Babelfish

----------------------------------------------------*/
PRINT('21 - READTEXT');
GO

DROP TABLE IF EXISTS #DocumentTable;
GO

CREATE TABLE #DocumentTable
(
    DocID INT PRIMARY KEY,
    DocContent TEXT
);
GO

DECLARE @ptrval VARBINARY(16);
SELECT @ptrval = TEXTPTR(DocContent)
FROM #DocumentTable
WHERE DocID = 1;

READTEXT #DocumentTable.DocContent @ptrval 0 100;
GO

DROP TABLE IF EXISTS #DocumentTable;
GO

/*----------------------------------------------------
Error: ROWGUIDCOL

syntax error near 'ROWGUIDCOL' at line 5 and character position 48

----------------------------------------------------*/
PRINT('22 - ROWGUIDCOL');
GO

DROP TABLE IF EXISTS #ExampleTable;
GO

-- Create a table with an identity column and a ROWGUIDCOL column
CREATE TABLE #ExampleTable (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    GuidColumn UNIQUEIDENTIFIER DEFAULT NEWID() ROWGUIDCOL
);
GO

-- Insert data into the table
INSERT INTO #ExampleTable DEFAULT VALUES;
INSERT INTO #ExampleTable DEFAULT VALUES; -- Insert a couple of rows to update the identity and ROWGUID values
GO

-- Use system functions to return the last identity and ROWGUID values
SELECT 
    @@IDENTITY AS LastIdentityValue, -- Returns the last identity value generated in the current session
    @@ROWCOUNT AS RowsAffected,      -- Returns the number of rows affected by the last operation
    (SELECT TOP 1 GuidColumn FROM #ExampleTable ORDER BY ID DESC) AS LastRowGuidValue -- Technique to retrieve the last ROWGUID value inserted
GO

DROP TABLE IF EXISTS #ExampleTable;
GO

/*----------------------------------------------------
Error: ROWGUIDCOL

'$IDENTITY' is not currently supported in Babelfish

----------------------------------------------------*/
PRINT('23 - $IDENTITY');
GO

DROP TABLE IF EXISTS #ExampleTable;
GO

-- Create a table with an identity column and a ROWGUIDCOL column
CREATE TABLE #ExampleTable (
    ID INT IDENTITY(1,1) PRIMARY KEY
);
GO

-- Insert data into the table
INSERT INTO #ExampleTable DEFAULT VALUES;
INSERT INTO #ExampleTable DEFAULT VALUES; -- Insert a couple of rows to update the identity and ROWGUID values
GO

DECLARE @minidentval INT;
DECLARE @maxidentval INT;
DECLARE @nextidentval INT;

SELECT @minidentval = MIN($IDENTITY),
       @maxidentval = MAX($IDENTITY)
FROM   #ExampleTable;

PRINT(CONCAT('@minidentval= ', @minidentval));
PRINT(CONCAT('@maxidentval= ', @maxidentval));
GO

DROP TABLE IF EXISTS #ExampleTable;
GO

/*----------------------------------------------------
Error: WAITFORDELAY

--Need to test

----------------------------------------------------*/
PRINT('24 - WAITFOR DELAY');
GO

WAITFOR DELAY '00:00:05'; -- Wait for 5 seconds
GO



/*----------------------------------------------------
Error: Global Variables/System Functions

does not exist errors
--Need to test

----------------------------------------------------*/
PRINT('25 - Global Variables / System Functions');
GO

SELECT 'System' AS MyFunctionType,  '@@DEF_SORTORDER_ID'  AS MyFunction, @@DEF_SORTORDER_ID AS MyValue, 'No Microsoft documentation provided. Same as SELECT SERVERPROPERTY(SqlSortOrder);' AS Description
GO
SELECT 'System', '@@PACK_RECEIVED', @@PACK_RECEIVED, 'Returns the number of input packets read from the network by SQL Server since it was last started.'
GO
SELECT 'Configuration' AS MyFunctionType, '@@DBTS' AS MyFunction, CAST(@@DBTS AS VARCHAR(255)) AS MyValue, 'This function returns the value of the current timestamp data type for the current database.' AS MyDescription
GO
SELECT 'Configuration', '@@LANGID', CAST(@@LANGID AS VARCHAR(255)), 'Returns the local language identifier (ID) of the language that is currently being used.'
GO
SELECT 'Configuration', '@@REMSERVER', CAST(@@REMSERVER AS VARCHAR(255)), 'Returns the name of the remote SQL Server database server as it appears in the login record.'
GO
SELECT 'Statistical' AS MyFunctionType, '@@CONNECTIONS' AS MyFunction, @@CONNECTIONS AS MyValue, 'This function returns the number of attempted connections - both successful and unsuccessful - since SQL Server was last started.' AS MyDescription
GO
SELECT 'Statistical', '@@CPU_BUSY', @@CPU_BUSY, 'This function returns the amount of time that SQL Server has spent in active operation since its latest start. @@CPU_BUSY returns a result measured in CPU time increments, or "ticks." This value is cumulative for all CPUs, so it may exceed the actual elapsed time. To convert to microseconds, multiply by @@TIMETICKS.'
GO
SELECT 'Statistical', '@@IDLE', @@IDLE, 'Returns the time that SQL Server has been idle since it was last started. The result is in CPU time increments, or "ticks," and is cumulative for all CPUs, so it may exceed the actual elapsed time. Multiply by @@TIMETICKS to convert to microseconds.'
GO
SELECT 'Statistical', '@@IO_BUSY', @@IO_BUSY, 'Returns the time that SQL Server has spent performing input and output operations since SQL Server was last started. The result is in CPU time increments ("ticks"), and is cumulative for all CPUs, so it may exceed the actual elapsed time. Multiply by @@TIMETICKS to convert to microseconds.'
GO
SELECT 'Statistical', '@@PACK_SENT', @@PACK_SENT, 'Returns the number of output packets written to the network by SQL Server since it was last started.'
GO
SELECT 'Statistical', '@@PACKET_ERRORS', @@PACKET_ERRORS, 'Returns the number of network packet errors that have occurred on SQL Server connections since SQL Server was last started.'
GO
SELECT 'Statistical', '@@TIMETICKS', @@TIMETICKS, 'Returns the number of microseconds per tick.'
GO
SELECT 'Statistical', '@@TOTAL_ERRORS', @@TOTAL_ERRORS, 'Returns the number of disk write errors encountered by SQL Server since SQL Server last started.'
GO
SELECT 'Statistical', '@@TOTAL_READ', @@TOTAL_READ, 'Returns the number of disk reads, not cache reads, by SQL Server since SQL Server was last started.'
GO
SELECT 'Statistical', '@@TOTAL_WRITE', @@TOTAL_WRITE, 'Returns the number of disk writes by SQL Server since SQL Server was last started.'
GO

/*----------------------------------------------------
Error: Missing Index

does not exist errors
--Need to test

----------------------------------------------------*/
PRINT('26 - sys.dm_db_missing_index_groups');
GO
SELECT *
FROM    sys.dm_db_missing_index_groups AS mig INNER JOIN
        sys.dm_db_missing_index_group_stats AS migs ON migs.group_handle = mig.index_group_handle INNER JOIN
        sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle
GO

  
/*----------------------------------------------------
Error: sysjobsteps

does not exist errors
--Need to test

----------------------------------------------------*/  
PRINT('27 - sysjobsteps');
GO
SELECT *
FROM    msdb.dbo.sysjobsteps s INNER JOIN 
        msdb.dbo.sysjobs AS j ON s.job_id = j.job_id;
GO

/*----------------------------------------------------
Error: sp_helptext

does not exist errors
--Need to test

----------------------------------------------------*/ 
PRINT('27 - sp_helptext');
GO
--Babelfish error
--'sp_helptext' is not currently supported in Babelfish
DECLARE @vTableVariable TABLE(SpText VARCHAR(MAX));
DECLARE @vStoredProcedureName VARCHAR(255) = 'spTest';
INSERT INTO @vTableVariable
EXEC sp_helptext @vStoredProcedureName;
SELECT * FROM @vTableVariable;


id numeric(20,0) identity(1,1) not null

-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
--generation expression is not immutable
CREATE TABLE Temp
(
	--[RelationID] [dbo].[ID] IDENTITY(1,1) NOT NULL,
	Name varchar(100) NOT NULL,
	LineNumber tinyint NOT NULL,
	RelationCode  AS (CONVERT(VARCHAR(50),CASE WHEN Name = '' AND LineNumber=(0) THEN NULL ELSE [Name] + CONVERT(VARCHAR(5),LineNumber,0) END,0)),
);

-------------------------------------------------
-------------------------------------------------
-------------------------------------------------

--identity column must have precision 18 or less
CREATE TABLE #Test
(
id [numeric](20, 0) IDENTITY(1,1) NOT NULL
);
