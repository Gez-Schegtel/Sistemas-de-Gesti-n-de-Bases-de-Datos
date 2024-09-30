
CREATE VIEW vista_info_pelis AS 
SELECT a.first_name, a.last_name, f.title, f.description, f.release_year,  f.length, f.rating, f.special_features
FROM actor AS a INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id INNER JOIN film AS f ON fa.film_id = f.film_id;

