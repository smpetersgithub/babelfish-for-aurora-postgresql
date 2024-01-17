# SQL Sleuth

SQL Sleuth is a user-friendly keyword search tool designed to scan through specified files for SQL keywords, tallying and reporting their frequency.

It's a practical way to gauge the complexity of the databases. Currently, it's set to identify around 400 keywords or phrases, which is set in the configuration.txt file.

:exclamation: It's important to note a limitation: the tool may also count instances of words found within code comments or as segments of larger words, potentially affecting the accuracy of its keyword frequency analysis.

---------
### Installation

*  Download python_script.py and the accompanying configuration file, placing them in any directory on a Windows system.    
*  The configuration file contains the keywords to search for.  Modify as needed.    
*  The output will be \<input_filename>_output.txt\    

---------
### Modifying the Python script

*  Designate the 'config_file' variable with the path of your configuration file (e.g., 'configuration.txt').
*  Assign the 'input_file' variable with the path of the SQL file you're looking to examine.

---------

:exclamation:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Encountering all zeros in the output file might indicate an encoding issue. A quick fix is to copy the content into a new text file, particularly if the original was generated in SSMS.

----------

Please contact me with any questions or comments.

Happy Coding!
