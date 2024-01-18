SET NOCOUNT ON;

/*
Returns the ASCII values of a string

This script loops through a string and displays
all the ASCII characters in the string.
*/
PRINT('Statement 1');

DECLARE @vMyString VARCHAR(100) = 'Hello World';
DECLARE @vLength INTEGER = LEN(@vMyString);
DECLARE @vPosition INTEGER = 0;
DECLARE @vAscii VARCHAR(MAX) = '';

--Begin Loop
WHILE @vLength >= @vPosition
BEGIN
  SELECT @vAscii = @vAscii + CONCAT(ASCII(SUBSTRING(@vMyString,@vPosition,1)),',');
  SELECT @vPosition = @vPosition + 1;
END;

--Removes beginning and ending commas
SET @vAscii = SUBSTRING(@vAscii,2,LEN(@vAscii)-2);

SELECT @vAscii AS AsciiCodes;
GO

/*
Determines the size of a data type
*/
SELECT COLUMNPROPERTY( OBJECT_ID('dbo.mytable'),'mycolumn','PRECISION') AS 'ColumnLength';

/*
Cursor Example

A quick example of a Microsoft SQL Server cursor usage.
https://learn.microsoft.com/en-us/sql/t-sql/language-elements/declare-cursor-transact-sql?view=sql-server-ver16
*/
PRINT('Statement 2');

DECLARE @vMyVariable VARCHAR(100);
DECLARE test_cursor CURSOR FOR (SELECT 'Hello World' UNION SELECT 'Goodbye World');

OPEN test_cursor;
FETCH NEXT FROM test_cursor INTO @vMyVariable;
    WHILE @@FETCH_STATUS = 0
        BEGIN
        PRINT(CONCAT('The value is ', @vMyVariable));
        FETCH NEXT FROM test_cursor INTO @vMyVariable;
        END
CLOSE test_cursor;
DEALLOCATE test_cursor;
GO
/*
The functions that start with @@ in SQL Server are called Global Variables or System Functions.

These functions return information that is specific to the server or a current session, like session-level settings, server configuration, or current status. 

System Functions are similar to functions but don't require parentheses when calling them.

Examples include @@VERSION, which returns the current version of SQL Server, and @@SPID, which returns the session ID for the current user process. 

These system functions are useful for diagnostic purposes, configuration checks, or to control flow within stored procedures and scripts.
*/
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
--System
--https://learn.microsoft.com/en-us/sql/t-sql/functions/system-functions-transact-sql?view=sql-server-ver16
PRINT('Statement 3');

--Babelfish error:
--function sys.def_sortorder_id() does not exist
SELECT 'System' AS MyFunctionType,  '@@DEF_SORTORDER_ID'  AS MyFunction, @@DEF_SORTORDER_ID AS MyValue, 'No Microsoft documentation provided. Same as SELECT SERVERPROPERTY(SqlSortOrder);' AS Description
UNION
SELECT 'System', '@@ERROR', @@ERROR, 'Returns the error number for the last Transact-SQL statement executed.'
UNION
SELECT 'System', '@@IDENTITY', @@IDENTITY, 'Is a system function that returns the last-inserted identity value.'
UNION

--Babelfish error:
--function sys.pack_received() does not exist
SELECT 'System', '@@PACK_RECEIVED', @@PACK_RECEIVED, 'Returns the number of input packets read from the network by SQL Server since it was last started.'
UNION
SELECT 'System', '@@ROWCOUNT', @@ROWCOUNT, 'Returns the number of rows affected by the last statement. If the number of rows is more than 2 billion, use ROWCOUNT_BIG function.'
UNION
SELECT 'System', '@@TRANCOUNT', @@TRANCOUNT, 'Returns the number of BEGIN TRANSACTION statements that have occurred on the current connection.'
;
GO
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
--Configuration
--https://learn.microsoft.com/en-us/sql/t-sql/functions/configuration-functions-transact-sql?view=sql-server-ver16
PRINT('Statement 4');


--Babelfish error:
--To use @@DBTS, set 'babelfishpg_tsql.escape_hatch_rowversion' to 'ignore'
SELECT 'Configuration' AS MyFunctionType, '@@DBTS' AS MyFunction, CAST(@@DBTS AS VARCHAR(255)) AS MyValue, 'This function returns the value of the current timestamp data type for the current database.' AS MyDescription
UNION

--Babelfish error:
--function sys.langid() does not exist
SELECT 'Configuration', '@@LANGID', CAST(@@LANGID AS VARCHAR(255)), 'Returns the local language identifier (ID) of the language that is currently being used.'
UNION
SELECT 'Configuration', '@@LANGUAGE', CAST(@@LANGUAGE AS VARCHAR(255)), 'Returns the name of the language currently being used.'
UNION
SELECT 'Configuration', '@@LOCK_TIMEOUT', CAST(@@LOCK_TIMEOUT AS VARCHAR(255)), 'Returns the current lock time-out setting in milliseconds for the current session.'
UNION
SELECT 'Configuration', '@@MAX_CONNECTIONS', CAST(@@MAX_CONNECTIONS AS VARCHAR(255)), 'Returns the maximum number of simultaneous user connections allowed on an instance of SQL Server.'
UNION
SELECT 'Configuration', '@@MAX_PRECISION', CAST(@@MAX_PRECISION AS VARCHAR(255)), 'Returns the precision level used by decimal and numeric data types as currently set in the server.'
UNION
SELECT 'Configuration', '@@MICROSOFTVERSION', CAST(@@MICROSOFTVERSION AS VARCHAR(255)), 'Returns Microsoft SQL Server version information.'
UNION
SELECT 'Configuration', '@@NESTLEVEL', CAST(@@NESTLEVEL AS VARCHAR(255)), 'Returns the nesting level of the current stored procedure execution on the local server.'
UNION
SELECT 'Configuration', '@@OPTIONS', CAST(@@OPTIONS AS VARCHAR(255)), 'Returns information about the current SET options.'
UNION
--Babelfish error
--function sys.remserver() does not exist
--SELECT 'Configuration', '@@REMSERVER', CAST(@@REMSERVER AS VARCHAR(255)), 'Returns the name of the remote SQL Server database server as it appears in the login record.'
--UNION
SELECT 'Configuration', '@@SERVERNAME', CAST(@@SERVERNAME AS VARCHAR(255)), 'Returns the name of the local server that is running SQL Server.'
UNION
--SELECT 'Configuration Functions', '@@SERVICENAME', CAST(@@SERVICENAME AS VARCHAR(255)), 'Returns the name of the registry key under which SQL Server is running.'
--UNION
SELECT 'Configuration', '@@SPID', CAST(@@SPID AS VARCHAR(255)), 'Returns the session ID of the current user process.'
UNION
--Babelfish error:
--function sys.textsize() does not exist
SELECT 'Configuration', '@@TEXTSIZE', CAST(@@TEXTSIZE AS VARCHAR(255)), 'Returns the current value of the TEXTSIZE option.'
UNION
SELECT 'Configuration', '@@VERSION', CAST(@@VERSION AS VARCHAR(255)), 'Returns system and build information for the current installation of SQL Server.'
;

