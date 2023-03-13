\! chcp 1251

DROP DATABASE IF EXISTS testdb;
CREATE DATABASE testdb    
WITH
OWNER = postgres
ENCODING = 'UTF8'
LC_COLLATE = 'Russian_Russia.1251'
LC_CTYPE = 'Russian_Russia.1251'
TABLESPACE = pg_default
CONNECTION LIMIT = -1
IS_TEMPLATE = False;

\connect testdb;

DROP TABLE IF EXISTS rars;
CREATE TABLE rars(
	rars_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	rars_name varchar(30) NOT NULL UNIQUE,
	CONSTRAINT PK_rars_rars_id PRIMARY KEY(rars_id),
	CONSTRAINT CHK_rars_rars_name CHECK (rars_name != '')
);

DROP TABLE IF EXISTS mpaa;
CREATE TABLE mpaa(
	mpaa_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	mpaa_name varchar(30) NOT NULL UNIQUE,
	CONSTRAINT PK_mpaa_mpaa_id PRIMARY KEY(mpaa_id),
	CONSTRAINT CHK_mpaa_mpaa_name CHECK (mpaa_name != '')
);

DROP TABLE IF EXISTS human;
CREATE TABLE human(
	human_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	human_first_name varchar(30) NOT NULL,
	human_last_name varchar(30) NOT NULL,
	human_birth_day date NOT NULL,
	CONSTRAINT PK_human_human_id PRIMARY KEY(human_id),
	CONSTRAINT CHK_human_human_first_name CHECK (human_first_name != ''),
	CONSTRAINT CHK_human_human_last_name CHECK (human_last_name != '')
);

DROP TABLE IF EXISTS country;
CREATE TABLE country(
	country_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	country_name varchar(40) NOT NULL UNIQUE,
	CONSTRAINT PK_country_country_id PRIMARY KEY(country_id),
	CONSTRAINT CHK_country_country_name CHECK (country_name != '')
);

DROP TABLE IF EXISTS genre;
CREATE TABLE genre(
	genre_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	genre_name varchar(30) NOT NULL UNIQUE,
	CONSTRAINT PK_genre_genre_id PRIMARY KEY(genre_id),
	CONSTRAINT CHK_genre_genre_name CHECK (genre_name != '')
);

DROP TABLE IF EXISTS company;
CREATE TABLE company(
	company_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	company_name varchar(50) NOT NULL UNIQUE,
	CONSTRAINT PK_company_company_id PRIMARY KEY(company_id),
	CONSTRAINT CHK_company_company_name CHECK (company_name != '')
);

DROP TABLE IF EXISTS media_type;
CREATE TABLE media_type(
	media_type_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	media_type_name varchar(20) NOT NULL UNIQUE,
	CONSTRAINT PK_media_type_media_type_id PRIMARY KEY(media_type_id),
	CONSTRAINT CHK_media_type_media_type_name CHECK (media_type_name != '')
);

