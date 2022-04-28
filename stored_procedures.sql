USE city_evaluation;

-- create

DROP PROCEDURE IF EXISTS new_city;
DELIMITER $$
CREATE PROCEDURE new_city(in cityname varchar(64), 
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

INSERT INTO city(city_name, 
  cost_of_living_index,
  rent_index,
  general_cost_index,
  groceries_index,
  restaurant_price_index,
  local_purchasing_power_index,
  country_name,
  topography_id,
  climate_type) 
 VALUES (cityname, cosindex, renindex, genindex, groindex, resindex, locindex, counname, topoid, climate);
 
 SELECT city_id AS your_id 
 FROM city WHERE 
  city_name = cityname and 
  cost_of_living_index = cosindex and
  rent_index = renindex and
  general_cost_index = genindex and
  groceries_index = groindex and
  restaurant_price_index = resindex and
  local_purchasing_power_index = locindex and
  country_name = counname and
  topography_id = topoid and
  climate_type = climate
  LIMIT 1;
   
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