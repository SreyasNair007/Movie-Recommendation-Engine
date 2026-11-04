USE movie_recommendation;

-- Overall dataset summary
SELECT
  (SELECT COUNT(*) FROM Users) AS total_users,
  (SELECT COUNT(*) FROM Movies) AS total_movies,
  (SELECT COUNT(*) FROM Ratings) AS total_ratings,
  (SELECT ROUND(AVG(rating), 2) FROM Ratings) AS overall_average_rating;

-- Most rated movies
SELECT m.movie_id, m.title, COUNT(*) AS rating_count,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM Movies m
JOIN Ratings r ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY rating_count DESC
LIMIT 20;

-- Highest-rated movies with at least 50 ratings
SELECT m.movie_id, m.title, COUNT(*) AS rating_count,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM Movies m
JOIN Ratings r ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(*) >= 50
ORDER BY average_rating DESC, rating_count DESC
LIMIT 20;

-- User activity
SELECT u.user_id, u.age, u.gender, u.occupation,
       COUNT(r.movie_id) AS movies_rated,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM Users u
LEFT JOIN Ratings r ON r.user_id = u.user_id
GROUP BY u.user_id, u.age, u.gender, u.occupation
ORDER BY movies_rated DESC
LIMIT 20;

-- Ratings by occupation
SELECT u.occupation, COUNT(*) AS total_ratings,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM Users u
JOIN Ratings r ON r.user_id = u.user_id
GROUP BY u.occupation
ORDER BY total_ratings DESC;

-- Rating counts by year (timestamps are Unix seconds)
SELECT YEAR(FROM_UNIXTIME(rating_timestamp)) AS rating_year,
       COUNT(*) AS total_ratings
FROM Ratings
WHERE rating_timestamp IS NOT NULL
GROUP BY YEAR(FROM_UNIXTIME(rating_timestamp))
ORDER BY rating_year;
