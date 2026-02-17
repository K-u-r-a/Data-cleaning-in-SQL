-- EXPLORATORY DATA ANALYSIS
SELECT*
FROM layoff_staging5
;

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoff_staging5
;
-- the maximum number of people laid off in a day is 12000.
-- the maximum percentage layoff is 1, meaning the company completely closed.


SELECT country,SUM(total_laid_off)
FROM layoff_staging5
GROUP BY country
ORDER BY 2 DESC
;
-- United states had the highest number of layoffs


SELECT MIN(`date`),MAX(`date`)
FROM layoff_staging5
;
-- Looks like the layoffs happened between 2020 when the pandemic hit and 2023.

SELECT industry,SUM(total_laid_off)
FROM layoff_staging5
GROUP BY industry
ORDER BY 2 DESC
;
-- Looks like the consumer and retail industries got hit really hard since the shops had to close down 
-- during the pandemic.


SELECT YEAR(`date`),SUM(total_laid_off)
FROM layoff_staging5
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;
-- the highest number of layoffs happened in 2022


SELECT stage,SUM(total_laid_off)
FROM layoff_staging5
GROUP BY stage
ORDER BY 2 DESC
;
-- The POST-IPO stages(this is for companies like Google,Amazon) had the highest layoffs.

SELECT stage, AVG(percentage_laid_off) AS avg_percentage
FROM layoff_staging5
GROUP BY stage
ORDER BY avg_percentage DESC
;
-- The seed stage had the highest layoff followed by the early series stages.



SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off) 
FROM layoff_staging5
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 DESC
;

WITH  Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off) AS total_off
FROM layoff_staging5
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY  SUBSTRING(`date`,1,7)
ORDER BY 1 ASC
)
SELECT `MONTH`,
total_off,
SUM(total_off)OVER(ORDER BY `MONTH`) AS  rolling_total
FROM Rolling_Total
;
-- It seems 2021 was a good year since few people were laid off compared to other years.

WITH company_year(company,years,total_laid_off)
AS
(
SELECT company, YEAR(`date`),SUM(total_laid_off)
FROM layoff_staging5
GROUP BY company, YEAR(`date`)
),Company_Year_Rank AS
 (SELECT*, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT*
FROM Company_Year_Rank
WHERE ranking <= 5
;