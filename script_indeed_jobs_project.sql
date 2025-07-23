/* Indeed Jobs Project
The dataset for this exercise has been derived from the Indeed Data Scientist/Analyst/Engineer dataset on kaggle.com.

Before beginning to answer questions, take some time to review the data dictionary and familiarize yourself with the data that is contained in each column.

Provide the SQL queries and answers for the following questions/tasks using the data_analyst_jobs table you have created in PostgreSQL: */

--Question 1: How many rows are in the data_analyst_jobs table?

SELECT
	COUNT(*) AS total_records
FROM
	data_analyst_jobs;

--Answer 1: 1793

--Question 2: Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?

SELECT
	*
FROM
	data_analyst_jobs
LIMIT
	10;

--Answer 2: ExxonMobil

--Question 3: How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?

SELECT
	COUNT(location) AS total_location_tn
FROM
	data_analyst_jobs
WHERE
	location = 'TN';

--Answer 3.1: 21 

SELECT
	COUNT(location) AS total_location_tn_or_ky
FROM
	data_analyst_jobs
WHERE
	location IN ('TN', 'KY');

--Answer 3.2: 27

--Question 4: How many postings in Tennessee have a star rating above 4?

SELECT
	COUNT(star_rating) total_star_rating_above_4
FROM
	data_analyst_jobs
WHERE
	location = 'TN'
	AND star_rating > 4;

--Answer 4: 3

--Question 5: How many postings in the dataset have a review count between 500 and 1000?

SELECT
	COUNT(review_count) AS review_count_500_to_1000
FROM
	data_analyst_jobs
WHERE
	review_count 
	BETWEEN 500 AND 1000;

--Answer 5: 151, assuming the count range is >=500 and <=1000; if >500 and <1000, it's 150. BETWEEN is inclusive.

--Question 6: Show the average star rating for companies in each state. The output should show the state as state and the average rating for the state as avg_rating. Which state shows the highest average rating?

SELECT
	location AS state,
	ROUND(AVG(star_rating), 2) AS avg_rating
FROM
	data_analyst_jobs
WHERE
	company IS NOT NULL
	AND star_rating IS NOT NULL
GROUP BY
	state
ORDER BY
	avg_rating DESC;

--Answer 6: NE

--Question 7: Select unique job titles from the data_analyst_jobs table. How many are there?

SELECT 
	DISTINCT title AS unique_job_titles
FROM
	data_analyst_jobs;
	
--Answer 7.1: execute query above


SELECT 
	COUNT(DISTINCT title) AS total_unique_job_titles
FROM
	data_analyst_jobs;

--Answer 7.2: 881

--Question 8: How many unique job titles are there for California companies?

SELECT
	COUNT(DISTINCT title) AS total_unique_job_titles_in_ca
FROM
	data_analyst_jobs
WHERE
	location = 'CA'
	AND company IS NOT NULL;

--Answer 8: 230

--Question 9: Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?

SELECT
	company,
	ROUND(AVG(star_rating), 2) AS avg_star_rating
FROM
	data_analyst_jobs
WHERE
	company IS NOT NULL
GROUP BY
	company
HAVING
	SUM(review_count) > 5000;

--Answer 9: 70

--Question 10: Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?

SELECT
	company,
	ROUND(AVG(star_rating), 2) AS avg_star_rating
FROM
	data_analyst_jobs
WHERE
	company IS NOT NULL
GROUP BY
	company
HAVING
	SUM(review_count) > 5000
ORDER BY
	avg_star_rating DESC;

--Answer 10: Google, 4.30

--Question 11: Find all the job titles that contain the word ‘Analyst’. How many different job titles are there?

SELECT
	DISTINCT title AS analyst_job_titles
FROM
	data_analyst_jobs
WHERE
	title ILIKE '%analyst%'
ORDER BY
	title ASC;

--Answer 11.1: execute query above

SELECT
	COUNT(DISTINCT title) AS total_analyst_job_titles
FROM
	data_analyst_jobs
WHERE
	title ILIKE '%analyst%';

--Answer 11.2: 774

--Question 12: How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?

SELECT
	DISTINCT title AS not_analyst_or_analytics_job_titles
FROM
	data_analyst_jobs
WHERE
	title NOT ILIKE '%analyst%'
	AND title NOT ILIKE '%analytics%';

--Answer 12: Tableau, see below:
/* 
"not_analyst_or_analytics_job_titles"
"PM/BA - Banking IT Risk / Ops Risk - Tableau - Up to $650/da..."
"Tableau Developer, Data Products"
"Data Visualization Specialist - Consultant (Tableau or Power..."
"Data Visualization Specialist - Consultant (Tableau or Alter..."
*/

--BONUS: You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks.
     --Disregard any postings where the domain is NULL.
     --Order your results so that the domain with the greatest number of hard to fill jobs is at the top.
     --Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4?

SELECT
	domain AS industry,
	COUNT(days_since_posting) AS total_hard_to_fill_jobs
FROM
	data_analyst_jobs
WHERE
	domain IS NOT NULL
	AND skill ILIKE '%SQL%'
	AND days_since_posting > 21
GROUP BY
	industry
ORDER BY total_hard_to_fill_jobs DESC
LIMIT 4;

--Answer BONUS: execute query above
/* 
"industry"	"total_hard_to_fill_jobs"
"Internet and Software"	62
"Banks and Financial Services"	61
"Consulting and Business Services"	57
"Health Care"	52 
*/


/* PRACTICE NOTES 
--
SELECT *
FROM data_analyst_jobs
WHERE review_count <= 500
ORDER BY review_count DESC;

SELECT *
FROM data_analyst_jobs
WHERE company IS NULL
ORDER BY company;

SELECT *
FROM data_analyst_jobs
WHERE review_count >5000;
ORDER BY company;

SELECT *
FROM data_analyst_jobs;

SELECT
	DISTINCT domain AS industry,
	COUNT(days_since_posting) AS total_hard_to_fill_jobs
FROM
	data_analyst_jobs
WHERE
	domain IS NOT NULL
	AND skill ILIKE '%SQL%'
	AND days_since_posting > 21
GROUP BY
	industry
ORDER BY num_hard_to_fill_jobs DESC;

SELECT (3*4)
*/