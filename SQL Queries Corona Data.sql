-- To avoid any errors, check missing value / null value 

-- Q1. Write a code to check NULL values

SELECT * 
FROM corona_dataset
WHERE Province IS NULL OR
      Country_Region IS NULL OR
      Latitude IS NULL OR
      Longitude IS NULL OR
      Date IS NULL OR
      Confirmed IS NULL OR
      Deaths IS NULL OR
      Recovered IS NULL;

--Q2. If NULL values are present, update them with zeros for all columns.

-- No Null/missing Values are present in the given dataset.
-- If missing values are present, then below query can be used to replace missing values with default values:

UPDATE corona_dataset
SET 
    Province = COALESCE(Province, 'Not Available'),
    Country_Region = COALESCE(Country_Region, 'Not Available'),
    Latitude = COALESCE(Latitude, 0.0),
    Longitude = COALESCE(Longitude, 0.0),
    Date = COALESCE(Date, '1970-01-01'::DATE),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);
	
	
-- Q3. Check total number of rows

SELECT COUNT(*) AS total_rows
FROM corona_dataset; 


-- Q4. Check what is start_date and end_date

SELECT MIN(Date) AS start_date, MAX(Date) AS end_date
FROM corona_dataset;


-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT EXTRACT(MONTH FROM Date)) AS number_of_months
FROM corona_dataset

SELECT EXTRACT(MONTH FROM date) AS month_number, COUNT(*) as month_count
FROM corona_dataset
GROUP BY month_number
ORDER BY month_number;


-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT 
	EXTRACT(YEAR FROM Date) AS year_num,
	EXTRACT(MONTH FROM Date) AS month_num,
	ROUND(AVG(Confirmed),2) AS confirmed_avg, 
	ROUND(AVG(Deaths),2) AS deaths_avg,
	ROUND(AVG(Recovered),2) AS recovered_avg
FROM corona_dataset
GROUP BY year_num, month_num
ORDER BY year_num, month_num ASC;


-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

WITH FrequentValues AS (
    SELECT
        EXTRACT(MONTH FROM Date) as month_num,
        EXTRACT(YEAR FROM Date) as year_num,
        Confirmed,
        Deaths,
        Recovered,
        RANK() OVER (PARTITION BY EXTRACT(MONTH FROM Date), EXTRACT(YEAR FROM Date) ORDER BY COUNT(*) DESC) as rank
    FROM
        corona_dataset
    GROUP BY
        EXTRACT(MONTH FROM Date), EXTRACT(YEAR FROM Date), Confirmed, Deaths, Recovered
)
SELECT
    month_num,
    year_num,
    Confirmed,
    Deaths,
    Recovered
FROM
    FrequentValues
WHERE
    rank = 1
ORDER BY
    year_num, month_num ASC;


-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
	EXTRACT(YEAR FROM Date) AS year_num,
	MIN(Confirmed) AS min_confirmed,
	MIN(Deaths) AS min_deaths,
	MIN(Recovered) AS min_recovered
FROM corona_dataset
GROUP BY year_num
ORDER BY year_num ASC;


-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
	EXTRACT(YEAR FROM Date) AS year_num,
	MAX(Confirmed) AS max_confirmed,
	MAX(Deaths) AS max_deaths,
	MAX(Recovered) AS max_recovered
FROM corona_dataset
GROUP BY year_num
ORDER BY year_num ASC;

-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT 
	EXTRACT(YEAR FROM Date) AS year_num,
	EXTRACT(MONTH FROM Date) AS month_num,
	SUM(Confirmed) AS total_confirmed,
	SUM(Deaths) AS total_deaths,
	SUM(Recovered) AS total_recovered
FROM corona_dataset
GROUP BY year_num, month_num
ORDER BY year_num, month_num ASC;

-- Q11. Check how corona virus spread out with respect to confirmed case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
	EXTRACT(YEAR FROM Date) AS year_num,
	EXTRACT(MONTH FROM Date) AS month_num,
	SUM(Confirmed) AS total_confirmed,
	ROUND(AVG(Confirmed),2) AS avg_confirmed,
	ROUND(VARIANCE(Confirmed),2) AS variance_confirmed,
	ROUND(STDDEV(Confirmed),2) AS standard_dev_confirmed
FROM corona_dataset
GROUP BY year_num, month_num
ORDER BY year_num, month_num ASC;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total death cases, their average, variance & STDEV )

SELECT 
    EXTRACT(YEAR FROM Date) AS year_num,
	EXTRACT(MONTH FROM Date) AS month_num,
	SUM(Deaths) AS total_deaths,
	ROUND(AVG(Deaths),2) AS avg_deaths,
	ROUND(VARIANCE(Deaths),2) AS variance_deaths,
	ROUND(STDDEV(Deaths),2) AS standard_dev_deaths
FROM corona_dataset
GROUP BY year_num, month_num
ORDER BY year_num, month_num ASC;


-- Q13. Check how corona virus spread out with respect to recovered case per month
--      (Eg.: total recovered cases, their average, variance & STDEV )

SELECT 
    EXTRACT(YEAR FROM Date) AS year_num,
	EXTRACT(MONTH FROM Date) AS month_num,
	SUM(Recovered) AS total_recovered,
	ROUND(AVG(Recovered),2) AS avg_recovered,
	ROUND(VARIANCE(Recovered),2) AS variance_recovered,
	ROUND(STDDEV(Recovered),2) AS standard_dev_recovered
FROM corona_dataset
GROUP BY year_num, month_num
ORDER BY year_num, month_num ASC;


-- Q14. Find Country having highest number of the Confirmed case

SELECT 
	Country_Region,
	SUM(Confirmed) AS Total_Confirmed_Cases
FROM corona_dataset
GROUP BY Country_Region
ORDER BY Total_confirmed_cases DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case

WITH rankingCountry AS (
    SELECT
        Country_region AS Country,
        SUM(Deaths) AS Total_Deaths_Reported,
        RANK() OVER(ORDER by SUM(Deaths) ASC) AS Rank_no
    FROM
        corona_dataset
    GROUP BY
        Country
)
SELECT 
	Country,
	Total_Deaths_Reported
FROM 
	RankingCountry
WHERE 
    rank_no = 1;

-- Q16. Find top 5 countries having highest recovered case

SELECT 
	Country_Region,
	SUM(Recovered) AS total_recovered_cases
FROM corona_dataset
GROUP BY Country_Region
ORDER BY total_recovered_cases DESC
LIMIT 5;