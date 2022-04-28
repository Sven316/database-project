drop database if exists city_evaluation;
create database city_evaluation;
use city_evaluation;


CREATE TABLE government (
  government_type varchar(64) primary key,
  has_mornach varchar(10)
);

CREATE TABLE country (
  country_name varchar(64) primary key,
  continent varchar(64),
  government_type varchar(64),
  foreign key (government_type) references government(government_type)
  on update cascade on delete cascade
);

CREATE TABLE topography (
  topography_id int primary key,
  near_sea varchar(10),
  near_mountain varchar(10)
);

CREATE TABLE climate (
  climate_type varchar(64) primary key,
  summer_temprature varchar(64),
  winter_temprature varchar(64),
  precipitation varchar(64)
);

CREATE TABLE city (
  city_id int primary key auto_increment,
  city_name varchar(64),
  cost_of_living_index float,
  rent_index float,
  general_cost_index float,
  groceries_index float,
  restaurant_price_index float,
  local_purchasing_power_index float,
  country_name varchar(64),
  topography_id int,
  climate_type varchar(64),
  foreign key (country_name) references country(country_name)
  on update cascade on delete cascade,
  foreign key (topography_id) references topography(topography_id)
  on update cascade on delete cascade,
  foreign key (climate_type) references climate(climate_type)
  on update cascade on delete cascade
);

CREATE TABLE speaking_language (
  language_name varchar(64) primary key,
  learning_difficulty varchar(10)
);

CREATE TABLE crime (
  crime_type varchar(64) primary key,
  is_violent varchar(10)
);

CREATE TABLE cuisine (
  cuisine_name varchar(64) primary key,
  popularity_rank int,
  is_spicy varchar(10)
);

CREATE TABLE city_to_crime(
  city_id int,
  crime_type varchar(64),
  primary key (city_id, crime_type),
  foreign key (city_id) references city(city_id)
  on update cascade on delete cascade,
  foreign key (crime_type) references crime(crime_type)
  on update cascade on delete cascade
);

CREATE TABLE city_to_cuisine(
  city_id int,
  cuisine_name varchar(64),
  primary key (city_id, cuisine_name),
  foreign key (city_id) references city(city_id)
  on update cascade on delete cascade,
  foreign key (cuisine_name) references cuisine(cuisine_name)
  on update cascade on delete cascade
);

CREATE TABLE city_to_language(
  city_id int,
  language_name varchar(64),
  primary key (city_id, language_name),
  foreign key (city_id) references city(city_id)
  on update cascade on delete cascade,
  foreign key (language_name) references speaking_language(language_name)
  on update cascade on delete cascade
);

insert into government values
('Full presidential republics', 'no'),
('Semi-presidential republics', 'no'),
('One-party states', 'no'),
('Parliamentary constitutional monarchies', 'yes'),
('Parliamentary republics', 'no'),
('Absolute monarchies', 'yes');

insert into country values
('China', 'Asia', 'One-party states'),
('United States', 'North America', 'Full presidential republics'),
('United Kingdom', 'Europe', 'Parliamentary constitutional monarchies'),
('France', 'Europe', 'Semi-presidential republics'),
('Russia', 'Europe', 'Semi-presidential republics'),
('Japan', 'Asia', 'Parliamentary constitutional monarchies'),
('India', 'Asia', 'Parliamentary republics'),
('Thailand', 'Asia', 'Parliamentary constitutional monarchies'),
('Turkey', 'Asia', 'Full presidential republics'),
('Brasil', 'South America', 'Full presidential republics'),
('Australia', 'Oceania', 'Parliamentary constitutional monarchies'),
('Egypt', 'Africa', 'Semi-presidential republics');

insert into topography values
(1, 'yes', 'yes'),
(2, 'yes', 'no'),
(3, 'no', 'yes'),
(4, 'no', 'no');

insert into climate values
('Tropical', 'hot', 'mild', 'heavy'),
('Dry', 'hot', 'cold', 'light'),
('Temprate', 'warm', 'mild', 'moderate'),
('Continental', 'warm', 'cold', 'moderate'),
('Polar', 'cool', 'extremely cold', 'light');

insert into city values
(1, 'London', 81.26, 68.10, 74.97, 61.27, 79.44, 81.01, 'United Kingdom', 2, 'Temprate'),
(2, 'New York', 100.00,	100.00,	100.00,	100.00,	100.00,	100.00, 'United States', 2, 'Temprate'),
(3, 'Shang Hai', 53.35,	41.92,	47.89,	57.66,	40.37,	49.65, 'China', 2, 'Temprate'),
(4, 'Beijing', 53.39,	42.39,	48.13,	52.24,	36.70,	45.75, 'China', 3, 'Continental'),
(5, 'Paris', 77.77,	44.91,	62.06,	77.09,	71.11,	70.69, 'France', 4, 'Temprate'),
(6, 'Chicago', 75.40,	55.22,	65.75,	72.06,	74.19,	129.44, 'United States', 4, 'Continental'),
(7, 'Los Angeles', 80.00,	74.02,	77.14,	80.22,	84.61,	125.03, 'United States', 1, 'Temprate'),
(8, 'Hong Kong', 78.88,	67.09,	73.24,	85.44,	53.74,	66.06, 'China', 1, 'Temprate'),
(9, 'Moscow', 42.97, 26.51,	35.09,	36.47,	42.77,	44.61, 'Russia', 4, 'Continental'),
(10, 'Tokyo', 80.68, 35.20,	58.93,	93.25,	43.27,	80.68, 'Japan', 1, 'Temprate'),
(11, 'Mumbai', 28.38, 19.57, 24.16,	28.93,	24.11,	56.28, 'India', 2, 'Tropical'),
(12, 'Bangkok', 51.91,	26.22,	39.63,	52.64,	24.13,	26.16, 'Thailand', 2, 'Tropical'),
(13, 'Istanbul', 34.24,	10.60,	22.93,	28.16,	21.75,	25.53, 'Turkey', 2, 'Temprate'),
(14, 'Rio de Janeiro', 43.60,	12.92,	28.93,	38.01,	33.13,	19.57, 'Brasil', 2, 'Temprate'),
(15, 'Sydney', 84.75,	56.72,	71.35,	81.94,	69.85,	102.07, 'Australia', 2, 'Temprate'),
(16, 'Cairo', 27.91,	6.64,	17.73,	25.46,	23.64,	22.08, 'Egypt', 4, 'Dry');

