# SQL Create Crawler

## Overview
This Python utility reads a SQL file and identifies all the `CREATE` statements within it. It generates two output files:

1. **Object List File**: This file lists all the objects found in the `CREATE` statements, formatted in a way that can be easily imported into Excel for further analysis.
2. **Insert Statements File**: This file contains `INSERT INTO` statements for each object. These statements can be used to populate a table in your database, allowing you to review the objects against the information schema.

## Usage
- Place your SQL file in a known directory.
- Run the script, specifying the path to your SQL file.
- The script will generate two files:
  - A `.txt` file with a list of objects.
  - A `.sql` file with `INSERT INTO` statements for each object.

## Requirements
- Python 3.x
- Regular Expressions (re module in Python)

## Example
To use this utility, specify the path to your SQL file and the desired output paths for the two generated files:

```python
sql_file_path = 'path/to/your/sqlfile.sql'
log_file_path = 'path/to/output/logfile.txt'
insert_file_path = 'path/to/output/insertfile.sql'
find_create_statements(sql_file_path, log_file_path, insert_file_path)
