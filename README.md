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


      EXPLORATORY DATA ANALYSIS
I explored the data I cleaned and found some really interesting information from the data.
          -The layoffs happened between March,2020 and March,2023. This is probably due to the corona virus pandemic.
          -The highest number of layoffs happened in 2022.
          -The maximum number of people laid off in a day by a company was 12,000.
          -Maximum percentage laid off is 1, meaning in one day there are companies that closed completely.
          -United states had the highest number of layoffs.
          - A construction company in the United states had the highest number of layoffs, followed by retails and consumers.
          -The companies in the Post-IPO stages had the highest number of total layoffs.
          -The companies in the seed stage and the early series stages had the highest number of percentage layoffs- This is because such companies have a small number of employees and when they layoff even a small number, it turns out as a large percentage.
            
                                                                                                                  -Percentages purnishes small denominators.
          -Using the rolling total I discovered that 2021 was a good year since only a few employees were laid off compared to other years.
          
          
          