insert into speaking_language values
('Chinese', 'hard'),
('English', 'easy'),
('Spanish', 'easy'),
('Russian', 'normal'),
('French', 'normal'),
('Japanese', 'hard'),
('Portuguess', 'easy'),
('Turkish', 'normal'),
('Arabic', 'hard'),
('Hindi', 'normal'),
('Thai', 'hard');

insert into crime values
('home broken', 'yes'),
('theft', 'no'),
('drug dealing', 'yes'),
('corruption', 'no'),
('robbery', 'yes'),
('insult', 'no');

insert into cuisine values
('Chinese', 1, 'yes'),
('Italian', 2, 'no'),
('French', 3, 'no'),
('Japanese', 4, 'no'),
('Mediterranean', 5, 'no'),
('South-east Asain', 6, 'yes'),
('Indian', 7, 'yes'),
('Turkish', 8, 'no'),
('American', 9, 'no'),
('Mexican', 10, 'yes'),
('British', 11, 'no'),
('Russian', 12, 'no');

insert into city_to_crime values
(1, 'drug dealing'),
(5, 'theft'),
(5, 'insult'),
(6, 'theft'),
(6, 'drug dealing'),
(6, 'corruption'),
(6, 'robbery'),
(6, 'insult'),
(7, 'drug dealing'),
(9, 'corruption'),
(11, 'corruption'),
(12, 'corruption'),
(13, 'corruption'),
(14, 'theft'),
(14, 'drug dealing'),
(14, 'corruption'),
(14, 'robbery'),
(16, 'corruption');

insert into city_to_cuisine values
(1, 'British'),
(1, 'Indian'),
(1, 'Italian'),
(2, 'American'),
(2, 'Mexican'),
(2, 'Italian'),
(2, 'Chinese'),
(3, 'Chinese'),
(4, 'Chinese'),
(5, 'French'),
(5, 'Italian'),
(6, 'American'),
(6, 'Italian'),
(7, 'American'),
(7, 'Mexican'),
(7, 'Chinese'),
(8, 'Chinese'),
(9, 'Russian'),
(10, 'Japanese'),
(11, 'Indian'),
(12, 'American'),
(12, 'Mexican'),
(13, 'Turkish'),
(14, 'American'),
(14, 'Mexican'),
(15, 'British'),
(15, 'American'),
(16, 'Turkish');

insert into city_to_language values
(1, 'English'),
(2, 'English'),
(3, 'Chinese'),
(4, 'Chinese'),
(5, 'French'),
(6, 'English'),
(7, 'English'),
(7, 'Spanish'),
(8, 'Chinese'),
(8, 'English'),
(9, 'Russian'),
(10, 'Japanese'),
(11, 'Hindi'),
(11, 'English'),
(12, 'Thai'),
(13, 'Turkish'),
(14, 'Portuguess'),
(15, 'English'),
(16, 'Arabic');

USE city_evaluation;

-- create

DROP PROCEDURE IF EXISTS new_city;
DELIMITER $$
CREATE PROCEDURE new_city(in id int,
  in cityname varchar(64), 
  in cosindex float,
  in renindex float,
  in genindex float,
  in groindex float,
  in resindex float,
  in locindex float,
  in counname varchar(64),
  in topoid int,
  in climate varchar(64))
BEGIN

 INSERT INTO city(city_id,
  city_name, 
  cost_of_living_index,
  rent_index,
  general_cost_index,
  groceries_index,
  restaurant_price_index,
  local_purchasing_power_index,
  country_name,
  topography_id,
  climate_type) 
 VALUES (id, cityname, cosindex, renindex, genindex, groindex, resindex, locindex, counname, topoid, climate);

END
$$ DELIMITER ;


-- update

DROP PROCEDURE IF EXISTS update_city;
DELIMITER $$
CREATE PROCEDURE update_city( in id int,
  in cityname varchar(64), 
  in cosindex float,
  in renindex float,
  in genindex float,
  in groindex float,
  in resindex float,
  in locindex float,
  in counname varchar(64),
  in topoid int,
  in climate varchar(64))
BEGIN

 UPDATE city 
 SET city_name = cityname, 
  cost_of_living_index = cosindex,
  rent_index = renindex,
  general_cost_index = genindex,
  groceries_index = groindex,
  restaurant_price_index = resindex,
  local_purchasing_power_index = locindex,
  country_name = counname,
  topography_id = topoid,
  climate_type = climate
 WHERE city_id = id;

END
$$ DELIMITER ;


-- delete

DROP PROCEDURE IF EXISTS delete_city;
DELIMITER $$
CREATE PROCEDURE delete_city(IN id INT)
BEGIN

 DELETE FROM city WHERE city_id = id;
 
END
$$ DELIMITER ;