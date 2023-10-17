-- Q1. How much did movies cost per minute?

SELECT
	title,
    budget,
    runtime,
	budget DIV runtime AS budget_per_minute
FROM movies.movie
ORDER BY budget_per_minute DESC

-- Q2.	What is the top-5 movies in terms of budget?

SELECT title, budget
FROM movies.movie
ORDER BY budget DESC
LIMIT 5;

-- Q3.	In terms of release date, how old is every single movie? Show the top-10 Youngest movies.

SELECT
	title,
    release_date,
    (YEAR(curdate()) - YEAR(release_date)) AS age
FROM movies.movie
ORDER BY age ASC
LIMIT 10;

-- Q4.	List movie titles, respective producers and year.

USE movies;
SELECT
	m.title,
    YEAR(m.release_date) AS movie_year,
    mc.job, 
    p.person_name
   FROM movie m
	INNER JOIN movie_crew mc 
		ON  m.movie_id = mc.movie_id
	INNER JOIN person p
		ON mc.person_id = p.person_id 
WHERE mc.department_id = 3 AND mc.job = 'Producer'
ORDER BY movie_year DESC;

-- Q5. Which movies cost less than 50,000 and what were their genres and year of release? Just top-50

USE movies;
SELECT
	m.title,
    g.genre_name,
    YEAR(m.release_date) AS release_year,
    m.budget
FROM movie m
	JOIN movie_genres mg
		ON m.movie_id = mg.movie_id
	JOIN genre g
		ON g.genre_id = mg.genre_id
WHERE budget < 50000
ORDER BY m.budget DESC
LIMIT 50;

-- Q6. Which were the bottom 20 less popular movies and what company produced them?

USE movies;
SELECT
	m.title, m.popularity, pc.company_name
FROM movie m
	JOIN movie_company mc
		ON m.movie_id = mc.movie_id
	JOIN production_company pc
    	ON mc.company_id = pc.company_id
ORDER BY m.popularity ASC
LIMIT 20;

-- Q7.	Which movie companies invested the budget between 150K to 200K and for which movie?

USE movies;
SELECT pc.company_name, mc.movie_id, mc.company_id, m.title, m.budget
FROM movie m
	JOIN movie_company mc
		ON m.movie_id = mc.movie_id
	JOIN production_company pc
		ON mc.company_id = pc.company_id
WHERE m.budget BETWEEN 150000 AND 200000
ORDER BY m.budget DESC;

-- Q8. Make a list of actors who played after the year 2010.

USE movies;
SELECT m.title, p.person_name
FROM movie m
	JOIN movie_crew mc ON m.movie_id = mc.movie_id
	JOIN person p ON p.person_id = mc.person_id
WHERE mc.job = 'Characters' AND m.release_date > '2010-01-01'
GROUP BY p.person_name, m.title, mc.job;    