-- Create the database
-- CREATE DATABASE IF NOT EXISTS tunefy;
SELECT 'CREATE DATABASE tunefy' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'tunefy')\gexec

-- Connect to the database
\c tunefy;

-- Create the merged_songs table
CREATE TABLE IF NOT EXISTS merged_songs (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),
    song_name VARCHAR(255),
    artist_name VARCHAR(255),
    popularity INT,
    votes INT
);

-- Create the top_songs table
CREATE TABLE IF NOT EXISTS top_songs (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),
    song_name VARCHAR(255),
    artist_name VARCHAR(255),
    popularity INT
);

-- Insert random data into merged_songs table
INSERT INTO merged_songs (user_id, song_name, artist_name, popularity, votes) VALUES
    ('diego', 'Song1', 'Artist1', 100, 5),
    ('carlos', 'Song2', 'Artist2', 95, 1),
    ('pedro', 'Song3', 'Artist3', 90, 3),
    ('juan', 'Song4', 'Artist4', 85, 3);

-- Insert random data into top_songs table
INSERT INTO top_songs (user_id, song_name, artist_name, popularity) VALUES
    ('diego', 'TopSong1', 'TopArtist1', 98),
    ('carlos', 'TopSong2', 'TopArtist2', 96),
    ('pedro', 'TopSong3', 'TopArtist3', 94),
    ('juan', 'TopSong4', 'TopArtist4', 92);
