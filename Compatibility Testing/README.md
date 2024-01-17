# Babelfish Compatibility Testing

This directory includes scripts designed to evaluate compatibility between Babelfish and SQL Server.  I recommend running these scripts on SQL Server and Babelfish for Aurora PostgreSQL and creating Compass reports to evaluate compatibility.

🌩️&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;I have included comments concerning any findings related to Babelfish compatibility in the scripts.  I recommend performing a keyword search for "Babelfish" to quickly review any errors, notes, findings, etc., in the provided scripts.

❗&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;See **Compass Commands.md** to copy and paste Compass command prompts.

-----------

Here is a listing of files:

*  **Advanced SQL Puzzles Babelfish.sql** - This script contains 70+ puzzles that I have created.  See the [GitHub repository here](https://github.com/smpetersgithub/AdvancedSQLPuzzles/tree/main/Advanced%20SQL%20Puzzles) for more information.  This is a good starting point to test compatibility, as this script contains an assortment of solutions with varying syntax.

*  **Behavior of Nulls Babelfish.sql** - This script was modified from my [Behavior of Nulls](https://github.com/smpetersgithub/AdvancedSQLPuzzles/tree/main/Database%20Articles/Behavior%20Of%20Nulls) documentation that can be used to test Babelfish for Aurora PostgreSQL behavior of NULL markers.  When reviewing database compatibility, always check for consistency in how NULL markers behave!

*  **Babelfish Bermuda Triangle.sql** - This script contains SQL syntax that is not compatible with Babelfish.  I recommend running this script along with a Compass report and reviewing the output to understand how to best utilize the Compass report.  This file is named after the Bermuda Triangle, a place believed to have supernatural powers where a number of aircraft and ships are said to have disappeared under mysterious circumstances, often with their instruments (i.e., compasses) believed not to work.

*  **Deadlock Creation** - This script can be used to check the behavior of deadlocks.
  
*  **Isolation Levels** - This script can be used to check the behavior of the different isolation levels.    
---------------------

#### Below is the output from the Babelfish Berumuda Triangle.sql vs the Compass report.     

Note that this may not be up to date, but provides a quick preview of errors encountered in an SQL script vs what is reported on the Compass report   

**Babelfish for Aurora PostgreSQL**    
```txt
1 - Adding NOT NULL constraints
Msg 33557097, Level 16, State 1, Line 28
'NOT NULL in ALTER TABLE ALTER COLUMN' is not currently supported in Babelfish
2 - UNPIVOT
Msg 33557097, Level 16, State 1, Line 98
'UNPIVOT' is not currently supported in Babelfish
3 - TOP # PERCENT
Msg 33557097, Level 16, State 1, Line 133
TOP # PERCENT is not yet supported
4 - Recursive SQL
Msg 33557097, Level 16, State 1, Line 199
recursive query "cte_permutations" column 1 has type "varchar" in non-recursive term but type text overall
5 - STRING AGG
Msg 33557097, Level 16, State 1, Line 259
The string_agg function requires 2 arguments
6 - FOREIGN KEY
Msg 33557097, Level 16, State 1, Line 333
column "integervalue" referenced in foreign key constraint does not exist
7 - INSERT/UPDATE/DELETE with CTE
Msg 33557097, Level 16, State 1, Line 389
relation "cte_duplicates" does not exist
8 - Computed Column
Msg 8134, Level 16, State 1, Line 432
division by zero
9 - GENERATE SERIES
Msg 33557097, Level 16, State 1, Line 456
syntax error near 'values' at line 6 and character position 7
10 - STRING_SPLIT
Msg 8144, Level 16, State 1, Line 502
function string_split has too many arguments specified.
11 - IS <NOT> DISTINCT FROM
Msg 33557097, Level 16, State 1, Line 583
syntax error near 'WHERE' at line 6 and character position 0
12 - NULL and VALUES keyword - Runs successfully in Babelfish, errors in SQL Server
13 - UNIQUE constraint
Msg 33557097, Level 16, State 1, Line 618
Nullable UNIQUE constraint is not supported. Please use babelfishpg_tsql.escape_hatch_unique_constraint to ignore or add a NOT NULL constraint
14 - FOREIGN KEY, UNIQUE, NOT NULL constraints
Msg 33557097, Level 16, State 1, Line 642
syntax error at or near "FOREIGN"
Msg 33557097, Level 16, State 1, Line 652
relation "child" does not exist
Msg 33557097, Level 16, State 1, Line 656
relation "child" does not exist
15 - LAG, LEAD with IGNORE NULLS
Msg 11717, Level 15, State 1, Line 685
syntax error near 'OVER' at line 13 and character position 38
16 - Global Temporary Table
Msg 33557097, Level 16, State 1, Line 707
'GLOBAL TEMPORARY TABLE' is not currently supported in Babelfish
Msg 33557097, Level 16, State 1, Line 713
'GLOBAL TEMPORARY TABLE' is not currently supported in Babelfish
17 - Merge Statement
Msg 33557097, Level 16, State 1, Line 767
'MERGE' is not currently supported in Babelfish
18 - XML data type
Msg 33557097, Level 16, State 1, Line 842
'XML NODES' is not currently supported in Babelfish
19 - ALTER statements
Msg 33557097, Level 16, State 1, Line 876
'ALTER DATABASE' is not currently supported in Babelfish
21 - READTEXT
Msg 33557097, Level 16, State 1, Line 923
'READTEXT' is not currently supported in Babelfish
22 - ROWGUIDCOL
Msg 33557097, Level 16, State 1, Line 941
syntax error near 'ROWGUIDCOL' at line 5 and character position 48
Msg 33557097, Level 16, State 1, Line 946
relation "#exampletable" does not exist
Msg 33557097, Level 16, State 1, Line 951
relation "#exampletable" does not exist
23 - $IDENTITY
Msg 33557097, Level 16, State 1, Line 983
'$IDENTITY' is not currently supported in Babelfish
```

**Compass Report**    
```txt
--------------------------------------------------------------------------------
--- SQL features 'Not Supported' in Babelfish v.3.4.0 --- (total=23/16) --------
--------------------------------------------------------------------------------
Back to Table of Contents

Note: the estimated complexity of a not-supported feature (low/medium/high) is indicated in square brackets

Aggregate functions (1/1)
  ℹ STRING_AGG() WITHIN GROUP [medium] : 1
Built-in functions (2/2)
  ℹ STRING_SPLIT(), with 3 arguments [medium] : 1
  ℹ TEXTPTR() [medium] : 1
Databases (1/1)
  ℹ ALTER DATABASE [medium] : 1
DDL (1/1)
  ℹ CREATE TABLE ##globaltmptable [high] : 1
DML (10/5)
  ℹ DELETE, WITH (Common Table Expression) as target [medium] : 1
  ℹ INSERT..DEFAULT VALUES [medium] : 5
  ℹ MERGE [medium] : 1
  ℹ SELECT TOP <number> PERCENT [medium] : 2
  ℹ SELECT..UNPIVOT [medium] : 1
Identifiers (2/1)
    Special column name $IDENTITY [medium] : 2
Operators (1/1)
    DISTINCT FROM operator [medium] : 1
Miscellaneous SQL Features (1/1)
  ℹ READTEXT [high] : 1
XML (4/3)
  ℹ XML.exist() [medium] : 1
  ℹ XML.nodes() [medium] : 1
  ℹ XML.value() [medium] : 2
```

Please contact me with any questions or comments.

Happy coding.