-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
--System Statistical
--https://learn.microsoft.com/en-us/sql/t-sql/functions/system-statistical-functions-transact-sql?view=sql-server-ver16
PRINT('Statement 5');

--Babelfish error
--function sys.connections() does not exist
SELECT 'Statistical' AS MyFunctionType, '@@CONNECTIONS' AS MyFunction, @@CONNECTIONS AS MyValue, 'This function returns the number of attempted connections - both successful and unsuccessful - since SQL Server was last started.' AS MyDescription
UNION 
--Babelfish error
--function sys.cpu_busy() does not exist
SELECT 'Statistical', '@@CPU_BUSY', @@CPU_BUSY, 'This function returns the amount of time that SQL Server has spent in active operation since its latest start. @@CPU_BUSY returns a result measured in CPU time increments, or "ticks." This value is cumulative for all CPUs, so it may exceed the actual elapsed time. To convert to microseconds, multiply by @@TIMETICKS.'
UNION
--Babelfish error
--function sys.idle() does not exist
SELECT 'Statistical', '@@IDLE', @@IDLE, 'Returns the time that SQL Server has been idle since it was last started. The result is in CPU time increments, or "ticks," and is cumulative for all CPUs, so it may exceed the actual elapsed time. Multiply by @@TIMETICKS to convert to microseconds.'
UNION

--Babelfish error
--function sys.io_busy() does not exist
SELECT 'Statistical', '@@IO_BUSY', @@IO_BUSY, 'Returns the time that SQL Server has spent performing input and output operations since SQL Server was last started. The result is in CPU time increments ("ticks"), and is cumulative for all CPUs, so it may exceed the actual elapsed time. Multiply by @@TIMETICKS to convert to microseconds.'
UNION

--Babelfish error
--function sys.pack_sent() does not exist
SELECT 'Statistical', '@@PACK_SENT', @@PACK_SENT, 'Returns the number of output packets written to the network by SQL Server since it was last started.'
UNION

--Babelfish error
--function sys.packet_errors() does not exist
SELECT 'Statistical', '@@PACKET_ERRORS', @@PACKET_ERRORS, 'Returns the number of network packet errors that have occurred on SQL Server connections since SQL Server was last started.'
UNION

--Babelfish error
--function sys.timeticks() does not exist
SELECT 'Statistical', '@@TIMETICKS', @@TIMETICKS, 'Returns the number of microseconds per tick.'
UNION
SELECT 'Statistical', '@@TOTAL_ERRORS', @@TOTAL_ERRORS, 'Returns the number of disk write errors encountered by SQL Server since SQL Server last started.'
UNION
--Babelfish error
--function sys.total_errors() does not exist
SELECT 'Statistical', '@@TOTAL_READ', @@TOTAL_READ, 'Returns the number of disk reads, not cache reads, by SQL Server since SQL Server was last started.'
UNION

----Babelfish error
--function sys.total_write() does not exist
SELECT 'Statistical', '@@TOTAL_WRITE', @@TOTAL_WRITE, 'Returns the number of disk writes by SQL Server since SQL Server was last started.'
;

-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
--Other
--See individual links.  These functions I have categorized as "Other"
PRINT('Statement 6');
--https://learn.microsoft.com/en-us/sql/t-sql/functions/cursor-functions-transact-sql?view=sql-server-ver16
SELECT 'Cursor' AS MyFunctionType, '@@CURSOR_ROWS' AS MyFunction, @@CURSOR_ROWS AS MyValue, 'This returns the number of qualifying rows currently in the last cursor opened on the connection. To improve performance, SQL Server can populate large keyset and static cursors asynchronously. @@CURSOR_ROWS can be called to determine that the number of the rows that qualify for a cursor are retrieved at the time of the @@CURSOR_ROWS call.' AS MyDescription
UNION
--https://learn.microsoft.com/en-us/sql/t-sql/functions/cursor-functions-transact-sql?view=sql-server-ver16
SELECT 'Cursor', '@@FETCH_STATUS', @@FETCH_STATUS, 'This function returns the status of the last cursor FETCH statement issued against any cursor currently opened by the connection.'
UNION
--https://learn.microsoft.com/en-us/sql/t-sql/functions/metadata-functions-transact-sql?view=sql-server-ver16
SELECT 'MetaData', '@@PROCID', @@PROCID, 'Returns the object identifier (ID) of the current Transact-SQL module. A Transact-SQL module can be a stored procedure, user-defined function, or trigger. @@PROCID cannot be specified in CLR modules or the in-process data access provider.'
UNION
--https://learn.microsoft.com/en-us/sql/t-sql/functions/date-and-time-data-types-and-functions-transact-sql?view=sql-server-ver16
SELECT 'Date and Time', '@@DATEFIRST', @@DATEFIRST, 'This function returns the current value of SET DATEFIRST, for a specific session.'
;


/*
Missing Indexes

The following script finds missing indexes in Microsoft SQL Server.

The tables used are:
sys.dm_db_missing_index_groups
sys.dm_db_missing_index_group_stats
sys.dm_db_missing_index_details
*/

