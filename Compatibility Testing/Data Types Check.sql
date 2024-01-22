DROP TABLE IF EXISTS #AllDataTypesExample;
GO

CREATE TABLE #AllDataTypesExample (
    ID INT PRIMARY KEY,
    SampleUniqueIdentifier1 UNIQUEIDENTIFIER DEFAULT NEWID() ROWGUIDCOL,--syntax error near 'ROWGUIDCOL' at line 4 and character position 58
    SampleUniqueIdentifier2 UNIQUEIDENTIFIER DEFAULT NEWID(),
    SampleUniqueIdentifier3 UNIQUEIDENTIFIER,
    SampleBit BIT,
    SampleInt INT,
    SampleTinyInt TINYINT,
    SampleSmallInt SMALLINT,
    SampleBigInt BIGINT,
    SampleNumeric NUMERIC(18, 0),
    SampleDecimal DECIMAL(10, 2),    
    SampleSmallMoney SMALLMONEY,    
    SampleMoney MONEY,
    SampleFloat FLOAT,
    SampleReal REAL,
    SampleDate DATE,
    SampleTimeOfDay TIME,
    SampleDateTime DATETIME,
    SampleDateTime2 DATETIME2,
    SampleDateTimeOffset DATETIMEOFFSET,
    SampleSmallDateTime SMALLDATETIME,
    SampleChar CHAR(10),
    SampleVarChar VARCHAR(50),
    SampleText TEXT,
    SampleNChar NCHAR(10),
    SampleNVarChar NVARCHAR(50),
    SampleNText NTEXT,
    SampleBinary BINARY(50),
    SampleVarBinary VARBINARY(50),
    SampleImage IMAGE,
    SampleUniqueIdentifier UNIQUEIDENTIFIER,
    SampleXml XML,
    SampleSqlVariant SQL_VARIANT,
    SampleGeometry GEOMETRY,  --type "geometry" does not exist
    SampleGeography GEOGRAPHY  --type "geography" does not exist
);
