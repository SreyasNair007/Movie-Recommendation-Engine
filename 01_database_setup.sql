-- Movie Recommendation Engine Using Pure SQL
-- MySQL 8.0+
-- Run this first. It creates the database and core tables.
-- CREATE DATABASE IF NOT EXISTS preserves an existing database.

CREATE DATABASE IF NOT EXISTS movie_recommendation
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE movie_recommendation;

CREATE TABLE IF NOT EXISTS Users (
    user_id INT NOT NULL,
    age TINYINT UNSIGNED,
    gender CHAR(1),
    occupation VARCHAR(50),
    zip_code VARCHAR(15),
    PRIMARY KEY (user_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Movies (
    movie_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    release_date VARCHAR(20),
    video_release_date VARCHAR(30),
    imdb_url VARCHAR(500),
    PRIMARY KEY (movie_id),
    INDEX idx_movies_title (title)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Ratings (
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    rating TINYINT UNSIGNED NOT NULL,
    rating_timestamp BIGINT,
    PRIMARY KEY (user_id, movie_id),
    CONSTRAINT fk_ratings_user
      FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_ratings_movie
      FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    CONSTRAINT chk_rating_range CHECK (rating BETWEEN 1 AND 5),
    INDEX idx_ratings_movie_user (movie_id, user_id),
    INDEX idx_ratings_rating (rating)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Movie_Genres (
    movie_id INT NOT NULL,
    genre VARCHAR(50) NOT NULL,
    PRIMARY KEY (movie_id, genre),
    CONSTRAINT fk_movie_genres_movie
      FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    INDEX idx_movie_genres_genre (genre)
) ENGINE=InnoDB;

-- Optional: verify that the tables exist.
SHOW TABLES;