--Babelfish error
--relation "sys.dm_db_missing_index_groups" does not exist
PRINT('Statement 7');
SELECT
        GETDATE() AS runtime
        ,@@Servername
        ,REPLACE(REPLACE(mid.statement,']',''),'[','') AS tablename
        ,migs.avg_total_user_cost
        ,migs.avg_user_impact
        ,migs.user_seeks
        ,migs.user_scans
        
        --Pulled from the internet.
        ,CONVERT (DECIMAL (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) AS improvement_measure
        ----------------------------
        --Index creation syntax
        ,'CREATE INDEX missing_index_' + 'INDEX_NAME ON ' + mid.statement + ' (' + ISNULL (mid.equality_columns,'') + 
                    CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL
                         THEN ','
                         ELSE ''
                         END + ISNULL (mid.inequality_columns, '') + ')' + ISNULL (' INCLUDE (' + mid.included_columns + ')', '')
        AS create_index_statement
        ----------------------------
        ,mid.database_id
        ,mid.[object_id]
FROM    sys.dm_db_missing_index_groups AS mig INNER JOIN
        sys.dm_db_missing_index_group_stats AS migs ON migs.group_handle = mig.index_group_handle INNER JOIN
        sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle
WHERE    1=1
         AND mid.statement NOT LIKE '%msdb%'
ORDER BY
        user_seeks desc,
        migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC;
--EXEC sp_helptext 'schecma.name'


/*
Random Numbers

The following script creates a table (#RandomNumbers) of random numbers between 1 and 10
using the function ABS(CHECKSUM(NEWID()) % 10).

The loop below produces 10,000 random numbers ranging from 1 to 10 and subsequently displays 
the percentage distribution of these numbers to illustrate their randomness.
*/
PRINT('Statement 8');
DROP TABLE IF EXISTS #RandomNumbers;
GO
CREATE TABLE #RandomNumbers
(
MyRandomNumber INTEGER NOT NULL
);
GO
DECLARE @i INTEGER = 1;
DECLARE @loops INTEGER = 10;
WHILE @i <= @loops
BEGIN
    INSERT INTO #RandomNumbers SELECT ABS(CHECKSUM(NEWID()) % 10) + 1;
    SET @i = @i + 1;
END
GO
----------------------------------------------------------------
----------------------------------------------------------------
WITH cte_Total AS
(
SELECT COUNT(MyRandomNumber) AS MyTotal FROM #RandomNumbers
),
cte_Count AS
(
SELECT  MyRandomNumber, COUNT(*) AS MyCount
FROM    #RandomNumbers a CROSS JOIN
        cte_Total b
GROUP BY MyRandomNumber
)
SELECT  MyRandomNumber, 
        MyCount, 
        MyCount / CAST(MyTotal AS NUMERIC(10,2))
FROM    cte_Count a CROSS JOIN
        cte_Total b;
GO

/*
SQL Server Agent Job Steps

This SQL script prints out Microsoft SQL Server Agent job steps.

dbo.sysjobsstep
Contains the information for each step in a job to be 
executed by SQL Server Agent. This table is stored in the msdb database.

dbo.sysjobs
Stores the information for each scheduled job to be executed by SQL Server Agent. 
This table is stored in the msdb database.
*/
--Babelfish error
--relation "msdb_dbo.sysjobsteps" does not exist
PRINT('Statement 9');

SELECT  @@SERVERNAME AS ServerName,
        s.step_id AS 'StepID',
        j.[name] AS 'SQLAgentJobName',
        s.[database_name] AS 'DBName',
        s.command AS 'Command'
FROM    msdb.dbo.sysjobsteps s INNER JOIN 
        msdb.dbo.sysjobs AS j ON s.job_id = j.job_id
WHERE   1=1 
        AND s.command LIKE '%example_command%';

/*
Different SQL statements to determine second highest salary.
*/

DROP TABLE IF EXISTS #Employees;
GO

CREATE TABLE #Employees (
EmployeeID INT PRIMARY KEY,
EmployeeName VARCHAR(50),
TotalPurchaseAmount MONEY
);

INSERT INTO #Employees (EmployeeID, EmployeeName, TotalPurchaseAmount)
VALUES
(1, 'Carl Friedrich Gauss', 100000.00),
(2, 'Archimedes', 250000.00),
(3, 'Albert Einstein', 150000.00),
(4, 'Leonhard Euler', 100000.00);

--------------------------------------------
--------------------------------------------
--------------------------------------------
--Version 1
--RANK
WITH cte_Rank AS
(
SELECT  RANK() OVER (ORDER BY TotalPurchaseAmount DESC) AS MyRank,
        *
FROM    #Employees
)
SELECT  *
FROM    cte_Rank
WHERE   MyRank = 2;

