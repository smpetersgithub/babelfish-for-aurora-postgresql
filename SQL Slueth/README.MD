# SQL Sleuth

SQL Sleuth is a user-friendly keyword search tool designed to scan through specified files for SQL keywords, tallying and reporting their frequency.

---------

Installation is straightforward:    
*  Download python_script.py and the accompanying configuration file, placing them in any directory on a Windows system.    
*  The configuration file contains the keywords to search for.  Modify as needed.    
*  The output will be <input filename>_output.txt    

---------

How to modify the Python script:    
*  Designate the 'config_file' variable with the path of your configuration file (e.g., 'configuration.txt').
*  Assign the 'input_file' variable with the path of the SQL file you're looking to examine.

---------

:exclamation:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Encountering all zeros in the output file might indicate an encoding issue. A quick fix is to copy the content into a new text file, particularly if the original was generated in SSMS.

----------

Please contact me with any questions and comments.

Happy Coding!
