CREATE DATABASE IF NOT EXISTS tv_series;

USE tv_series;

CREATE TABLE studios (
	name VARCHAR(50),
	website VARCHAR(50),
	address VARCHAR(50) NOT NULL,
	CONSTRAINT pk_studios PRIMARY KEY(name, website)
);

CREATE TABLE actors (
	name VARCHAR(50),
	website VARCHAR(50),
	CONSTRAINT pk_actors PRIMARY KEY(name)
);

-- "Al no haber restricción de participación, los atributos de la clave foránea admiten ser nulas"
CREATE TABLE series (
	end_date date COMMENT "Finalización de la emisión",
	start_date date COMMENT "Comienzo de la emisión",
	website VARCHAR(50),
	title VARCHAR(50),
	creator VARCHAR(50),
	studios_name VARCHAR(50),
	studios_website VARCHAR(50),
	CONSTRAINT pk_series PRIMARY KEY(title, creator),
	CONSTRAINT fk_series FOREIGN KEY(studios_name, studios_website) REFERENCES studios(name, website)
);

CREATE TABLE episodes (
	multimedia_url VARCHAR(50),
	description TEXT,
	quality_rating FLOAT,
	title VARCHAR(50),
	air_date DATE,
	season INT,
	series_title VARCHAR(50),
	series_creator VARCHAR(50),
	CONSTRAINT pk_episodes PRIMARY KEY(title, series_title, series_creator),
	CONSTRAINT fk_episodes FOREIGN KEY(series_title, series_creator) REFERENCES series(title, creator) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE characters (
	title_or_role VARCHAR(50),
	name VARCHAR(50),
	series_title VARCHAR(50),
	series_creator VARCHAR(50),
	CONSTRAINT pk_characters PRIMARY KEY(name, series_title, series_creator),
	CONSTRAINT fk_characters FOREIGN KEY(series_title, series_creator) REFERENCES series(title, creator) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE starring (
	series_title VARCHAR(50),
	series_creator VARCHAR(50),
	actors_name VARCHAR(50),
	CONSTRAINT pk_starring PRIMARY KEY(series_title, series_creator, actors_name),
	CONSTRAINT fk_starring_series FOREIGN KEY(series_title, series_creator) REFERENCES series(title, creator),
	CONSTRAINT fk_starring_actors FOREIGN KEY(actors_name) REFERENCES actors(name)
);

CREATE TABLE plays_a (
	actors_name VARCHAR(50),
	characters_name VARCHAR(50),
	characters_series_title VARCHAR(50),
	characters_series_creator VARCHAR(50),
	CONSTRAINT pk_plays_a PRIMARY KEY(actors_name, characters_name, characters_series_title, characters_series_creator),
	CONSTRAINT fk_plays_a_actors FOREIGN KEY(actors_name) REFERENCES actors(name),
	CONSTRAINT fk_plays_a_characters FOREIGN KEY(characters_name, characters_series_title, characters_series_creator) REFERENCES characters(name, series_title, series_creator)
);

CREATE TABLE featuring (
	episodes_title VARCHAR(50),
	episodes_series_title VARCHAR(50),
	episodes_series_creator VARCHAR(50),
	characters_name VARCHAR(50),
	characters_series_title VARCHAR(50),
	characters_series_creator VARCHAR(50),
	CONSTRAINT pk_featuring PRIMARY KEY(episodes_title, episodes_series_title, episodes_series_creator, characters_name, characters_series_title, characters_series_creator),
	CONSTRAINT fk_featuring_episodes FOREIGN KEY(episodes_title, episodes_series_title, episodes_series_creator) REFERENCES episodes(title, series_title, series_creator),
	CONSTRAINT fk_featuring_characters FOREIGN KEY(characters_name, characters_series_title, characters_series_creator) REFERENCES characters(name, series_title, series_creator)
);



