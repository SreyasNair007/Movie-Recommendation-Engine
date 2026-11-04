USE movie_recommendation;

-- Number of movies in each genre
SELECT genre, COUNT(DISTINCT movie_id) AS movie_count
FROM Movie_Genres
GROUP BY genre
ORDER BY movie_count DESC;

-- Rating activity and average score by genre
SELECT mg.genre,
       COUNT(*) AS total_ratings,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM Movie_Genres mg
JOIN Ratings r ON r.movie_id = mg.movie_id
GROUP BY mg.genre
ORDER BY average_rating DESC, total_ratings DESC;

-- Genre preferences for one user. Change the user_id as required.
SET @target_user_id = 1;

SELECT mg.genre,
       COUNT(*) AS movies_rated,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM Ratings r
JOIN Movie_Genres mg ON mg.movie_id = r.movie_id
WHERE r.user_id = @target_user_id
GROUP BY mg.genre
ORDER BY average_rating DESC, movies_rated DESC;

-- Top movies within each genre
WITH genre_movie_scores AS (
    SELECT mg.genre, m.movie_id, m.title,
           COUNT(r.rating) AS rating_count,
           AVG(r.rating) AS average_rating
    FROM Movie_Genres mg
    JOIN Movies m ON m.movie_id = mg.movie_id
    JOIN Ratings r ON r.movie_id = m.movie_id
    GROUP BY mg.genre, m.movie_id, m.title
    HAVING COUNT(r.rating) >= 20
),
ranked_genres AS (
    SELECT *,
           ROW_NUMBER() OVER (
             PARTITION BY genre
             ORDER BY average_rating DESC, rating_count DESC
           ) AS genre_rank
    FROM genre_movie_scores
)
SELECT genre, movie_id, title, rating_count,
       ROUND(average_rating, 2) AS average_rating
FROM ranked_genres
WHERE genre_rank <= 5
ORDER BY genre, genre_rank;
