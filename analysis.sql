-- 15 Business Problems & Solutions

--Count the number of Movies vs TV Shows
SELECT 	type,
		COUNT(*) AS total_types
		--COUNT(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS Movies,
		--COUNT(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS TV_Show
FROM netflix
GROUP BY type;



--Find the most common rating for movies and TV shows
SELECT type,
		rating
FROM
(
	SELECT 	type,
			rating,
			COUNT(*),
			RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS rank_n
	FROM netflix
	GROUP BY 1, 2
)t1
WHERE rank_n = 1



--List all movies released in a specific year (e.g., 2020)
SELECT title AS movies_released_in_2020
FROM netflix
WHERE type = 'Movie'
AND 
	release_year = 2020;


--Find the top 5 countries with the most content on Netflix
SELECT 
		--- country column has multiple country names in one record
		--- so we will separate and get the unique records
		
		UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
		COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;



--Identify the longest movie
WITH cte_get_mins AS(
	SELECT 	title,
			SPLIT_PART(duration, ' ', 1)::INT AS minutes
	FROM netflix
	WHERE type = 'Movie' 
)
SELECT title , minutes
FROM cte_get_mins
WHERE minutes IS NOT NULL
ORDER BY minutes DESC
LIMIT 1;


--Find content added in the last 5 years
SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


--Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT type,
		title AS content_by_Rajiv_Chilaka
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';



--List all TV shows with more than 5 seasons
WITH cte_split_duration AS
(
	SELECT title AS tv_shows_with_morethan_5seasons,
			SPLIT_PART(duration, ' ', 1)::INT AS season_num
	FROM netflix
	WHERE type = 'TV Show'
)
SELECT * 
FROM cte_split_duration
WHERE season_num > 5;



--Count the number of content items in each genre
SELECT 	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
		COUNT(*) AS total_content
FROM netflix
GROUP BY 1



--Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD,YYYY')) AS Year,
	COUNT(*) AS total_content,
	ROUND((COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM netflix WHERE country LIKE '%India%')::NUMERIC*100.0), 2) AS avg_content_by_year
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1
ORDER BY 1




--List all movies that are documentaries
SELECT *
FROM netflix
WHERE
	type = 'Movie'
	AND
	listed_in ILIKE '%documentaries%'



--Find all content without a director
SELECT * 
FROM netflix
WHERE director IS NULL;



--Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT *
FROM netflix
WHERE type = 'Movie' 
	  AND
	  release_year >= EXTRACT(YEAR FROM (CURRENT_DATE - INTERVAL '10 YEARS'))
	  AND
	  "cast" ILIKE '%Salman Khan%'
	  



-- Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT UNNEST(STRING_TO_ARRAY("cast", ',')) AS actor,
	   COUNT(*) AS movie_count	
FROM netflix
WHERE type = 'Movie'
AND   country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;




/*Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
  Label content containing these keywords as 'Bad' and all other content as 'Good'. 
  Count how many items fall into each category.
*/

SELECT content_category,
	   COUNT(*) 
FROM(
	SELECT 
	CASE
		WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad' ELSE 'Good'
		END AS content_category
FROM netflix
)t1
GROUP BY 1







