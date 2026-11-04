USE movie_recommendation;

-- Row counts
SELECT 'Users' AS table_name, COUNT(*) AS total_rows FROM Users
UNION ALL
SELECT 'Movies', COUNT(*) FROM Movies
UNION ALL
SELECT 'Ratings', COUNT(*) FROM Ratings
UNION ALL
SELECT 'Movie_Genres', COUNT(*) FROM Movie_Genres;

-- Duplicate user/movie rating pairs (should be zero because of the primary key)
SELECT user_id, movie_id, COUNT(*) AS duplicate_count
FROM Ratings
GROUP BY user_id, movie_id
HAVING COUNT(*) > 1;

-- Missing required values
SELECT
  SUM(user_id IS NULL) AS missing_user_ids,
  SUM(movie_id IS NULL) AS missing_movie_ids,
  SUM(rating IS NULL) AS missing_ratings
FROM Ratings;

-- Rating distribution
SELECT rating, COUNT(*) AS rating_count
FROM Ratings
GROUP BY rating
ORDER BY rating;

-- Orphan checks (should return zero rows when foreign keys are enforced)
SELECT r.*
FROM Ratings r
LEFT JOIN Users u ON u.user_id = r.user_id
WHERE u.user_id IS NULL;

SELECT r.*
FROM Ratings r
LEFT JOIN Movies m ON m.movie_id = r.movie_id
WHERE m.movie_id IS NULL;

-- Dataset coverage: compare actual IDs with the expected MovieLens 100K ranges.
SELECT MIN(user_id) AS min_user_id, MAX(user_id) AS max_user_id,
       COUNT(DISTINCT user_id) AS distinct_users
FROM Users;

SELECT MIN(movie_id) AS min_movie_id, MAX(movie_id) AS max_movie_id,
       COUNT(DISTINCT movie_id) AS distinct_movies
FROM Movies;
