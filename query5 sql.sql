-- Outputting the whole world_layoffs table - RAW DATA
SELECT*
FROM layoffs
;

-- Creating another table from the world_layoffs table.To avoid inteferring with my raw data. 
CREATE TABLE layoff_staging4
LIKE  layoffs
;
 
-- I realized that it only selects the column titles so I have to insert the rest of the data below.
SELECT*
FROM layoff_staging4
;

-- inserting the raw data into the table I have created.
INSERT layoff_staging4
SELECT*
FROM layoffs
;

-- REMOVING DUPLICATES
SELECT*,
ROW_NUMBER() OVER(PARTITION BY company,
location,industry,
total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions ORDER BY company DESC) AS row_num
FROM layoff_staging4
;

WITH duplicate_cte AS 
(
SELECT*,
ROW_NUMBER() OVER(PARTITION BY company,
location,industry,
total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions ORDER BY company DESC) AS row_num
FROM layoff_staging4
)
SELECT*
FROM duplicate_cte
WHERE row_num > 1
;


-- Making sure that indeed there are duplicates
SELECT*
FROM layoff_staging4
WHERE company = 'cazoo'
;

-- DELETE statement
DELETE
FROM duplicate_cte
where row_num > 1
;
-- DELETE is an update statement.You cannot update a CTE.
-- so we create another table to delete the duplicates.

CREATE TABLE `layoff_staging5` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT*
FROM layoff_staging5
;

-- Inserting the raw data into the new table layoff_staging5.
INSERT INTO layoff_staging5
SELECT*,
ROW_NUMBER() OVER(PARTITION BY company,
location,industry,
total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions ORDER BY company DESC) AS row_num
FROM layoff_staging4
;

-- Deleting the duplicate rows.
DELETE
FROM layoff_staging5
WHERE row_num > 1
;




-- STANDARDIZING  the data

-- Removing white spaces using TRIM()
SELECT company,TRIM(company)
FROM layoff_staging5
;

-- Updating the changes to the table.
UPDATE layoff_staging5
SET company = TRIM(company)
;

SELECT*
FROM layoff_staging5
WHERE industry LIKE 'crypto%'
;

UPDATE layoff_staging5
SET industry = 'crypto'
WHERE industry LIKE 'crypto%'
;

SELECT*
FROM layoff_staging5
WHERE country LIKE 'United States%'
;

UPDATE layoff_staging5
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'
;

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoff_staging5
; 

UPDATE layoff_staging5
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y')
;

-- changing the data type of date from text to DATE.
ALTER TABLE layoff_staging5
MODIFY `date` DATE
;


-- WORKING WITH NULL VALUES

UPDATE layoff_staging5
SET industry = NULL
WHERE industry = '';

SELECT*
FROM layoff_staging5
WHERE location = 'SF Bay Area' AND company ='Juul'
;

SELECT*
FROM layoff_staging5
WHERE industry ='NULL' OR industry = ''
;

SELECT t1.industry,t2.industry
FROM layoff_staging5 t1
JOIN layoff_staging5 t2
   ON t1.company = t2.company
   AND t1.location = t2.location
   WHERE t1.industry IS NULL 
   AND t2.industry IS NOT NULL
   ;
   
UPDATE layoff_staging5 t1
JOIN layoff_staging5 t2
   ON t1.company = t2.company
   SET t1.industry=t2.industry
   WHERE t1.industry IS NULL 
   AND t2.industry IS NOT NULL
;


SELECT*
FROM layoff_staging5
-- WHERE total_laid_off ='NULL'
-- WHERE percentage_laid_off = 'NULL'
;


ALTER TABLE layoff_staging5
DROP COLUMN row_num
;


