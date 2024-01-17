USE schemaname;
GO

---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
-- Check the current database collation
SELECT DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS DatabaseCollation;
GO

SELECT  name AS DatabaseName, 
        collation_name AS DatabaseCollation
FROM    sys.databases;
GO

---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

-- Check the collation of a column
SELECT  name, collation_name 
FROM    sys.columns 
WHERE   name = N'<insert character data type column name>';
GO

-- Check the collation of a table and column
SELECT t.name AS TableName, 
       c.name AS ColumnName, 
	   collation_name  
FROM   sys.columns c INNER JOIN 
       sys.tables t ON c.object_id = t.object_id;
GO

---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

--Retrieve a list of all the valid collation names 
--for Windows collations and SQL Server collations.
SELECT  name, 
        description
FROM    fn_helpcollations();
GO

--52 Latin collations
SELECT  name, 
        description
FROM    fn_helpcollations()
WHERE   name LIKE 'Latin%';
GO
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
--Test collation
--Modify the WHERE and ORDER BY clauses as needed
WITH cte_Values AS
(
SELECT  *
FROM    (VALUES('test'),('Test'),('TEST')) tbl1(a)
)
SELECT  * 
FROM    cte_Values
--WHERE   a = 'Test'
ORDER BY 1;
GO