DROP TABLE IF EXISTS film;
CREATE TABLE film(
	film_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	film_name_original varchar(50) NOT NULL,
	film_name_translated varchar(50) NOT NULL,
	film_year smallint NOT NULL,
	rars_id int,
	mpaa_id int,
	film_duration int NOT NULL,
	film_rate decimal NOT NULL,
	film_short_description text NOT NULL,
	CONSTRAINT PK_film_film_id PRIMARY KEY(film_id),
	CONSTRAINT FK_film_rars FOREIGN KEY (rars_id) REFERENCES rars(rars_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_mpaa FOREIGN KEY (mpaa_id) REFERENCES mpaa(mpaa_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_film_duration CHECK (film_duration > 0),
	CONSTRAINT CHK_film_film_year CHECK (film_year > 1894),
	CONSTRAINT CHK_film_film_name_original CHECK (film_name_original != ''),
	CONSTRAINT CHK_film_film_name_translated CHECK (film_name_translated != ''),
	CONSTRAINT CHK_film_film_rate CHECK (film_rate BETWEEN 0 AND 10),
	CONSTRAINT CHK_film_film_short_description CHECK (film_short_description != '')
);

DROP TABLE IF EXISTS film_person;
CREATE TABLE film_person(
	film_id int,
	original_person_id int,
	dubbed_person_id int,
	CONSTRAINT PK_film_person_film_id_original_person_id_dubbed_person_id PRIMARY KEY(film_id, original_person_id,dubbed_person_id),
	CONSTRAINT FK_film_person_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_person_original_person FOREIGN KEY(original_person_id) REFERENCES human(human_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_person_dubbed_person FOREIGN KEY(dubbed_person_id) REFERENCES human(human_id) ON DELETE RESTRICT
);

DROP TABLE IF EXISTS film_country;
CREATE TABLE film_country(
	film_id int,
	country_id int,
	CONSTRAINT PK_film_country_film_id_country_id PRIMARY KEY(film_id, country_id),
	CONSTRAINT FK_film_country_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_country_country FOREIGN KEY(country_id) REFERENCES country(country_id) ON DELETE RESTRICT
);

DROP TABLE IF EXISTS film_genre;
CREATE TABLE film_genre(
	film_id int,
	genre_id int,
	CONSTRAINT PK_film_genre_film_id_genre_id PRIMARY KEY(film_id, genre_id),
	CONSTRAINT FK_film_genre_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_genre_genre FOREIGN KEY(genre_id) REFERENCES genre(genre_id) ON DELETE RESTRICT
);

DROP TABLE IF EXISTS film_slogan;
CREATE TABLE film_slogan(
	film_id int,
	film_slogan_name text NOT NULL,
	CONSTRAINT PK_film_slogan_film_id PRIMARY KEY(film_id),
	CONSTRAINT FK_film_slogan_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_slogan_film_slogan_name CHECK (film_slogan_name != '')
);

DROP TABLE IF EXISTS film_budget;
CREATE TABLE film_budget(
	film_id int,
	film_budget_amount decimal NOT NULL,
	CONSTRAINT PK_film_budget_film_id PRIMARY KEY(film_id),
	CONSTRAINT FK_film_budget_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_budget_film_budget_amount CHECK (film_budget_amount >= 0)
);

DROP TABLE IF EXISTS film_marketing;
CREATE TABLE film_marketing(
	film_id int,
	film_marketing_amount decimal NOT NULL,
	CONSTRAINT PK_film_marketing_film_id PRIMARY KEY(film_id),
	CONSTRAINT FK_film_marketing_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_marketing_film_marketing_amount CHECK (film_marketing_amount >= 0)
);

DROP TABLE IF EXISTS film_box_office;
CREATE TABLE film_box_office(
	film_id int,
	country_id int,
	film_box_office_amount decimal NOT NULL,
	CONSTRAINT PK_film_box_office_film_id_country_id PRIMARY KEY(film_id, country_id),
	CONSTRAINT FK_film_box_office_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_box_office_country FOREIGN KEY(country_id) REFERENCES country(country_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_box_office_film_box_office_amount CHECK (film_box_office_amount >= 0)
);

DROP TABLE IF EXISTS film_spectators;
CREATE TABLE film_spectators(
	film_id int,
	country_id int,
	film_spectators_amount int NOT NULL,
	CONSTRAINT PK_film_spectators_film_id_country_id PRIMARY KEY(film_id, country_id),
	CONSTRAINT FK_film_spectators_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_spectators_country FOREIGN KEY(country_id) REFERENCES country(country_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_spectators_film_spectators_amount CHECK (film_spectators_amount >= 0)
);

DROP TABLE IF EXISTS film_release;
CREATE TABLE film_release(
	film_id int,
	media_type_id int,
	company_id int,
	film_release_date date NOT NULL,
	CONSTRAINT PK_film_release_film_id_media_type_id_company_id PRIMARY KEY(film_id, media_type_id,company_id),
	CONSTRAINT FK_film_release_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_release_media_type FOREIGN KEY(media_type_id) REFERENCES media_type(media_type_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_release_company FOREIGN KEY(company_id) REFERENCES company(company_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_release_film_release_date CHECK (film_release_date > '1894-1-1')
);

DROP TABLE IF EXISTS film_premiere;
CREATE TABLE film_premiere(
	film_id int,
	country_id int,
	company_id int,
	film_premiere_date date NOT NULL,
	CONSTRAINT PK_film_premiere_film_id_country_id_company_id PRIMARY KEY(film_id, country_id,company_id),
	CONSTRAINT FK_film_premiere_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_premiere_country FOREIGN KEY(country_id) REFERENCES country(country_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_premiere_company FOREIGN KEY(company_id) REFERENCES company(company_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_premiere_film_premiere_date CHECK (film_premiere_date > '1894-1-1')
);

DROP TABLE IF EXISTS person;
CREATE TABLE person(
	film_id int,
	director_id int,
	screenwriter_id int,
	producer_id int,
	operator_id int,
	composer_id int,
	artist_id int,
	editor_id int,
	CONSTRAINT PK_person_film_id PRIMARY KEY(film_id),
	CONSTRAINT FK_person_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_person_director FOREIGN KEY(director_id) REFERENCES human(human_id) ON DELETE RESTRICT,
	CONSTRAINT FK_person_screenwriter FOREIGN KEY(screenwriter_id) REFERENCES human(human_id) ON DELETE RESTRICT,
	CONSTRAINT FK_person_producer FOREIGN KEY(producer_id) REFERENCES human(human_id) ON DELETE RESTRICT,
	CONSTRAINT FK_person_operator FOREIGN KEY(operator_id) REFERENCES human(human_id) ON DELETE RESTRICT,
	CONSTRAINT FK_person_composer FOREIGN KEY(composer_id) REFERENCES human(human_id) ON DELETE RESTRICT,
	CONSTRAINT FK_person_artist FOREIGN KEY(artist_id) REFERENCES human(human_id) ON DELETE RESTRICT,
	CONSTRAINT FK_person_editor FOREIGN KEY(editor_id) REFERENCES human(human_id) ON DELETE RESTRICT
);

DROP TABLE IF EXISTS film_image;
CREATE TABLE film_image(
	film_image_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	film_id int,
	film_image_name varchar(30) NOT NULL UNIQUE,
	film_image_url varchar(100) NOT NULL UNIQUE,
	CONSTRAINT PK_film_image_film_image_id PRIMARY KEY(film_image_id),
	CONSTRAINT FK_film_image_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_image_film_image_name CHECK (film_image_name != ''),
	CONSTRAINT CHK_film_image_film_image_url CHECK (film_image_url != '')
);

DROP TABLE IF EXISTS film_trailer;
CREATE TABLE film_trailer(
	film_trailer_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	film_id int,
	film_trailer_name varchar(30) NOT NULL UNIQUE,
	film_trailer_url varchar(100) NOT NULL UNIQUE,
	CONSTRAINT PK_film_trailer_film_trailer_id PRIMARY KEY(film_trailer_id),
	CONSTRAINT FK_film_trailer_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_trailer_film_trailer_name CHECK (film_trailer_name != ''),
	CONSTRAINT CHK_film_trailer_film_trailer_url CHECK (film_trailer_url != '')
);

DROP TABLE IF EXISTS reward;
CREATE TABLE reward(
	reward_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	reward_name varchar(50) NOT NULL,
	reward_nom_name text NOT NULL,
	CONSTRAINT PK_reward_reward_id PRIMARY KEY(reward_id),
	CONSTRAINT CHK_reward_reward_name CHECK (reward_name != ''),
	CONSTRAINT CHK_reward_reward_nom_name CHECK (reward_nom_name != '')
);

DROP TABLE IF EXISTS film_reward;
CREATE TABLE film_reward(
	film_id int,
	reward_id int,
	film_reward_year int NOT NULL,
	CONSTRAINT PK_film_reward_film_id_reward_id PRIMARY KEY(film_id, reward_id),
	CONSTRAINT FK_film_reward_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_film_reward_reward FOREIGN KEY(reward_id) REFERENCES reward(reward_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_film_reward_film_reward_year CHECK (film_reward_year > 1894)
);

DROP TABLE IF EXISTS site_user;
CREATE TABLE site_user(
	site_user_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
	site_user_name varchar(25) NOT NULL UNIQUE,
	site_user_created_date timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT PK_site_user_site_user_id PRIMARY KEY(site_user_id),
	CONSTRAINT CHK_site_user_site_user_created_date CHECK (site_user_created_date > '2010-1-1'),
	CONSTRAINT CHK_site_user_site_user_name CHECK (char_length(site_user_name) BETWEEN 4 AND 25)
);

DROP TABLE IF EXISTS film_user_review;
CREATE TABLE film_user_review(
	film_id int,
	site_user_id int,
	user_review_text text NOT NULL,
	user_review_created_date timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT PK_user_review_film_id_site_user_id PRIMARY KEY(film_id, site_user_id),
	CONSTRAINT FK_user_review_film FOREIGN KEY(film_id) REFERENCES film(film_id) ON DELETE RESTRICT,
	CONSTRAINT FK_user_review_site_user FOREIGN KEY(site_user_id) REFERENCES site_user(site_user_id) ON DELETE RESTRICT,
	CONSTRAINT CHK_user_review_user_review_created_date CHECK (user_review_created_date > '2010-1-1'),
	CONSTRAINT CHK_user_review_user_review_text CHECK (char_length(user_review_text) > 0)
);

CREATE EXTENSION pg_trgm;
CREATE INDEX trgm_idx_human_human_first_name ON human USING gin (human_first_name gin_trgm_ops);
CREATE INDEX trgm_idx_human_human_last_name ON human USING gin (human_last_name gin_trgm_ops);
CREATE INDEX trgm_idx_film_film_name_original ON film USING gin(film_name_original gin_trgm_ops);
CREATE INDEX trgm_idx_film_film_name_translated ON film USING gin(film_name_translated gin_trgm_ops);
CREATE INDEX idx_film_film_year ON film(film_year);
CREATE INDEX idx_film_rars_id ON film(rars_id);
CREATE INDEX idx_film_mpaa_id ON film(mpaa_id);
CREATE INDEX idx_film_film_duration ON film(film_duration);
CREATE INDEX idx_film_film_rate ON film(film_rate);
CREATE INDEX idx_film_person_film_id ON film_person(film_id);
CREATE INDEX idx_film_person_original_person_id ON film_person(original_person_id);
CREATE INDEX idx_film_person_dubbed_person_id ON film_person(dubbed_person_id);
CREATE INDEX idx_film_country_film_id ON film_country(film_id);
CREATE INDEX idx_film_country_country_id ON film_country(country_id);
CREATE INDEX idx_film_genre_film_id ON film_genre(film_id);
CREATE INDEX idx_film_genre_genre_id ON film_genre(genre_id);
CREATE INDEX idx_film_box_office_film_id ON film_box_office(film_id);
CREATE INDEX idx_film_box_office_country_id ON film_box_office(country_id);
CREATE INDEX idx_film_spectators_film_id ON film_spectators(film_id);
CREATE INDEX idx_film_spectators_country_id ON film_spectators(country_id);
CREATE INDEX idx_film_release_film_id ON film_release(film_id);
CREATE INDEX idx_film_release_media_type_id ON film_release(media_type_id);
CREATE INDEX idx_film_release_company_id ON film_release(company_id);
CREATE INDEX idx_film_premiere_film_id ON film_premiere(film_id);
CREATE INDEX idx_film_premiere_company_id ON film_premiere(company_id);
CREATE INDEX idx_film_premiere_country_id ON film_premiere(country_id);
CREATE INDEX idx_person_director_id ON person(director_id);
CREATE INDEX idx_person_screenwriter_id ON person(screenwriter_id);
CREATE INDEX idx_person_producer_id ON person(producer_id);
CREATE INDEX idx_person_operator_id ON person(operator_id);
CREATE INDEX idx_person_composer_id ON person(composer_id);
CREATE INDEX idx_person_artist_id ON person(artist_id);
CREATE INDEX idx_person_editor_id ON person(editor_id);
CREATE INDEX idx_film_image_film_id ON film_image(film_id);
CREATE INDEX idx_film_trailer_film_id ON film_trailer(film_id);
CREATE INDEX trgm_idx_reward_reward_name ON reward USING gin (reward_name gin_trgm_ops);
CREATE INDEX trgm_idx_reward_reward_nom_name ON reward USING gin (reward_nom_name gin_trgm_ops);
CREATE INDEX idx_film_reward_film_id ON film_reward(film_id);
CREATE INDEX idx_film_reward_reward_id ON film_reward(reward_id);
CREATE INDEX idx_film_reward_film_reward_year ON film_reward(film_reward_year);
CREATE INDEX trgm_idx_site_user_site_user_name ON site_user USING gin (site_user_name gin_trgm_ops);
CREATE INDEX idx_film_user_review_film_id ON film_user_review(film_id);
CREATE INDEX idx_film_user_review_site_user_id ON film_user_review(site_user_id);