--Version 2
--Top 1 and Max
SELECT  TOP 1 *
FROM    #Employees
WHERE   TotalPurchaseAmount <> (SELECT MAX(TotalPurchaseAmount) FROM #Employees)
ORDER BY TotalPurchaseAmount DESC;

--Version 3
--Offset and Fetch
SELECT  *
FROM    #Employees
ORDER BY TotalPurchaseAmount DESC
OFFSET 1 ROWS
FETCH NEXT 1 ROWS ONLY;

--Version 4
--Top 1 and Top 2
SELECT  TOP 1 *
FROM    (
        SELECT  TOP 2 *
        FROM    #Employees
        ORDER BY TotalPurchaseAmount DESC
        ) a
ORDER BY TotalPurchaseAmount ASC;

--Version 5
--Min and Top 2
WITH cte_TopMin AS
(
SELECT  MIN(TotalPurchaseAmount) AS MinTotalPurchaseAmount
FROM   (
       SELECT  TOP 2 *
       FROM    #Employees
       ORDER BY TotalPurchaseAmount DESC
       ) a
)
SELECT  *
FROM    #Employees
WHERE   TotalPurchaseAmount IN (SELECT MinTotalPurchaseAmount FROM cte_TopMin);

--Version 6
--Correlated Sub-Query
SELECT  *
FROM    #Employees a
WHERE   2 = (SELECT COUNT(DISTINCT b.TotalPurchaseAmount)
             FROM #Employees b
             WHERE a.TotalPurchaseAmount <= b.TotalPurchaseAmount);

--Version 7
--Top 1 and Lag
WITH cte_LeadLag AS
(
SELECT  *,
        LAG(TotalPurchaseAmount, 1, NULL) OVER (ORDER BY TotalPurchaseAmount DESC) AS PreviousAmount
FROM    #Employees
)
SELECT  TOP 1 *
FROM    cte_LeadLag
WHERE   PreviousAmount IS NOT NULL
ORDER BY TotalPurchaseAmount DESC;



-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

PRINT('Statement 10');

SELECT 'ServerProperty' AS MyFunctionType, 
       'BuildClrVersion' AS MyType, 
       SERVERPROPERTY('BuildClrVersion') AS PropertyValue,
       'CLR version of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'Collation', 
       SERVERPROPERTY('Collation'),
       'Server level collation'
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'CollationID' AS MyType, 
       SERVERPROPERTY('CollationID') AS PropertyValue,
       'ID for the server level collation' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'ComparisonStyle' AS MyType, 
       SERVERPROPERTY('ComparisonStyle') AS PropertyValue,
       'Comparison style bits of the collation' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'ComputerNamePhysicalNetBIOS' AS MyType, 
       SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS PropertyValue,
       'NetBIOS name of the local computer that is running the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'Edition' AS MyType, 
       SERVERPROPERTY('Edition') AS PropertyValue,
       'Edition of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'EngineEdition' AS MyType, 
       SERVERPROPERTY('EngineEdition') AS PropertyValue,
       'Edition of the engine of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'FilestreamConfiguredLevel' AS MyType, 
       SERVERPROPERTY('FilestreamConfiguredLevel') AS PropertyValue,
       'Filestream configured level' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'FilestreamEffectiveLevel' AS MyType, 
       SERVERPROPERTY('FilestreamEffectiveLevel') AS PropertyValue,
       'Filestream effective level' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'FilestreamShareName' AS MyType, 
       SERVERPROPERTY('FilestreamShareName') AS PropertyValue,
       'Filestream share name' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'HadrManagerStatus' AS MyType, 
       SERVERPROPERTY('HadrManagerStatus') AS PropertyValue,
       'Status of the Always On availability groups manager' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'InstanceDefaultBackupPath' AS MyType, 
       SERVERPROPERTY('InstanceDefaultBackupPath') AS PropertyValue,
       'Default backup directory of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'InstanceDefaultDataPath' AS MyType, 
       SERVERPROPERTY('InstanceDefaultDataPath') AS PropertyValue,
       'Default data directory of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'InstanceDefaultLogPath' AS MyType, 
       SERVERPROPERTY('InstanceDefaultLogPath') AS PropertyValue,
       'Default log directory of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType, 
       'InstanceName' AS MyType, 
       SERVERPROPERTY('InstanceName') AS PropertyValue,
       'Name of the instance to which the user is connected' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsAdvancedAnalyticsInstalled' AS MyType,
       SERVERPROPERTY('IsAdvancedAnalyticsInstalled') AS PropertyValue,
       'Indicates if SQL Server Machine Learning Services is installed' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsBigDataCluster' AS MyType,
       SERVERPROPERTY('IsBigDataCluster') AS PropertyValue,
       'Indicates if this is a Big Data cluster' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsClustered' AS MyType,
       SERVERPROPERTY('IsClustered') AS PropertyValue,
       'Server is a clustered instance' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsExternalAuthenticationOnly' AS MyType,
       SERVERPROPERTY('IsExternalAuthenticationOnly') AS PropertyValue,
       'Indicates if external authentication only is enabled' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsExternalGovernanceEnabled' AS MyType,
       SERVERPROPERTY('IsExternalGovernanceEnabled') AS PropertyValue,
       'Indicates if external governance is enabled' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsFullTextInstalled' AS MyType,
       SERVERPROPERTY('IsFullTextInstalled') AS PropertyValue,
       'Full-text and semantic indexing components are installed' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsHadrEnabled' AS MyType,
       SERVERPROPERTY('IsHadrEnabled') AS PropertyValue,
       'Indicates if the Always On availability groups feature is enabled' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsIntegratedSecurityOnly' AS MyType,
       SERVERPROPERTY('IsIntegratedSecurityOnly') AS PropertyValue,
       'Server only allows integrated authentication' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsLocalDB' AS MyType,
       SERVERPROPERTY('IsLocalDB') AS PropertyValue,
       'Indicates if this instance is SQL Server Express LocalDB' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsPolyBaseInstalled' AS MyType,
       SERVERPROPERTY('IsPolyBaseInstalled') AS PropertyValue,
       'Indicates if PolyBase feature is installed' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsSingleUser' AS MyType,
       SERVERPROPERTY('IsSingleUser') AS PropertyValue,
       'Server is in single-user mode' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsTempDbMetadataMemoryOptimized' AS MyType,
       SERVERPROPERTY('IsTempDbMetadataMemoryOptimized') AS PropertyValue,
       'Indicates if metadata of tempdb objects is memory-optimized' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'IsXTPSupported' AS MyType,
       SERVERPROPERTY('IsXTPSupported') AS PropertyValue,
       'Indicates if In-Memory OLTP is supported on this server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'LCID' AS MyType,
       SERVERPROPERTY('LCID') AS PropertyValue,
       'Windows locale ID of the collation' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'LicenseType' AS MyType,
       SERVERPROPERTY('LicenseType') AS PropertyValue,
       'Type of licensing for the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'MachineName' AS MyType,
       SERVERPROPERTY('MachineName') AS PropertyValue,
       'Windows computer name on which the server instance is running' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'NumLicenses' AS MyType,
       SERVERPROPERTY('NumLicenses') AS PropertyValue,
       'Number of licenses for the current instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'PathSeparator' AS MyType,
       SERVERPROPERTY('PathSeparator') AS PropertyValue,
       'Operating system-dependent network path delimiter' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ProcessID' AS MyType,
       SERVERPROPERTY('ProcessID') AS PropertyValue,
       'Operating system process ID of the SQL Server service' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ProductBuild' AS MyType,
       SERVERPROPERTY('ProductBuild') AS PropertyValue,
       'Build number of the product' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ProductBuildType' AS MyType,
       SERVERPROPERTY('ProductBuildType') AS PropertyValue,
       'Type of build of the product' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ProductLevel' AS MyType,
       SERVERPROPERTY('ProductLevel') AS PropertyValue,
       'Level of the version of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ProductMajorVersion' AS MyType,
       SERVERPROPERTY('ProductMajorVersion') AS PropertyValue,
       'Major version of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ProductMinorVersion' AS MyType,
       SERVERPROPERTY('ProductMinorVersion') AS PropertyValue,
       'Minor version of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ProductUpdateLevel' AS MyType,
       SERVERPROPERTY('ProductUpdateLevel') AS PropertyValue,
       'Update level of the product' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ProductUpdateReference' AS MyType,
       SERVERPROPERTY('ProductUpdateReference') AS PropertyValue,
       'Reference for the product update' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ProductVersion' AS MyType,
       SERVERPROPERTY('ProductVersion') AS PropertyValue,
       'Version of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ResourceLastUpdateDateTime' AS MyType,
       SERVERPROPERTY('ResourceLastUpdateDateTime') AS PropertyValue,
       'Date and time that the resource database was last updated' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ResourceVersion' AS MyType,
       SERVERPROPERTY('ResourceVersion') AS PropertyValue,
       'Database version of the resource' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'ServerName' AS MyType,
       SERVERPROPERTY('ServerName') AS PropertyValue,
       'Name of the instance of SQL Server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'SqlCharSet' AS MyType,
       SERVERPROPERTY('SqlCharSet') AS PropertyValue,
       'SQL character set ID of the server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'SqlCharSetName' AS MyType,
       SERVERPROPERTY('SqlCharSetName') AS PropertyValue,
       'SQL character set name of the server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'SqlSortOrder' AS MyType,
       SERVERPROPERTY('SqlSortOrder') AS PropertyValue,
       'SQL sort order ID of the server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'SqlSortOrderName' AS MyType,
       SERVERPROPERTY('SqlSortOrderName') AS PropertyValue,
       'SQL sort order name of the server' AS Description
UNION ALL
SELECT 'ServerProperty' AS MyFunctionType,
       'SuspendedDatabaseCount' AS MyType,
       SERVERPROPERTY('SuspendedDatabaseCount') AS PropertyValue,
       'Number of suspended databases on the server instance' AS Description

/*
sp_helptext Example.

sp_helptext displays the definition that is used to create an object in multiple rows. 
Each row contains 255 characters of the Transact-SQL definition. 
The definition resides in the definition column in the sys.sql_modules catalog view.
https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-helptext-transact-sql?view=sql-server-ver16
*/
--Babelfish error
--'sp_helptext' is not currently supported in Babelfish
DECLARE @vTableVariable TABLE(SpText VARCHAR(MAX));
DECLARE @vStoredProcedureName VARCHAR(255) = 'spTest';
INSERT INTO @vTableVariable
EXEC sp_helptext @vStoredProcedureName;
SELECT * FROM @vTableVariable;

/*
Stored Procedure Definition

The following script prints out the body of a stored procedure.
See also sp_helptext.
*/

PRINT('Statement 11');
GO

SELECT  o.name, o.type_desc, o.create_date, o.modify_date, m.*
FROM    sys.sql_modules m LEFT OUTER JOIN
        sys.all_objects o ON m.object_id = o.object_id
WHERE   m.definition LIKE  '%myText%';


/*
Table Column Names

This script searches for schemas, tables, columns, and data types within a database.
Add the predicate logic you are searching for.
*/

PRINT('Statement 12');
GO
--sys.schemas
--sys.tables
SELECT  @@SERVERNAME AS ServerName,
        s.name AS SchemaName,
        t.name AS TableName
FROM    sys.schemas s LEFT OUTER JOIN
        sys.tables t ON s.schema_id = t.schema_id
WHERE   1=1
ORDER BY 1,2,3;

--sys.schemas
--sys.tables
--sys.columns
--sys.types
SELECT  @@SERVERNAME as ServerName,
        s.name AS SchemaName,
        t.name AS TableName,
        c.name AS ColumnName,
        ty.name as DataType
FROM    sys.schemas s LEFT OUTER JOIN
        sys.tables t ON s.schema_id = t.schema_id INNER JOIN
        sys.columns c ON t.object_id = c.object_id INNER JOIN
        sys.types ty ON ty.user_type_id = c.user_type_id
WHERE   1=1
ORDER BY 1,2,3,4;

/*----------------------------------------------------
Scott Peters
Sudoku
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL

This script uses recursion to solve a Sudoku puzzle.

*/----------------------------------------------------
PRINT('Statement 13');
GO
-------------------------------
-------------------------------
DECLARE @vBoard VARCHAR(81) = '86....3...2...1..7....74...27.9..1...8.....7...1..7.95...56....4..1...5...3....81';

-------------------------------
-------------------------------
WITH cte_Recursion(Sudoku,IndexValue) AS
(
SELECT  Sudoku,
        CHARINDEX('.',Sudoku) AS IndexValue
FROM    (VALUES(@vBoard)) AS Input(Sudoku)
UNION ALL
SELECT  CONVERT(VARCHAR(81),CONCAT(SUBSTRING(Sudoku,1,IndexValue-1),myRecursion,SUBSTRING(Sudoku,IndexValue+1,81))) AS Sudoku,
        CHARINDEX('.',CONCAT(SUBSTRING(Sudoku,1,IndexValue-1),myRecursion,SUBSTRING(Sudoku,IndexValue+1,81))) AS IndexValue
FROM    cte_Recursion INNER JOIN (VALUES('1'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9')
) AS Digits(myRecursion) ON NOT EXISTS (
                              SELECT  1
                              FROM    (VALUES(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS Positions(lp)
                              WHERE   myRecursion = SUBSTRING(Sudoku, ((IndexValue-1)/9)*9 + lp, 1) OR
                                      myRecursion = SUBSTRING(Sudoku, ((IndexValue-1)%9) + (lp-1)*9 + 1, 1) OR
                                      myRecursion = SUBSTRING(Sudoku, (((IndexValue-1)/3) % 3) * 3 + ((IndexValue-1)/27) * 27 + lp + ((lp-1) / 3) * 6, 1)
                                        )
WHERE IndexValue > 0
)
SELECT 'One long line:' AS Type, Sudoku FROM cte_Recursion WHERE IndexValue = 0 UNION
SELECT '1' AS Line, SUBSTRING(Sudoku,1,9) AS Line FROM cte_Recursion WHERE IndexValue = 0 UNION
SELECT '2' AS Type, SUBSTRING(Sudoku,10,9) AS Line FROM cte_Recursion WHERE IndexValue = 0 UNION
SELECT '3' AS Type, SUBSTRING(Sudoku,19,9) AS Line FROM cte_Recursion WHERE IndexValue = 0 UNION
SELECT '4' AS Type, SUBSTRING(Sudoku,29,9) AS Line FROM cte_Recursion WHERE IndexValue = 0 UNION
SELECT '5' AS Type, SUBSTRING(Sudoku,37,9) AS Line FROM cte_Recursion WHERE IndexValue = 0 UNION
SELECT '6' AS Type, SUBSTRING(Sudoku,46,9) AS Line FROM cte_Recursion WHERE IndexValue = 0 UNION
SELECT '7' AS Type, SUBSTRING(Sudoku,55,9) AS Line FROM cte_Recursion WHERE IndexValue = 0 UNION
SELECT '8' AS Type, SUBSTRING(Sudoku,64,9) AS Line FROM cte_Recursion WHERE IndexValue = 0 UNION
SELECT '9' AS Type, SUBSTRING(Sudoku,73,9) AS Line FROM cte_Recursion WHERE IndexValue = 0;
GO

/*
Here is the answer:

867295314
924381567
135674829
276953148
589416273
341827695
718569432
492138756
653742981
*/


PRINT('Statement 14');
GO
CREATE OR ALTER FUNCTION FnDateDiffPartsChar(@DateTime1 AS DATETIME2, @DateTime2 AS DATETIME2) 
RETURNS VARCHAR(1000)
/*----------------------------------------------------
Scott Peters
Creates the FnDateDiffPartsChar function
https://advancedsqlpuzzles.com
Last Updated: 01/12/2023
Microsoft SQL Server T-SQL

This script creates a scalar valued function that returns the difference between two datetime values,
broken down into year, month, day, hour, minute, second and nano second parts.

Example usage:
SELECT dbo.FnDateDiffPartsChar('20110619 00:00:00.0000001', '20110619 00:00:00.0000000');
SELECT dbo.FnDateDiffPartsChar('20171231', '20160101 00:00:00.0000000');
SELECT dbo.FnDateDiffPartsChar('20170518 00:00:00.0000001','20110619 00:00:00.1110000');

*/----------------------------------------------------
AS
BEGIN

    DECLARE @IntervalString VARCHAR(1000);
    DECLARE @DateTime1_Low DATETIME2;
    DECLARE @DateTime2_High DATETIME2;

    IF @DateTime1 > @DateTime2
        BEGIN
            SET @DateTime1_Low =  @DateTime2
            SET @DateTime2_High = @DateTime1
        END
    ELSE
        BEGIN
            SET @DateTime1_Low =  @DateTime1
            SET @DateTime2_High = @DateTime2
        END;

    WITH cte_DateDifference AS
    (
    SELECT
            YearDifference - SubtractionYear AS YearDifference,
            (MonthDifference - SubtractionMonth) % 12 AS MonthDifference,
            DATEDIFF(DAY, DATEADD(mm, MonthDifference - SubtractionMonth, DateTime1), [DateTime2]) - SubtractionDay AS DayDifference,
            NanoSecondDifference / CAST(3600000000000 AS BIGINT) % 60 AS HourDifference,
            NanoSecondDifference / CAST(60000000000 AS BIGINT) % 60 AS MinuteDifference,
            NanoSecondDifference / 1000000000 % 60 AS SecondDifference,
            NanoSecondDifference % 1000000000 AS NanoDifference
    FROM    (VALUES(@DateTime1_Low, 
                    @DateTime2_High,
                    CAST(@DateTime1_Low AS TIME), 
                    CAST(@DateTime2_High AS TIME),
                    DATEDIFF(yy, @DateTime1_Low, @DateTime2_High),
                    DATEDIFF(mm, @DateTime1_Low, @DateTime2_High),
                    DATEDIFF(dd, @DateTime1_Low, @DateTime2_High)
            )) AS D(DateTime1, [DateTime2], Time1, Time2, YearDifference, MonthDifference, DateDifference)
                
            CROSS APPLY
            (VALUES(CASE WHEN DATEADD(yy, YearDifference, DateTime1)  > [DateTime2] THEN 1 ELSE 0 END,
                    CASE WHEN DATEADD(mm, MonthDifference, DateTime1) > [DateTime2] THEN 1 ELSE 0 END,
                    CASE WHEN DATEADD(dd, DateDifference, DateTime1)  > [DateTime2] THEN 1 ELSE 0 END
            )) AS A1(SubtractionYear, SubtractionMonth, SubtractionDay)

            CROSS APPLY
            (VALUES (CAST(86400000000000 AS BIGINT) * SubtractionDay
                +   (CAST(1000000000 AS BIGINT) * DATEDIFF(ss, '00:00', Time2) + DATEPART(ns, Time2))
                -   (CAST(1000000000 AS BIGINT) * DATEDIFF(ss, '00:00', Time1) + DATEPART(ns, Time1))
            )) AS A2(NanoSecondDifference)
    )
    SELECT  /*YearDifference,
            MonthDifference,
            DayDifference,
            MinuteDifference,
            SecondDifference,
            NanoDifference,*/
            @IntervalString = 
            (CASE   WHEN    YearDifference <> 0 
                    THEN    CONCAT(YearDifference,'y ',MonthDifference, 'm ', DayDifference, 'd ', HourDifference, 'h ', MinuteDifference, 'm ', SecondDifference, 's ', NanoDifference, 'n') 
                    WHEN    MonthDifference <> 0 
                    THEN    CONCAT(MonthDifference, 'm ', DayDifference, 'd ', HourDifference, 'h ', MinuteDifference, 'm ', SecondDifference, 's ', NanoDifference, 'n') 
                    WHEN    DayDifference <> 0 
                    THEN    CONCAT(DayDifference, 'd ', HourDifference, 'h ', MinuteDifference, 'm ', SecondDifference, 's ', NanoDifference, 'n') 
                    WHEN    HourDifference <> 0 
                    THEN    CONCAT(HourDifference, 'h ', MinuteDifference, 'm ', SecondDifference, 's ', NanoDifference, 'n') 
                    WHEN    MinuteDifference <> 0
                    THEN    CONCAT(MinuteDifference, 'm ', SecondDifference, 's ', NanoDifference, 'n')
                    WHEN    SecondDifference <> 0 
                    THEN    CONCAT(SecondDifference, 's, ', NanoDifference, 'n')
                    WHEN    NanoDifference <> 0
                    THEN    CONCAT(NanoDifference, 'n')
                    ELSE 'Error'
                    END)
    FROM    cte_DateDifference;

    --PRINT @IntervalString;
    RETURN @IntervalString;
END;
GO

PRINT('Statement 15');
GO
CREATE FUNCTION FnDateDiffPartsTable(@DateTime1 AS DATETIME2, @DateTime2 AS DATETIME2) 
RETURNS @DateDifference TABLE (
YearDifference INT,
MonthDifference INT,
DayDifference INT,
HourDifference INT,
MinuteDifference INT,
SecondDifference INT,
NanoDifference INT
)
/*********************************************************************
Scott Peters
Creates the FnDateDiffPartsTable function
https://advancedsqlpuzzles.com
Last Updated: 01/12/2023
Microsoft SQL Server T-SQL

This script creates a table valued function that returns the difference between two datetime values,
broken down into year, month, day, hour, minute, second and nano second parts.

Example usage:
SELECT * FROM dbo.FnDateDiffPartsTable('20130518 00:00:00.0000001','20110619 00:00:00.1110000');

**********************************************************************/
AS
BEGIN

        DECLARE @DateTime1_Low DATETIME2;
        DECLARE @DateTime2_High DATETIME2;

        IF @DateTime1 > @DateTime2
            BEGIN
                SET @DateTime1_Low = @DateTime2
                SET @DateTime2_High = @DateTime1
            END
        ELSE
            BEGIN
                SET @DateTime1_Low = @DateTime1
                SET @DateTime2_High = @DateTime2
            END

        INSERT INTO @DateDifference
        SELECT
                YearDifference - SubtractionYear AS YearDifference,
                (MonthDifference - SubtractionMonth) % 12 AS MonthDifference,
                DATEDIFF(DAY, DATEADD(mm, MonthDifference - SubtractionMonth, DateTime1), [DateTime2]) - SubtractionDay AS DayDifference,
                NanoSecondDifference / CAST(3600000000000 AS BIGINT) % 60 AS HourDifference,
                NanoSecondDifference / CAST(60000000000 AS BIGINT) % 60 AS MinuteDifference,
                NanoSecondDifference / 1000000000 % 60 AS SecondDifference,
                NanoSecondDifference % 1000000000 AS NanoDifference
        FROM    (VALUES(@DateTime1_Low, 
                        @DateTime2_High,
                        CAST(@DateTime1_Low AS TIME), 
                        CAST(@DateTime2_High AS TIME),
                        DATEDIFF(yy, @DateTime1_Low, @DateTime2_High),
                        DATEDIFF(mm, @DateTime1_Low, @DateTime2_High),
                        DATEDIFF(dd, @DateTime1_Low, @DateTime2_High)
                )) AS D(DateTime1, [DateTime2], Time1, Time2, YearDifference, MonthDifference, DateDifference)
                CROSS APPLY
                (VALUES(CASE WHEN DATEADD(yy, YearDifference, DateTime1)  > [DateTime2] THEN 1 ELSE 0 END,
                        CASE WHEN DATEADD(mm, MonthDifference, DateTime1) > [DateTime2] THEN 1 ELSE 0 END,
                        CASE WHEN DATEADD(dd, DateDifference, DateTime1)  > [DateTime2] THEN 1 ELSE 0 END
                )) AS A1(SubtractionYear, SubtractionMonth, SubtractionDay)
                CROSS APPLY
                (VALUES (CAST(86400000000000 AS BIGINT) * SubtractionDay
                    +   (CAST(1000000000 AS BIGINT) * DATEDIFF(ss, '00:00', Time2) + DATEPART(ns, Time2))
                    -   (CAST(1000000000 AS BIGINT) * DATEDIFF(ss, '00:00', Time1) + DATEPART(ns, Time1))
                )) AS A2(NanoSecondDifference);

        RETURN
    END
GO


/*----------------------------------------------------------------------------------------------------------------------------
Scott Peters
Creating a Calendar Table
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL

This script creates a table-valued function called "FnReturnCalendarTable" that takes a date as input, 
and returns a table with various date-related information.

*/----------------------------------------------------------------------------------------------------------------------------
PRINT('Statement 16');
DECLARE @vInputDate DATE = GETDATE();

SELECT
         CONVERT(INT,CONVERT(VARCHAR, @vInputDate, 112)) AS DateKey
        ,CAST(CONVERT(VARCHAR, @vInputDate, 1) AS DATE) AS CalendarDate
        ,CONVERT(VARCHAR, @vInputDate, 1) AS DateStyle1
        ,CONVERT(VARCHAR, @vInputDate, 2) AS DateStyle2
        ,CONVERT(VARCHAR, @vInputDate, 3) AS DateStyle3
        ,CONVERT(VARCHAR, @vInputDate, 4) AS DateStyle4
        ,CONVERT(VARCHAR, @vInputDate, 5) AS DateStyle5
        ,CONVERT(VARCHAR, @vInputDate, 6) AS DateStyle6
        ,CONVERT(VARCHAR, @vInputDate, 7) AS DateStyle7
        ,CONVERT(VARCHAR, @vInputDate, 10) AS DateStyle10
        ,CONVERT(VARCHAR, @vInputDate, 11) AS DateStyle11
        ,CONVERT(VARCHAR, @vInputDate, 12) AS DateStyle12
        ,CONVERT(VARCHAR, @vInputDate, 23) AS DateStyle23
        ,CONVERT(VARCHAR, @vInputDate, 101) AS DateStyle101
        ,CONVERT(VARCHAR, @vInputDate, 102) AS DateStyle102
        ,CONVERT(VARCHAR, @vInputDate, 103) AS DateStyle103
        ,CONVERT(VARCHAR, @vInputDate, 104) AS DateStyle104
        ,CONVERT(VARCHAR, @vInputDate, 105) AS DateStyle105
        ,CONVERT(VARCHAR, @vInputDate, 106) AS DateStyle106
        ,CONVERT(VARCHAR, @vInputDate, 107) AS DateStyle107
        ,CONVERT(VARCHAR, @vInputDate, 110) AS DateStyle110
        ,CONVERT(VARCHAR, @vInputDate, 111) AS DateStyle111
        ,CONVERT(VARCHAR, @vInputDate, 112) AS DateStyle112
        -------------------------------------------------------------
        ,MONTH(@vInputDate)  AS CalendarMonth
        ,DATEPART(y, @vInputDate) AS CalendarDay
        ,YEAR(@vInputDate) AS CalendarYear
        ,DATEPART(ww, @vInputDate) AS CalendarWeek
        ,DATEPART(QUARTER,@vInputDate) AS CalendarQuarter
        ------------------------------------------------
        ,CAST(DATEADD(qq,DATEDIFF(qq, 0, @vInputDate),0) AS DATE) AS FirstDayOfQuarter
        ,CAST(DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @vInputDate) +1, 0)) AS DATE) AS LastDayOfQuarter
        -------------------------------------------------
        ,DATENAME(MONTH,@vInputDate) AS MonthLongName
        ,FORMAT(@vInputDate,'MMM') AS MonthShortName

        ,(CASE  WHEN MONTH(@vInputDate) IN (1,4,7,10) THEN 1
                WHEN MONTH(@vInputDate) IN (2,5,8,11) THEN 2
                WHEN MONTH(@vInputDate) IN (3,6,9,12) THEN 3 END) AS MonthOfQuarter

        --------------------------------------------------
        ,CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, @vInputDate), 0) AS DATE) AS FirstDayOfMonth
        ,EOMONTH(@vInputDate) AS LastDayOfMonth

        --------------------------------------------------
        ,DATEDIFF(WEEK, DATEADD(MONTH, DATEDIFF(MONTH, 0, @vInputDate), 0), @vInputDate) + 1 AS WeekOfMonth
        ,(DATEDIFF(dd, DATEADD(qq, DATEDIFF(qq, 0, @vInputDate), 0), @vInputDate) / 7) + 1 AS WeekOfQuarter
        --------------------------------------------------
        ,DATENAME(dw, @vInputDate) AS DayOfWeekName
        ,FORMAT(@vInputDate,'ddd') AS DayOfWeekNameShort
        ,DATEPART(dw,GETDATE()) AS DayOfWeekNumber
        ,CAST(CASE WHEN DATEPART(dw, @vInputDate) IN (2,3,4,5,6) THEN 1 ELSE 0 END AS BIT) AS IsWeekday
        ,DATEDIFF(d, DATEADD(qq, DATEDIFF(qq, 0, @vInputDate), 0), @vInputDate) + 1 AS DayOfQuarter
        ,DAY(@vInputDate) AS [DayOfMonth]
        --------------------------------------------------
        --------------------------------------------------
        --------------------------------------------------
        ,(CASE WHEN MONTH(@vInputDate) BETWEEN 10 AND 12 THEN YEAR(@vInputDate) + 1 ELSE YEAR(@vInputDate) END) AS GovtFiscalYear
        
        ,CAST(CAST(CASE WHEN MONTH(@vInputDate) BETWEEN 10 AND 12 THEN YEAR(@vInputDate) ELSE YEAR(@vInputDate) - 1 END AS VARCHAR)
                + '-10-01' AS DATE) AS GovtFiscalYearStartDate
        
        ,CAST(CAST(CASE WHEN MONTH(@vInputDate) BETWEEN 10 AND 12 THEN YEAR(@vInputDate) + 1 ELSE YEAR(@vInputDate) END AS VARCHAR)
                + '-09-30' AS DATE) AS GovtFiscalYearEndDate
        
        ,(CASE DATEPART(QUARTER,@vInputDate) WHEN 4 THEN 1 ELSE DATEPART(QUARTER,@vInputDate) + 1 END) AS GovtFiscalQuarter
        
        ,(CASE  WHEN MONTH(@vInputDate) BETWEEN 1 AND 9 THEN MONTH(@vInputDate) + 3
                        WHEN MONTH(@vInputDate) BETWEEN 10 AND 12 THEN MONTH(@vInputDate) - 9
                        END) AS GovtFiscalMonth
        ,(CASE  WHEN    YEAR(@vInputDate) % 4 <> 0 AND
                        DATEPART(y, @vInputDate) BETWEEN 1 AND 273 THEN  DATEPART(y, @vInputDate) + 92
                WHEN    YEAR(@vInputDate) % 4 <> 0 AND
                        DATEPART(y, @vInputDate) >= 274 THEN DATEPART(y, @vInputDate) - 273
                WHEN    YEAR(@vInputDate) % 4 = 0  AND
                        DATEPART(y, @vInputDate) BETWEEN 1 AND 274 THEN DATEPART(y, @vInputDate) + 92
                WHEN    YEAR(@vInputDate) % 4 = 0 AND
                        DATEPART(y, @vInputDate) >= 275 THEN DATEPART(y, @vInputDate) - 274 END) AS GovtFiscalDay
            ----------------------------------------------------------------------------------------------------
            ----------------------------------------------------------------------------------------------------
            ----------------------------------------------------------------------------------------------------
            ,(CASE  WHEN DATEPART(ISO_WEEK, @vInputDate) > 50 AND MONTH(@vInputDate) = 1 THEN YEAR(@vInputDate) - 1
                    WHEN DATEPART(ISO_WEEK, @vInputDate) = 1 AND MONTH(@vInputDate) = 12 THEN YEAR(@vInputDate) + 1
                    ELSE YEAR(@vInputDate) END) AS ISOYear
            ,DATEPART(ISO_WEEK, @vInputDate) AS ISOWeekNumber;
GO

SELECT  *
FROM    FnReturnCalendarTable(GETDATE())
