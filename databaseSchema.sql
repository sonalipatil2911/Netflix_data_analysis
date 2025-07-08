DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),
	"cast" VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(25),
	release_year INT,
	rating VARCHAR(15),	
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(300)
);

SELECT *
FROM netflix;