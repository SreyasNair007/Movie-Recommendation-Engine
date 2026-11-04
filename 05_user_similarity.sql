USE movie_recommendation;

-- User similarity based on movies both users have rated.
-- Smaller average_rating_difference means more similar rating behaviour.
-- This self-join can be resource-intensive on a large dataset.
SELECT
    r1.user_id AS user_1,
    r2.user_id AS user_2,
    COUNT(*) AS common_movies,
    ROUND(AVG(ABS(r1.rating - r2.rating)), 2) AS average_rating_difference,
    ROUND(1 / (1 + AVG(ABS(r1.rating - r2.rating))), 4) AS similarity_score
FROM Ratings r1
JOIN Ratings r2
  ON r1.movie_id = r2.movie_id
 AND r1.user_id < r2.user_id
GROUP BY r1.user_id, r2.user_id
HAVING COUNT(*) >= 20
ORDER BY similarity_score DESC, common_movies DESC
LIMIT 100;

-- Similar users for a selected user
SET @target_user_id = 1;

SELECT
    r2.user_id AS similar_user_id,
    COUNT(*) AS common_movies,
    ROUND(AVG(ABS(r1.rating - r2.rating)), 2) AS average_rating_difference,
    ROUND(1 / (1 + AVG(ABS(r1.rating - r2.rating))), 4) AS similarity_score
FROM Ratings r1
JOIN Ratings r2 ON r1.movie_id = r2.movie_id
WHERE r1.user_id = @target_user_id
  AND r2.user_id <> @target_user_id
GROUP BY r2.user_id
HAVING COUNT(*) >= 10
ORDER BY similarity_score DESC, common_movies DESC
LIMIT 20;
