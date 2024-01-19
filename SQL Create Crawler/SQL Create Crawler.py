
import re

def find_create_statements(sql_file_path, log_file_path, insert_file_path, encoding='utf-8'):
    create_types = [
        "CREATE TYPE", "CREATE TABLE", "CREATE USER", "CREATE LOGIN", 
        "CREATE VIEW", "CREATE FUNCTION", "CREATE SYNONYM", "CREATE DATABASE",
        "CREATE PROCEDURE", "CREATE INDEX", "CREATE SCHEMA", "CREATE SEQUENCE",
        "CREATE TRIGGER", "CREATE MATERIALIZED VIEW", "CREATE CONSTRAINT",
        "CREATE TEMPORARY TABLE", "CREATE DATABASE LINK", "CREATE DIRECTORY",
        "CREATE EXTENSION", "CREATE COLLATION", "CREATE DOMAIN"
    ]

    try:
        with open(sql_file_path, 'r', encoding=encoding) as sql_file:
            lines = sql_file.readlines()

        parsed_statements = []
        insert_statements = []
        for line in lines:
            if any(line.strip().startswith(create_type) for create_type in create_types):
                match = re.search(r'\[(.*?)\](?:\.\[(.*?)\])?', line)
                if match:
                    object_name = '.'.join(filter(None, match.groups()))
                    object_type = line.strip().split()[1].lower()
                    parsed_statements.append(f"{object_type}, {object_name}")
                    insert_statement = f"insert into #myObjects (type, object) values ('{object_type}','{object_name}');"
                    insert_statements.append(insert_statement)

        if not parsed_statements:
            print("No specified 'CREATE' statements found in the file.")
            return

        with open(log_file_path, 'w', encoding=encoding) as log_file:
            log_file.write("Type, Object\n")
            for statement in parsed_statements:
                log_file.write(statement + '\n')

        with open(insert_file_path, 'w', encoding=encoding) as insert_file:
            for statement in insert_statements:
                insert_file.write(statement + '\n')

        print(f"Specified CREATE statements have been written to {log_file_path}")
        print(f"INSERT statements have been written to {insert_file_path}")

    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage
sql_file_path = r'C:\BabelfishCompass\SQLCreateCrawler\test.sql'
log_file_path = r'C:\BabelfishCompass\SQLCreateCrawler\logfile.txt'
insert_file_path = r'C:\BabelfishCompass\SQLCreateCrawler\inserts.sql'
find_create_statements(sql_file_path, log_file_path, insert_file_path, encoding='utf-8')
