/********************************************************************

Creating a deadlock in SQL Server involves having two or 
more sessions where each session holds a lock on a resource 
and attempts to acquire a lock on a resource held by another 
session. To demonstrate this, we can use two T-SQL scripts, 
each running in a separate session in SQL Server Management Studio (SSMS).

********************************************************************/


--Babelfish does not support global temporary tables!
DROP TABLE IF EXISTS DeadlockExample;
GO

CREATE TABLE DeadlockExample 
(
id        INTEGER IDENTITY(1,1) PRIMARY KEY,
myStatus  VARCHAR(100) DEFAULT 'Unknown'
);
GO

--Babelfish does not support `INSERT INTO <myTable> DEFAULT VALUES;`
INSERT INTO DeadlockExample (myStatus) VALUES('Unknown');
INSERT INTO DeadlockExample (myStatus) VALUES('Unknown');
INSERT INTO DeadlockExample (myStatus) VALUES('Unknown');
GO

SELECT * FROM DeadlockExample;

----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
--Session 1
--Session 1
--Session 1
--Session 1
BEGIN TRANSACTION;

-- Update the first row in #DeadlockExample
UPDATE  DeadlockExample
SET     myStatus = 'Complete'
WHERE   id = 1;

WAITFOR DELAY '00:00:05'; -- Wait for 5 seconds

-- Attempt to update the second row in #DeadlockExample
UPDATE  DeadlockExample
SET     myStatus = 'Complete'
WHERE   id = 2;

COMMIT TRANSACTION;

--Check to see if you have an open transaction!
PRINT(@@TRANCOUNT);
SELECT * FROM DeadlockExample;
RETURN

----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
--Session 2
--Session 2
--Session 2
--Session 2
--Copy to a new session
--Copy to a new session
--Copy to a new session

--Transaction (Process ID 55) was deadlocked on lock resources with another process and has been chosen as the deadlock victim. Rerun the transaction.
BEGIN TRANSACTION;

-- Update the second row in #DeadlockExample
UPDATE  DeadlockExample
SET     myStatus = 'Complete'
WHERE   id = 2;

WAITFOR DELAY '00:00:05'; -- Wait for 5 seconds

-- Attempt to update the first row in #DeadlockExample
UPDATE  DeadlockExample
SET     myStatus = 'Complete'
WHERE   id = 1;

COMMIT TRANSACTION;

--Check to see if you have an open transaction!
PRINT(@@TRANCOUNT);

