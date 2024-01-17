/*-------------------------------------------------------------------------

The READ COMMITTED and READ UNCOMMITTED transaction isolation levels 
in SQL Server control the locking and row versioning behavior of 
transactions. 

READ COMMITTED is the default isolation level in SQL Server. 
It prevents transactions from reading data that has been modified 
but not yet committed by other transactions. This prevents dirty reads.

READ UNCOMMITTED allows transactions to read data that is being modified by 
other uncommitted transactions. This can lead to dirty reads.

-----------------------------------------------------------
-----------------------------------------------------------

ALTER DATABASE smp
SET ALLOW_SNAPSHOT_ISOLATION ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- Allows dirty reads; transactions can read uncommitted data from other transactions
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;   -- Default level; prevents dirty reads by ensuring that a transaction can only read committed data
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Prevents dirty and non-repeatable reads; data read by a transaction cannot be modified by others until the transaction completes
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;     -- Highest isolation level; prevents dirty, non-repeatable, and phantom reads; ensures full isolation of the transaction
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;         -- Provides a view of the database as of the start of the transaction; uses row versioning

----------------------------------------------------------------------------*/

--Babelfish does not support global temporary tables!
DROP TABLE IF EXISTS IsolationLevelExample;
GO

CREATE TABLE IsolationLevelExample 
(
id        INTEGER IDENTITY(1,1) PRIMARY KEY,
myStatus  VARCHAR(100) DEFAULT 'Unknown'
);
GO

--Babelfish does not support `INSERT INTO <myTable> DEFAULT VALUES;`
INSERT INTO IsolationLevelExample (myStatus) VALUES('Unknown');
INSERT INTO IsolationLevelExample (myStatus) VALUES('Unknown');
INSERT INTO IsolationLevelExample (myStatus) VALUES('Unknown');
GO


SELECT * FROM IsolationLevelExample;

----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
--Session 1
--Session 1
--Session 1
--Session 1
BEGIN TRANSACTION;

-- Update a row in the table
UPDATE IsolationLevelExample
SET    myStatus = 'Processing'
WHERE  id = 1;

/*----------------------

--Run manually
--Run manually
--Run manually
COMMIT TRANSACTION;

ROLLBACK TRANSACTION;

----------------------*/

PRINT(@@TRANCOUNT);
RETURN
GO
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
--Session 2
--Session 2
--Session 2
--Session 2

--READ UNCOMMITTED
--READ UNCOMMITTED

--Modify the as needed!
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


BEGIN TRANSACTION;

-- Try to read the same row updated by Session 1
SELECT * FROM IsolationLevelExample WHERE id = 1;

COMMIT TRANSACTION;
GO

----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
--Here I set the transactions levels to test the Compass report

ALTER DATABASE smp
SET ALLOW_SNAPSHOT_ISOLATION ON;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Prevents dirty and non-repeatable reads; data read by a transaction cannot be modified by others until the transaction completes
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;     -- Highest isolation level; prevents dirty, non-repeatable, and phantom reads; ensures full isolation of the transaction
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;         -- Provides a view of the database as of the start of the transaction; uses row versioning
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- Allows dirty reads; transactions can read uncommitted data from other transactions
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;   -- Default level; prevents dirty reads by ensuring that a transaction can only read committed data
GO
