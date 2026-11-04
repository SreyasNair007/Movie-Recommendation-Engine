USE movie_recommendation;

DROP PROCEDURE IF EXISTS GetMovieRecommendations;

DELIMITER $$

CREATE PROCEDURE GetMovieRecommendations(
    IN p_target_user_id INT,
    IN p_limit INT
)
BEGIN
    -- p_limit is bounded to avoid an accidental oversized result.
    DECLARE v_limit INT DEFAULT 10;
    SET v_limit = LEAST(GREATEST(COALESCE(p_limit, 10), 1), 100);

    WITH similar_users AS (
        SELECT
            r2.user_id AS similar_user_id,
            COUNT(*) AS common_movies,
            AVG(ABS(r1.rating - r2.rating)) AS avg_rating_difference,
            1 / (1 + AVG(ABS(r1.rating - r2.rating))) AS similarity_score
        FROM Ratings r1
        JOIN Ratings r2 ON r1.movie_id = r2.movie_id
        WHERE r1.user_id = p_target_user_id
          AND r2.user_id <> p_target_user_id
        GROUP BY r2.user_id
        HAVING COUNT(*) >= 10
    ),
    candidate_scores AS (
        SELECT
            r.movie_id,
            SUM(r.rating * su.similarity_score) /
              NULLIF(SUM(su.similarity_score), 0) AS predicted_rating,
            COUNT(DISTINCT r.user_id) AS recommending_users
        FROM similar_users su
        JOIN Ratings r ON r.user_id = su.similar_user_id
        WHERE NOT EXISTS (
            SELECT 1
            FROM Ratings ar
            WHERE ar.user_id = p_target_user_id
              AND ar.movie_id = r.movie_id
        )
        GROUP BY r.movie_id
        HAVING COUNT(DISTINCT r.user_id) >= 2
    )
    SELECT
        cs.movie_id,
        m.title,
        ROUND(cs.predicted_rating, 2) AS predicted_rating,
        cs.recommending_users
    FROM candidate_scores cs
    JOIN Movies m ON m.movie_id = cs.movie_id
    ORDER BY cs.predicted_rating DESC, cs.recommending_users DESC
    LIMIT v_limit;
END$$

DELIMITER ;

-- Example calls:
-- CALL GetMovieRecommendations(1, 10);
-- CALL GetMovieRecommendations(10, 10);
