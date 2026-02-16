This is a data cleaning project in MYSQL 
The raw data for this project were data on employee layoffs by different companies in different countries.

Started by first creating a table to avoid working on the original raw data and hence interfering with it.
Then I removed duplicates by: Used the window function ROW_NUMBER() to find the duplicate values.
                             -Filtering with CTES
                             -Then deleted the duplicate rows

Standardized the data - Used TRIM() to remove whitespaces in the company column
                      -Used UPDATE to update the trims in the table
                      -Converted the dates from text to DATE using STR_TO_DATE()
                      -Used TRAILING to remove a fullstop in one of the country names (United States)
                      -Used ALTER TABLE to modify the date to DATE 

Worked on the null values - Used self joins to fill in the missing values of the industry where they had similar companies and location
                          -Updated the blank spaces to NULLS
                          -Deleted the data with blank percentage_laid_off

Removed unnecessary columns - This was the row_num column that is now not very useful.Used ALTER TABLE then dropped the table.
