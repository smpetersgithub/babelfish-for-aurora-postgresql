# Babelfish Compatibility Testing

This directory includes scripts designed to evaluate compatibility between Babelfish and SQL Server.  I recommend running these scripts on both SQL Server and Babelfish for Aurora PostgreSQL, along with creating Compass reports to evaluate compatibility.

🌩️&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;I have included comments concerning any findings related to Babelfish compatibility in the scripts.  

❗&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;I recommend performing a keyword search for "Babelfish" to quickly review any errors, notes, findings, etc., in the provided scripts.

-----------

Here is a listing of files:

*  **Advanced SQL Puzzles Babelfish.sql** - This script contains 70+ puzzles that I have created.  See the [GitHub repository here](https://github.com/smpetersgithub/AdvancedSQLPuzzles/tree/main/Advanced%20SQL%20Puzzles) for more information.  This is a good starting point to test compatibility, as this script contains an assortment of solutions with varying syntax.

*  **Behavior of Nulls Babelfish.sql** - This script was modified from my [Behavior of Nulls](https://github.com/smpetersgithub/AdvancedSQLPuzzles/tree/main/Database%20Articles/Behavior%20Of%20Nulls) documentation that can be used to test Babelfish for Aurora PostgreSQL behavior of NULL markers.  When reviewing database compatibility, always check for consistency to how NULL markers behave!

*  **Babelfish Bermuda Triangle.sql** - This script contains SQL syntax that is not compatible with Babelfish.  I recommend running this script along with a Compass report and reviewing the output to understand how to best utilize the Compass report.  This file is named after the Bermuda Triangle, a place believed to have supernatural powers where a number of aircraft and ships are said to have disappeared under mysterious circumstances, often with their instruments (i.e., compasses) believed not to work.

---------------------

Please contact me with any questions or comments.

Happy coding.
