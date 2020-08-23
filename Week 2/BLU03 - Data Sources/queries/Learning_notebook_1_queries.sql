--SELECT * FROM
SELECT *
FROM   movie; 

SELECT *
FROM   oscar;  

SELECT release_date,
       original_title
FROM   movie; 

--WHERE
SELECT id,
       original_title,
       runtime
FROM   movie
WHERE  runtime = 299;

SELECT id,
       original_title,
       runtime
FROM   movie
WHERE  runtime = 299
       OR runtime = 306;
      
SELECT id,
       original_title, 
       runtime, 
       original_language
FROM   movie
WHERE  runtime > 300 
       AND original_language = 'it';
      
SELECT id,
       original_title
FROM   movie
WHERE  original_title = 'The Phantom';

--LIMIT
SELECT id,
       original_title
FROM   movie
WHERE  original_language = 'pt'
       AND runtime > 200
LIMIT  1;

--ORDER BY
SELECT id,
       original_title,
       release_date
FROM   movie
WHERE  original_language = 'pt'
ORDER  BY release_date
LIMIT  4;

SELECT id,
       original_title,
       budget
FROM   movie
WHERE  original_language = 'pt'
ORDER  BY budget DESC
LIMIT  4;

--NULL, NOT NULL
SELECT id,
       original_title,
       original_language
FROM   movie
WHERE  original_language IS NULL
LIMIT  3;

SELECT id,
       original_title,
       original_language
FROM   movie
WHERE  original_language IS NOT NULL
LIMIT  3;

--GROUP BY
SELECT original_language,
       COUNT(id)     AS total,
       AVG(runtime) AS average_runtime
FROM   movie
WHERE  original_language IS NOT NULL
GROUP  BY original_language
ORDER  BY COUNT(id) desc
LIMIT  3;

--HAVING
SELECT original_language,
       COUNT(*)     AS total_movies,
       AVG(runtime) AS average_runtime
FROM   movie
WHERE  original_language IS NOT NULL
GROUP  BY original_language
HAVING COUNT(*) < 100
ORDER  BY COUNT(*) DESC
LIMIT  3; 

--JOIN
SELECT *
FROM   movie_actor
LIMIT 2

SELECT ma.*,
       m.original_title
FROM   movie AS m
       INNER JOIN movie_actor AS ma
               ON ma.movie_id = m.id
LIMIT 3;


SELECT * 
FROM   oscar
LIMIT  3;

SELECT o.id AS oscar_id,
       o.year,
       o.movie_id,
       m.original_title 
FROM   oscar AS o
       INNER JOIN movie AS m
               ON m.id = o.movie_id
LIMIT  3;


SELECT m.id AS movie_id,
       m.original_title,
       o.id AS oscar_id,
       o.year
FROM   movie AS m
        LEFT JOIN oscar AS o
               ON m.id = o.movie_id;
              

SELECT g.name AS genre,
       COUNT(*) AS movie_count
FROM   movie AS m
       INNER JOIN movie_genre AS mg
               ON m.id = mg.movie_id
       INNER JOIN genre AS g
               ON mg.genre_id = g.id
GROUP  BY g.name
ORDER  BY COUNT(*) DESC
LIMIT  3;


--More SQL
SELECT a.name AS actor_name,
       COUNT(*) AS movie_count
FROM   actor AS a
       INNER JOIN movie_actor AS ma
               ON a.id = ma.actor_id
GROUP  BY a.name
ORDER  BY COUNT(*) desc
LIMIT  1;  

SELECT g.name AS genre_name,
       COUNT(m.id) AS n_movies,
       COUNT(DISTINCT o.id) AS n_oscars,
       AVG(m.budget / 1000) :: INT AS avg_budget_in_k_dollars,
       AVG(m.runtime) :: INT AS avg_runtime
FROM   genre AS g
       INNER JOIN movie_genre AS mg
               ON g.id = mg.genre_id
       INNER JOIN movie AS m
               ON mg.movie_id = m.id
        LEFT JOIN oscar AS o
               ON m.id = o.movie_id
GROUP  BY genre_name
ORDER  BY COUNT(DISTINCT o.id) DESC
LIMIT  3;



