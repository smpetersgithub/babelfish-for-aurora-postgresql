# -*- coding: utf-8 -*-
"""
SQL Slueth

This script searches for SQL keywords in a specified file and counts their occurrences.
The keywords are defined in a configuration file.

Instructions:
- Set 'config_file' to the path of your configuration file (e.g., 'configuration.txt').
- Set 'input_file' to the path of the SQL file you want to analyze.
- If the output file shows all zeros, you may have an encoding issue. Try copying the
  content into a new text file, especially if the original file was created in SSMS.
- To test, run the script with the configuration file path for both 'config_file' and 'input_file'.
"""

def load_keywords(file_path):
    """Load keywords from the specified configuration file."""
    with open(file_path, 'r') as file:
        return [line.strip() for line in file.readlines()]

def search_keywords(sql_file, keywords):
    """Count occurrences of each keyword in the specified SQL file."""
    with open(sql_file, 'r') as file:
        content = file.read().upper()  # Perform a case-insensitive search
    return {keyword: content.count(keyword.upper()) for keyword in keywords}

def output_results(output_file, counts):
    """Write the keyword counts to the specified output file."""
    with open(output_file, 'w') as file:
        for keyword, count in counts.items():
            file.write(f"{keyword}, {count}\n")

def main(config_file, sql_file):
    """Run the keyword search and output the results."""
    keywords = load_keywords(config_file)
    counts = search_keywords(sql_file, keywords)
    output_file = f"{sql_file.split('.')[0]}_output.txt"
    output_results(output_file, counts)
    print(f"Output written to {output_file}")

# Paths for the configuration and SQL files
# To test, set the input_file variable to the configuration file.
config_file = r'C:\BabelfishCompass\KeywordUtility\configuration.txt'  # Update with your configuration file path
input_file = r'C:\BabelfishCompass\KeywordUtility\configuration.txt'  # Update with your SQL file path

# Execute the main function
if __name__ == "__main__":
    main(config_file, input_file)
