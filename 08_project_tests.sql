USE movie_recommendation;

-- Confirm that each test user exists.
SELECT user_id
FROM Users
WHERE user_id IN (1, 10, 25, 405, 13, 655, 450, 276)
ORDER BY user_id;

-- Run the stored procedure for the users used in project testing.
CALL GetMovieRecommendations(1, 10);
CALL GetMovieRecommendations(10, 10);
CALL GetMovieRecommendations(25, 10);
CALL GetMovieRecommendations(405, 10);
CALL GetMovieRecommendations(13, 10);
CALL GetMovieRecommendations(655, 10);
CALL GetMovieRecommendations(450, 10);
CALL GetMovieRecommendations(276, 10);

-- Check that a user's recommendations do not include movies already rated.
-- Replace 1 with the target user being tested.
SET @target_user_id = 1;

WITH similar_users AS (
    SELECT r2.user_id AS similar_user_id
    FROM Ratings r1
    JOIN Ratings r2 ON r1.movie_id = r2.movie_id
    WHERE r1.user_id = @target_user_id
      AND r2.user_id <> @target_user_id
    GROUP BY r2.user_id
    HAVING COUNT(*) >= 10
),
candidate_movies AS (
    SELECT DISTINCT r.movie_id
    FROM similar_users su
    JOIN Ratings r ON r.user_id = su.similar_user_id
    WHERE NOT EXISTS (
        SELECT 1 FROM Ratings ar
        WHERE ar.user_id = @target_user_id
          AND ar.movie_id = r.movie_id
    )
)
SELECT COUNT(*) AS already_rated_recommendations
FROM candidate_movies cm
JOIN Ratings r
  ON r.movie_id = cm.movie_id
 AND r.user_id = @target_user_id;
-- Expected result: 0
