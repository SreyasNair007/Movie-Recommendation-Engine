# Movie Recommendation Engine Using Pure SQL

A MovieLens-based movie recommendation project built with **MySQL 8.0+** and **MySQL Workbench**. The project uses SQL for data validation, exploratory analysis, genre preferences, user similarity, collaborative filtering, and personalized recommendations.

## Project structure

| File | Purpose |
|---|---|
| `01_database_setup.sql` | Creates the database and four core tables |
| `02_data_validation.sql` | Checks row counts, missing values, duplicates, and data coverage |
| `03_exploratory_analysis.sql` | Overall metrics, popular movies, user activity, and rating trends |
| `04_genre_analysis.sql` | Genre counts, genre ratings, user preferences, and top movies by genre |
| `05_user_similarity.sql` | Finds users with similar rating behaviour |
| `06_personalized_recommendations.sql` | Generates weighted collaborative-filtering recommendations |
| `07_recommendation_procedure.sql` | Creates `GetMovieRecommendations()` stored procedure |
| `08_project_tests.sql` | Runs recommendation tests and checks already-rated movies |

## Database tables

- `Users`: user profile fields
- `Movies`: movie details
- `Ratings`: user ratings and timestamps
- `Movie_Genres`: movie-to-genre mapping

## How to run

1. Install/use MySQL 8.0 or newer and open MySQL Workbench.
2. Import the MovieLens CSV files into the matching tables. The expected column order is:
   - `Users`: `user_id, age, gender, occupation, zip_code`
   - `Movies`: `movie_id, title, release_date, video_release_date, imdb_url`
   - `Ratings`: `user_id, movie_id, rating, rating_timestamp`
   - `Movie_Genres`: `movie_id, genre`
3. Run `01_database_setup.sql` first in a fresh database. If tables already exist and contain data, back them up and compare their column definitions before running schema changes; do not drop the database.
4. Run `02_data_validation.sql` to verify imported data.
5. Run analysis scripts `03` through `06`.
6. Run `07_recommendation_procedure.sql` once to create the stored procedure.
7. Run `08_project_tests.sql` to test recommendations.

Run each file in order. Set `@target_user_id` in the analysis/recommendation scripts to change the user being analyzed.

## Important dataset note

The project work previously recorded showed 943 users, 1,565 movies, and 86,845 ratings in the database at that stage. The original MovieLens 100K dataset contains 943 users, 1,682 movies, and 100,000 ratings. Therefore, validate your current import before presenting the project as a complete 100K import. The SQL scripts operate on the records currently present in your tables.

## Recommendation method

1. Compare two users' ratings for movies both have rated.
2. Calculate average absolute rating difference.
3. Convert the difference into a similarity score: `1 / (1 + average_difference)`.
4. Estimate a candidate movie rating using a similarity-weighted average.
5. Exclude movies the target user has already rated.
6. Rank candidates by predicted rating and number of recommending users.

## Notes

- The user-similarity self-join can be computationally expensive. Run it on a working database and avoid repeatedly executing the all-pairs query.
- The recommendation score is a simple collaborative-filtering estimate, not a machine-learning model.
- If your existing tables use different column names, adjust the scripts to match them before running.
