
-- PARTE 1: Lenguaje DML

-- El siguiente script está pensado para ejecutarse sobre la base de datos "sakila". 
-- Para más info, ver: https://dev.mysql.com/doc/sakila/en/sakila-installation.html

USE SAKILA;

-- CONSULTAS DE INSERCIÓN, ACTUALIZACIÓN Y BORRADO
-- 1.1. Inserte un nuevo cliente.
-- Aclaración: Fue necesario crear una dirección para el cliente antes de agregar el mismo a la tabla "customer".

INSERT INTO address (address, address2, district, city_id, postal_code, phone, location, last_update) VALUES ("Malibu Ave. 1555", NULL, "St. Mary Sunshine", 567, 9122018, 312331, 0x0000000001010000003E0A325D63345CC0761FDB8D99D94838, DEFAULT);

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date) VALUES (1, "Mike", "Patton", "faithnomore@proton.me", 606, 1, NOW());

-- 1.2. Agregue un nuevo empleado a la base.

INSERT INTO address (address, address2, district, city_id, postal_code, phone, location, last_update) VALUES ("Malibu Ave. 1560", NULL, "St. Mary Sunshine", 567, 9122018, 312227, 0x0000000001010000003E0A325D63345CC0761FDB8D99D94838, DEFAULT);

INSERT INTO staff(first_name, last_name, address_id, store_id, active, username) VALUES ("Eric", "Clapton", 607, 1, DEFAULT, "Crossroads");

-- 1.3. Inserte los datos de un cliente existente (nombre y apellido) pero con un nuevo código (customer_id).

INSERT INTO customer (customer_id, store_id, first_name, last_name, email, address_id, active, create_date) VALUES (701, 1, "Mike", "Patton", "faithnomore@proton.me", 606, 1, NOW());

-- 1.4. Borre todos los registros de la tabla pelicula_actor e inserte para todas las películas cargadas un registro asociándola con el actor con el menor id (actor_id).

-- Borramos los registros de film_actor:
-- Otra opción es utilizar: `DELETE FROM film_actor;`
TRUNCATE TABLE film_actor;

-- Almacenar el customer_id con menor valor en una variable
SELECT customer_id AS cliente_con_menor_id
INTO @min_customer_id
FROM customer
WHERE customer_id = (SELECT MIN(customer_id) FROM customer);

-- Actualizamos las películas asociándolas con el actor de menor id. 
INSERT INTO film_actor (actor_id, film_id)
SELECT @min_customer_id, film.film_id
FROM film;

-- 1.5. Actualice el actor relacionado a una de las películas por el id de la actriz “JENNIFER DAVIS”.
/*
-- Opción 1: Guardando el id de Jennifer en una variable.
SELECT actor_id
INTO @jenny
FROM actor
WHERE first_name LIKE "jennifer" AND last_name LIKE "davis";

UPDATE film_actor SET actor_id = @jenny WHERE actor_id = 1; 
*/

-- Opción 2: Sin utilizar una variable para almacenar el id:
UPDATE film_actor
SET actor_id = (
    SELECT actor_id
    FROM actor
    WHERE first_name LIKE 'Jennifer' AND last_name LIKE 'Davis'
)
WHERE actor_id = 1;

-- 1.6. Actualice la fecha de un alquiler que usted seleccione por 23/12/2004
UPDATE rental SET rental_date="2004-12-23" WHERE rental_id=1;

-- 1.7. Debe realizarse un descuento del 10% en los pagos que fueron hechos el mismo día del alquiler.
UPDATE payment AS p INNER JOIN rental AS r ON p.rental_id=r.rental_id AND DATE(p.payment_date) = DATE(r.rental_date)
SET p.amount=p.amount*0.9;

-- 1.8. Actualice el código de empleado de los alquileres que tengan asignado al empleado 1 por el empleado 3.

-- ¡Aclaración importante! ¡Leer!
-- Más arriba añadimos un empleado con el id=3, por ello (y para hacer más general la consulta) decidimos buscar el máximo id y que se autoincremente a partir de dicho valor

SET @staff_mayor = (SELECT MAX(staff_id) FROM staff);

UPDATE staff AS s INNER JOIN rental AS r ON s.staff_id=r.staff_id AND s.staff_id=1	
SET s.staff_id=@staff_mayor+1;

-- 1.9. Borre todos los alquileres anteriores al 30/05/2005.
DELETE FROM rental WHERE DATE(rental.rental_date) < "2005-05-30";

-- 1.10. Elimine a todos los empleados que no tengan cargado su email.
DELETE FROM staff WHERE email IS NULL; 

-- 1.11. Insertar un nuevo empleado con el número inmediato consecutivo al máximo existente.
-- ¡Aclaración! El id cuenta con la propiedad de "AUTO_INCREMENT", por lo cual, su valor de forma automática será consecutivo al valor máximo de id actual en la tabla.

INSERT INTO staff(first_name, last_name, address_id, store_id, active, username, last_update)
VALUES ("John", "Zorn", 605, 1, 1, "qotsa", NOW());

-- 1.12. Insertar una nueva categoría con el número inmediato consecutivo al máximo existente sin utilizar la función MAX ni la propiedad “Auto increment” de la clave primaria.

INSERT INTO category (category_id, name, last_update)
VALUES (
    (
        SELECT CAST(category_id AS UNSIGNED) + 1
        FROM (
            (SELECT category_id FROM category)
            EXCEPT
            (SELECT DISTINCT category1.category_id
             FROM category AS category1
             CROSS JOIN category AS category2
             WHERE category1.category_id < category2.category_id)
        ) AS temp_category_id
    ),
    'Spaghetti Western',
    NOW()
);

-- 1.13. Insertar los datos de la tabla cliente en una nueva tabla, borre los datos de la tabla cliente. En la nueva tabla realice una actualización de los códigos de cliente incrementándolos en uno. Posteriormente reinsértelos en la tabla cliente y vuelva a la normalidad los códigos.
CREATE TABLE nuevo_cliente AS
SELECT * FROM customer;

SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE customer;
SET FOREIGN_KEY_CHECKS=1;

UPDATE nuevo_cliente C
SET C.customer_id = C.customer_id + 1000;

UPDATE nuevo_cliente C
SET C.customer_id = C.customer_id -999;

INSERT INTO costumer (customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update)
SELECT *
FROM nuevo_cliente;

UPDATE costumer C
SET C.costumer_id = C.costumer_id -1;

-- 1.14. Las compañías telefónicas han decidido (por falta de números telefónicos!!), que todas las líneas deben agregar un 9 como primer número. Realice la actualización correspondiente en los teléfonos (phone) registrados para cada dirección (address).
UPDATE address SET phone=CONCAT('9',phone) WHERE (LENGTH(phone) > 1);

-- 1.15. Debido a una promoción, se incrementa en dos los días de alquiler (rental_duration) de las películas con una tarifa (rental_rate) menor a 2.5.
UPDATE film SET rental_duration = rental_duration + 2 WHERE rental_rate < 2.5;


-- CONSULTAS SIMPLES
-- 1.16. Obtenga un listado de todos los empleados de nombre Jon.
SELECT staff_id, first_name, last_name
FROM staff
WHERE first_name = 'Jon';

-- 1.17. Se desea obtener la cantidad de alquileres con fecha posterior a 30/06/2005.
SELECT COUNT(*) AS total_rentals
FROM rental
WHERE rental_date > '2005-06-30';

-- 1.18. Se necesita conocer la cantidad total de alquileres de cada película.
SELECT f.film_id, f.title, COUNT(r.rental_id) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY total_rentals DESC;

-- 1.19. Liste todos los alquileres hechos entre el 20/12/2005 y el 10/01/2006.
SELECT rental_id, rental_date, inventory_id, customer_id
FROM rental
WHERE rental_date BETWEEN '2005-12-20' AND '2006-01-10';

-- 1.20. Muestre los alquileres en los cuales la fecha de devolución (return_date) es posterior a 2 días desde la fecha de alquiler (rental_date).
SELECT rental_id, rental_date, return_date, inventory_id, customer_id
FROM rental
WHERE TIMESTAMPDIFF(DAY, rental_date, return_date) > 2;

-- 1.21. Obtenga la cantidad de clientes diferentes que alquilaron películas después del 31/01/2006.
SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM rental 
WHERE rental_date > '2006-01-31';

-- 1.22. Obtener los datos del último alquiler existente
SELECT rental_id, rental_date, inventory_id, customer_id, return_date, staff_id 
FROM rental 
ORDER BY rental_date DESC 
LIMIT 1;

-- 1.23. Obtener los apellidos de los empleados que se encuentren repetidos.
SELECT last_name, COUNT(DISTINCT staff_id) AS unique_employees
FROM staff
GROUP BY last_name
HAVING COUNT(DISTINCT staff_id) > 1;

-- 1.24. Obtener un listado con la cantidad de alquileres por fecha.
SELECT DATE(rental_date) AS rental_date, COUNT(*) AS total_rentals
FROM rental
GROUP BY DATE(rental_date)
ORDER BY rental_date;

-- 1.25. Obtener el promedio de días que las películas tardan en devolverse (diferencia entre fecha de devolución y fecha de alquiler). Cree una vista con esta consulta que se llame vw_promedio_dias. 
CREATE VIEW vw_promedio_dias AS
SELECT AVG(DATEDIFF(DATE(return_date), DATE(rental_date))) AS promedio_dias
FROM rental
WHERE return_date IS NOT NULL;

-- 1.26. Obtener los empleados que hayan cobrado más de 10 pagos. Cree una vista con esta consulta que se llame vw_empleados_pagos.
CREATE VIEW vw_empleados_pagos AS
SELECT s.staff_id, s.first_name, s.last_name, COUNT(p.payment_id) AS total_pagos
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
HAVING COUNT(p.payment_id) > 10;


-- CONSULTAS MULTITABLA
-- 1.27. Listar los clientes cuyas direcciones principales estén sobre calles que empiecen con A (tener en cuenta el formato de dirección cargado), indicando nombre, domicilio y teléfono. Hacer una versión en la que aparezcan sólo los que tienen teléfono, y hacer otra en la que aparezca sólo los clientes con domicilio en calles que empiecen con A y que no tienen ningún teléfono.
-- Version con teléfono
SELECT c.first_name, c.last_name, a.address, a.phone
FROM customer c
JOIN address a ON c.address_id = a.address_id
WHERE a.address LIKE 'A%'
AND a.phone IS NOT NULL;

-- Versión sin teléfono: 
SELECT c.first_name, c.last_name, a.address
FROM customer c
JOIN address a ON c.address_id = a.address_id
WHERE a.address LIKE 'A%'
AND a.phone IS NULL;

-- 1.28. Listar los alquileres mostrando día, nombre del cliente, título de la película y el nombre del empleado que atendió.
SELECT 
    DATE(r.rental_date) AS dia_alquiler,
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
    f.title AS titulo_pelicula,
    CONCAT(s.first_name, ' ', s.last_name) AS nombre_empleado
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN staff s ON r.staff_id = s.staff_id;

-- 1.29. Listar los alquileres, la cantidad días que estuvo prestada la película y el monto pagado.
SELECT
    r.rental_id,
    DATE(r.rental_date) AS fecha_alquiler,
    DATE(r.return_date) AS fecha_devolucion,
    DATEDIFF(DATE(r.return_date), DATE(r.rental_date)) AS cantidad_dias,
    p.amount AS monto_pagado
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
WHERE r.return_date IS NOT NULL;

-- 1.30. Listar los alquileres y los nombres de clientes que pagaron más de 250 en total.
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
    SUM(p.amount) AS total_pagado
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(p.amount) > 250;

-- 1.31. Listar los clientes que fueron atendidos alguna vez por el empleado “Jon Stephens”.
SELECT DISTINCT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN staff s ON r.staff_id = s.staff_id
WHERE CONCAT(s.first_name, ' ', s.last_name) LIKE '%Jon Stephens%';

-- 1.32. Listar los clientes que realizaron más de un alquiler el mismo día.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
    DATE(r.rental_date) AS fecha_alquiler,
    COUNT(r.rental_id) AS cantidad_alquileres
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, DATE(r.rental_date)
HAVING COUNT(r.rental_id) > 1;

-- 1.33. Listar los nombres de los empleados y la cantidad de pagos que atendieron para aquellos con un monto mayor a 5.
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS nombre_empleado,
    COUNT(p.payment_id) AS cantidad_pagos
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
HAVING SUM(p.amount) > 5;

-- 1.34. Crear una vista que liste la cantidad total de alquileres por categoría de películas.
CREATE VIEW vw_cantidad_alquileres_por_categoria AS
SELECT
    c.category_id,
    c.name AS categoria,
    COUNT(r.rental_id) AS cantidad_alquileres
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name;


-- CONSULTAS ANIDADAS – SUBCONSULTAS
-- 1.35. Listar las películas en las que actuó alguna vez la actriz “JENNIFER DAVIS”.
--opción 1
SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_actor fa
    JOIN actor a ON fa.actor_id = a.actor_id
    WHERE a.first_name = 'JENNIFER' AND a.last_name = 'DAVIS'
);

--opción 2
WITH actress_films AS (
    SELECT fa.film_id
    FROM film_actor fa
    JOIN actor a ON fa.actor_id = a.actor_id
    WHERE a.first_name = 'JENNIFER' AND a.last_name = 'DAVIS'
)
SELECT f.title
FROM film f
JOIN actress_films af ON f.film_id = af.film_id;

-- 1.36. Listar los códigos de clientes que hayan alquilado más de 50 películas distintas.
--opción 1
SELECT customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY customer_id
HAVING COUNT(DISTINCT f.film_id) > 50;

--opción 2
WITH customer_rentals AS (
    SELECT customer_id, COUNT(DISTINCT f.film_id) AS rented_films
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    GROUP BY customer_id
)
SELECT customer_id
FROM customer_rentals
WHERE rented_films > 50;

-- 1.37. Listar los nombres de clientes que alquilaron películas en 2004 pero no lo hicieron en 2005.
--opción 1
SELECT DISTINCT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE YEAR(r.rental_date) = 2004
AND c.customer_id NOT IN (
    SELECT customer_id
    FROM rental
    WHERE YEAR(rental_date) = 2005
);

--opción 2
SELECT c.first_name, c.last_name
FROM customer c
JOIN rental r1 ON c.customer_id = r1.customer_id
LEFT JOIN rental r2 ON c.customer_id = r2.customer_id AND YEAR(r2.rental_date) = 2005
WHERE YEAR(r1.rental_date) = 2004 AND r2.rental_id IS NULL;

-- 1.38. Listar los empleados (código, nombre y apellido) que atendieron más de 10 alquileres y por los que el monto total cobrado fue más de 50.
-- opción 1
SELECT s.staff_id, s.first_name, s.last_name
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id
HAVING COUNT(p.payment_id) > 10 AND SUM(p.amount) > 50;

--opción 2
WITH staff_performance AS (
    SELECT s.staff_id, COUNT(p.payment_id) AS rentals, SUM(p.amount) AS total_amount
    FROM staff s
    JOIN payment p ON s.staff_id = p.staff_id
    GROUP BY s.staff_id
)
SELECT staff_id, first_name, last_name
FROM staff_performance sp
JOIN staff s ON sp.staff_id = s.staff_id
WHERE rentals > 10 AND total_amount > 50;

-- 1.39. Listar los actores que actuaron en al menos 2 películas distintas, las cuales fueron alquiladas más de 30 veces.
--5. Listar los actores que actuaron en al menos 2 películas distintas, las cuales fueron alquiladas más de 30 veces
--opción 1
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN inventory i ON fa.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY a.actor_id, fa.film_id
HAVING COUNT(DISTINCT fa.film_id) >= 2 AND COUNT(r.rental_id) > 30;

--opción 2
WITH actor_films AS (
    SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT fa.film_id) AS film_count, COUNT(r.rental_id) AS rental_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN inventory i ON fa.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY a.actor_id
)
SELECT first_name, last_name
FROM actor_films
WHERE film_count >= 2 AND rental_count > 30;

-- 1.40. Listar el nombre, apellido y código de aquellos clientes que se han retrasado en la devolución más de un 40% de las veces que alquilaron.
-- Opción 1: Subconsulta en el WHERE
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT r.customer_id
    FROM rental r
    WHERE DATEDIFF(r.return_date, r.rental_date) > 0
    GROUP BY r.customer_id
    HAVING COUNT(CASE WHEN DATEDIFF(r.return_date, r.rental_date) > 0 THEN 1 END) > 0.4 * COUNT(*)
);

-- Opción 2: CTE
WITH rental_delays AS (
    SELECT customer_id,
           COUNT(*) AS total_rentals,
           COUNT(CASE WHEN DATEDIFF(return_date, rental_date) > 0 THEN 1 END) AS late_returns
    FROM rental
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental_delays rd ON c.customer_id = rd.customer_id
WHERE rd.late_returns > 0.4 * rd.total_rentals;

-- 1.41. Crear una vista que liste las películas que tienen disponibles (sin alquilar) más del 20% de sus existencias (en la tabla inventory).
-- Opción 1: Subconsulta en WHERE
CREATE VIEW available_films AS
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS total_inventory,
       COUNT(CASE WHEN r.rental_id IS NULL THEN 1 END) AS available_inventory
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
GROUP BY f.film_id, f.title
HAVING COUNT(CASE WHEN r.rental_id IS NULL THEN 1 END) > 0.2 * COUNT(i.inventory_id);

-- Opción 2: CTE
WITH inventory_status AS (
    SELECT f.film_id, f.title, COUNT(i.inventory_id) AS total_inventory,
           COUNT(CASE WHEN r.rental_id IS NULL THEN 1 END) AS available_inventory
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
    GROUP BY f.film_id, f.title
)
CREATE VIEW available_films AS
SELECT film_id, title
FROM inventory_status
WHERE available_inventory > 0.2 * total_inventory;

-- 1.42. Crear una vista que liste el nombre y el código de aquellos clientes que hayan alquilado el día en que se registró la mayor cantidad de alquileres.
-- Opción 1: Subconsulta en WHERE
CREATE VIEW max_rental_day_customers AS
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = (
    SELECT DATE(rental_date)
    FROM rental
    GROUP BY DATE(rental_date)
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Opción 2: CTE
WITH max_rental_day AS (
    SELECT DATE(rental_date) AS max_date
    FROM rental
    GROUP BY DATE(rental_date)
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
CREATE VIEW max_rental_day_customers AS
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN max_rental_day mrd ON DATE(r.rental_date) = mrd.max_date;

-- 1.43. Listar el código y nombre de los clientes que hayan hecho alquileres en la fecha más antigua registrada.
-- Opción 1: Subconsulta en WHERE
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_date = (
    SELECT MIN(rental_date)
    FROM rental
);

-- Opción 2: CTE
WITH oldest_rental AS (
    SELECT MIN(rental_date) AS min_rental_date
    FROM rental
)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN oldest_rental or ON r.rental_date = or.min_rental_date;

-- 1.44. Listar los clientes que alquilaron entre los años 2005 y en el 2006.
-- Opción 1: Subconsulta en WHERE
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE YEAR(r.rental_date) BETWEEN 2005 AND 2006;

-- Opción 2: CTE
WITH rentals_2005_2006 AS (
    SELECT DISTINCT customer_id
    FROM rental
    WHERE YEAR(rental_date) BETWEEN 2005 AND 2006
)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rentals_2005_2006 r ON c.customer_id = r.customer_id;

-- 1.45. Listar las películas que tienen menos de 5 ejemplare en existencia y que han generado ingresos totales por más de 200.
-- Opción 1: Subconsulta en el WHERE
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS total_inventory, SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title
HAVING COUNT(i.inventory_id) < 5 AND SUM(p.amount) > 200;

-- Opción 2: CTE
WITH film_revenue AS (
    SELECT f.film_id, f.title, COUNT(i.inventory_id) AS total_inventory, SUM(p.amount) AS total_revenue
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY f.film_id, f.title
)
SELECT film_id, title
FROM film_revenue
WHERE total_inventory < 5 AND total_revenue > 200;

-- 1.46. Listar los nombres y códigos de clientes que alquilaron todas las películas de acción (categoría “Action”).
-- Opción 1: Subconsulta en WHERE
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE NOT EXISTS (
    SELECT fc.film_id
    FROM film_category fc
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = 'Action'
    AND NOT EXISTS (
        SELECT r.rental_id
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        WHERE i.film_id = fc.film_id
        AND r.customer_id = c.customer_id
    )
);

-- Opción 2: CTE
WITH action_films AS (
    SELECT fc.film_id
    FROM film_category fc
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = 'Action'
),
customer_action_rentals AS (
    SELECT r.customer_id, i.film_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE i.film_id IN (SELECT film_id FROM action_films)
)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE NOT EXISTS (
    SELECT a.film_id
    FROM action_films a
    WHERE a.film_id NOT IN (
        SELECT car.film_id
        FROM customer_action_rentals car
        WHERE car.customer_id = c.customer_id
    )
);

-- 1.47. Listar los empleados que atendieron alquileres de todas las categorías de películas.
-- Opción 1: Subconsulta en WHERE
SELECT s.staff_id, s.first_name, s.last_name
FROM staff s
WHERE NOT EXISTS (
    SELECT c.category_id
    FROM category c
    WHERE NOT EXISTS (
        SELECT r.rental_id
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film_category fc ON i.film_id = fc.film_id
        WHERE r.staff_id = s.staff_id
        AND fc.category_id = c.category_id
    )
);

-- Opción 2: CTE
WITH staff_rentals AS (
    SELECT r.staff_id, fc.category_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    GROUP BY r.staff_id, fc.category_id
),
all_categories AS (
    SELECT category_id
    FROM category
)
SELECT s.staff_id, s.first_name, s.last_name
FROM staff s
WHERE NOT EXISTS (
    SELECT ac.category_id
    FROM all_categories ac
    WHERE ac.category_id NOT IN (
        SELECT sr.category_id
        FROM staff_rentals sr
        WHERE sr.staff_id = s.staff_id
    )
);


--Ejercicio 2: Utilizando el Ejercicio 1 del TP 2 realice las siguientes acciones:
--2.1. Agregue un campo sueldo a la tabla PERSONAL e inserte masivamente datos en todas las tablas utilizando para ello algún generador de datos aleatorios (por ejemplo https://generatedata.com/es). Para ello deberá generar como mínimo 100 filas en más de una tabla e importar al menos una vez datos en los siguientes formatos:
--    - CSV con delimitador “;”
--    - SQL

-- Este script funciona con la base de datos llamada "hospital"

-- ¡Aclaración! Los datos de personal y hospital los generamos con los archivos "generador_hospitales.py" y "generador_personal.py". Estos programas realizan los archivos CSV con las características solicitadas en "hospital.csv" y "personal.csv". Estos archivos y el código fuente de los programas que los generan los adjuntaremos con la entrega de este script.

USE hospital;

ALTER TABLE personal
ADD COLUMN sueldo REAL,
ADD CONSTRAINT chk_sueldo CHECK(sueldo >= 0);


LOAD DATA LOCAL INFILE 'hospital.csv'
INTO TABLE hospitales
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Esta opción se pone si la primer fila del archivo .csv tiene el nombre de los campos de la tabla.

LOAD DATA LOCAL INFILE 'personal.csv'
INTO TABLE personal
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Esta opción se pone si la primer fila del archivo .csv tiene el nombre de los campos de la tabla.

-- El script SQL para cargar los datos es el siguiente: 
-- Cargamos primero los hospitales para no quebrantar la restricción de clave foránea con "personal":
INSERT INTO hospitales(nombre) 
VALUES 
('Sanatorio Francescoli'),
('Hospital Favaloro'),
('Hospital Italiano');

-- Inserción de datos para la tabla "personal": 
INSERT INTO personal (dni, nombre, apellidos, direccion, telefono, fecha_ingreso, nombre_hospital, sueldo)
VALUES
(84368452, 'Tiburcio', 'Riera', 'Acceso Calixto Alcolea', 6349, '2015-03-10', 'Sanatorio Francescoli', 801438.28),
(76564446, 'Juan Carlos', 'Guzman', 'Urbanización Xiomara Lopez', 8717, '2005-05-08', 'Hospital Italiano', 494997.94),
(22204531, 'Benito', 'Aramburu', 'Acceso de Silvia Echevarría', 8313, '2013-09-12', 'Hospital Favaloro', 281112.9),
(22740308, 'Sandra', 'Giralt', 'C. de Anastasio Querol', 5413, '1980-01-31', 'Hospital Italiano', 718070.5),
(62982559, 'Candela', 'Tejedor', 'Calle Hilario Torrens', 7569, '2023-03-26', 'Sanatorio Francescoli', 589961.82),
(77611813, 'Porfirio', 'Vilalta', 'Pasaje de África Rius', 5103, '2023-11-13', 'Sanatorio Francescoli', 506744.32),
(85606959, 'Cristina', 'Gracia', 'Ronda Angelina Ocaña', 7799, '1997-10-17', 'Hospital Favaloro', 643664.88),
(47803504, 'Amancio', 'Meléndez', 'Plaza de Atilio Izaguirre', 592, '1985-02-10', 'Hospital Italiano', 982777.39),
(41139736, 'Paz', 'Amores', 'Alameda Paola Campos', 6917, '2003-04-06', 'Hospital Italiano', 540794.11),
(80905981, 'Vasco', 'Rubio', 'C. Consuela Jordá', 4590, '2000-11-20', 'Hospital Italiano', 456943.3),
(94239433, 'Nazario', 'Córdoba', 'Pasadizo de Emiliana Torrent', 7797, '2008-12-21', 'Hospital Favaloro', 780481.87),
(16398961, 'Miguel Ángel', 'Belda', 'Cuesta de Manolo Falcón', 8227, '1994-07-03', 'Sanatorio Francescoli', 626586.19),
(62273490, 'Candela', 'Rosa', 'Ronda de Reyna López', 8924, '1984-09-03', 'Sanatorio Francescoli', 917611.64),
(14063505, 'Isabel', 'Escudero', 'Plaza de Antonio Baeza', 7929, '1994-05-12', 'Sanatorio Francescoli', 220473.3),
(16248971, 'Camila', 'Nogués', 'Urbanización Aurora Quevedo', 2255, '2006-12-02', 'Hospital Favaloro', 360035.64),
(92833825, 'Dolores', 'Paz', 'Rambla Obdulia Bosch', 3981, '2006-08-15', 'Hospital Italiano', 165780.43),
(97020656, 'Glauco', 'Piña', 'Rambla de Paula Español', 1450, '2018-02-07', 'Hospital Italiano', 206464.98),
(95860665, 'Caridad', 'Cuesta', 'Calle Aurelio Sancho', 4487, '2016-12-07', 'Sanatorio Francescoli', 752383.78),
(62315569, 'Adelaida', 'Bilbao', 'Pasadizo de Guillermo Trillo', 104, '2008-06-11', 'Sanatorio Francescoli', 817636.64),
(12863056, 'Fátima', 'Giralt', 'Pasaje Ruth Baños', 2513, '2002-03-16', 'Sanatorio Francescoli', 292114.4),
(15643481, 'Gracia', 'Ballesteros', 'Ronda Eva María Alemany', 8273, '1990-02-15', 'Sanatorio Francescoli', 534007.48),
(21239639, 'Cruz', 'Parejo', 'Callejón Cándida Falcón', 8954, '1983-07-09', 'Sanatorio Francescoli', 945100.61),
(90630943, 'Chuy', 'Gutierrez', 'Urbanización de Eleuterio Bernal', 5830, '2003-12-30', 'Hospital Favaloro', 422298.39),
(79948632, 'Soraya', 'Barral', 'Pasaje Visitación Ramis', 7150, '2003-12-23', 'Sanatorio Francescoli', 339666.14),
(20804584, 'Rafael', 'Rios', 'Pasadizo Maxi Daza', 9374, '1999-08-02', 'Hospital Favaloro', 413011.3),
(36721737, 'Óscar', 'Quintero', 'Calle de Ligia Romero', 1521, '2014-11-30', 'Sanatorio Francescoli', 852951.17),
(27718037, 'Sebastián', 'Carlos', 'Plaza de Rolando Miralles', 247, '1992-02-03', 'Hospital Italiano', 425499.22),
(71810801, 'Gisela', 'Solís', 'Cañada de Rodrigo Aragonés', 1785, '2004-10-20', 'Hospital Italiano', 389792.75),
(37643617, 'Isabel', 'Amador', 'Cañada de Esmeralda Tomé', 4867, '1989-10-22', 'Hospital Italiano', 154873.78),
(83260562, 'Constanza', 'Salamanca', 'C. de Sebastian Fuentes', 8422, '2002-07-24', 'Hospital Italiano', 302929.19),
(39833180, 'Luisina', 'Talavera', 'Pasaje Noa Alba', 2112, '2009-12-02', 'Sanatorio Francescoli', 567832.3),
(58366695, 'Fabiola', 'Alonso', 'Via Débora Carbó', 3517, '1999-04-09', 'Sanatorio Francescoli', 584828.36),
(67266756, 'Aroa', 'Millán', 'Paseo Herminia Aragón', 966, '1991-02-04', 'Hospital Italiano', 332403.44),
(83303561, 'Fito', 'Molins', 'Pasaje Haydée Salvà', 326, '1996-07-22', 'Hospital Italiano', 263113.37),
(73026026, 'Joaquín', 'Alberto', 'Cañada de Pascual Cabo', 5904, '1983-11-12', 'Hospital Favaloro', 885751.17),
(24100161, 'Elpidio', 'Barroso', 'Rambla de Cecilia Grau', 6767, '2006-05-12', 'Hospital Favaloro', 490209.67),
(44094593, 'Felicidad', 'Carbonell', 'Rambla Elpidio Machado', 1899, '2016-09-22', 'Sanatorio Francescoli', 785010.35),
(18072622, 'Benita', 'Cadenas', 'C. Blanca Dueñas', 8298, '1998-01-06', 'Sanatorio Francescoli', 766929.23),
(58087456, 'Charo', 'Mosquera', 'Rambla de Rosalinda Garay', 4800, '2012-11-08', 'Hospital Favaloro', 218183.49),
(51849758, 'Jennifer', 'Gual', 'Pasadizo de Dani Campoy', 7026, '1996-12-25', 'Sanatorio Francescoli', 557523.84),
(23042793, 'Bárbara', 'Tenorio', 'Cañada Manuela Falcó', 3811, '1987-12-30', 'Hospital Italiano', 651591.38),
(32970178, 'Fabio', 'Patiño', 'Alameda Azucena Azorin', 6309, '2006-09-10', 'Hospital Favaloro', 552326.69),
(32782662, 'Luis', 'Pérez', 'Urbanización Ramiro Tello', 5485, '2014-04-25', 'Hospital Italiano', 232963.82),
(60233553, 'Obdulia', 'Villegas', 'Pasaje de Saturnino Cobo', 5446, '2022-10-03', 'Sanatorio Francescoli', 685605.22),
(50015171, 'Natividad', 'Lledó', 'Cañada de Consuela Berenguer', 7005, '2020-02-03', 'Hospital Favaloro', 128125.73),
(13872558, 'Fausto', 'Viñas', 'Acceso Nereida Aroca', 7749, '1984-04-04', 'Hospital Favaloro', 291454.96),
(17474418, 'Casemiro', 'Bayo', 'Calle de Ruben Carmona', 8844, '1985-10-26', 'Hospital Favaloro', 150095.2),
(25798282, 'Chucho', 'Ropero', 'Rambla Ana Sofía Sierra', 8933, '1984-03-22', 'Hospital Italiano', 705446.84),
(17495266, 'América', 'Fábregas', 'Pasaje de Amarilis Álvaro', 9539, '2008-09-22', 'Sanatorio Francescoli', 207946.71),
(35896053, 'Maximiliano', 'Gutierrez', 'Glorieta Azahara Toro', 8366, '2006-04-08', 'Hospital Italiano', 598095.77),
(95845677, 'Bartolomé', 'Santiago', 'Via de Rebeca Verdú', 1759, '2023-09-21', 'Hospital Italiano', 286671.58),
(57581518, 'Isidora', 'Cerro', 'Vial de Dominga Catalán', 2214, '1985-06-25', 'Hospital Italiano', 848990.84),
(35556948, 'Encarnación', 'Borrell', 'Callejón de Arsenio Puerta', 9762, '1985-03-09', 'Hospital Italiano', 203194.93),
(49221656, 'Pili', 'Alberola', 'Vial Roxana Ocaña', 8513, '1994-04-03', 'Sanatorio Francescoli', 726291.5),
(90899022, 'Lucía', 'Ros', 'Calle de Ale Hernández', 3410, '1986-02-04', 'Hospital Favaloro', 920892.6),
(25618165, 'Lino', 'Borrego', 'Via de Maricela Moliner', 946, '2020-10-25', 'Hospital Italiano', 225235.32),
(15566135, 'Chelo', 'Crespi', 'Calle de Ana Castells', 7321, '2007-02-10', 'Hospital Favaloro', 535060.1),
(25451898, 'Natalio', 'Calderón', 'Rambla de Aitor Cisneros', 3433, '1985-03-06', 'Hospital Favaloro', 921492.59),
(33141446, 'Elpidio', 'Expósito', 'Pasaje de Guiomar Diez', 4394, '1994-12-23', 'Hospital Italiano', 747836.2),
(23720887, 'Emilio', 'Ángel', 'C. de Albano Pablo', 7069, '1988-06-02', 'Hospital Favaloro', 105532.92),
(32616703, 'Amado', 'Mendez', 'Camino de Melchor Quevedo', 8466, '2021-10-23', 'Sanatorio Francescoli', 608352.14),
(29563194, 'Eusebio', 'Goicoechea', 'Callejón de Marcelo Echeverría', 8181, '1988-12-21', 'Sanatorio Francescoli', 837824.1),
(81414578, 'José Manuel', 'Torrijos', 'Plaza de Eustaquio Rivero', 1216, '2013-03-26', 'Hospital Italiano', 779055.22),
(13801291, 'Jerónimo', 'Lobo', 'C. Régulo Viña', 4163, '2004-09-15', 'Sanatorio Francescoli', 550142.3),
(38763604, 'Elisabet', 'Quesada', 'Via Toño Hernández', 887, '2000-01-14', 'Sanatorio Francescoli', 996537.84),
(79611336, 'Silvio', 'Grande', 'Cuesta de Paco González', 125, '1999-03-19', 'Hospital Italiano', 900220.21),
(93743697, 'Marina', 'Escribano', 'Paseo Fernanda Arteaga', 531, '1982-01-03', 'Hospital Italiano', 543159.53),
(70186975, 'Javiera', 'Pallarès', 'Urbanización Víctor Mariño', 7442, '2000-10-28', 'Hospital Favaloro', 435107.49),
(50566619, 'Francisco Javier', 'Ojeda', 'Acceso Samanta Zabaleta', 5433, '1992-08-09', 'Sanatorio Francescoli', 761173.14),
(90890560, 'Mireia', 'Pol', 'Via Ascensión Santamaría', 6948, '2017-07-12', 'Hospital Favaloro', 397972.58),
(68057610, 'Javi', 'Armengol', 'Alameda Tiburcio Tapia', 228, '2008-11-07', 'Sanatorio Francescoli', 963268.56),
(42985116, 'Fidel', 'Cobos', 'Paseo Juan Francisco Romeu', 9340, '1995-11-15', 'Sanatorio Francescoli', 678279.46),
(20671253, 'Ariel', 'Coello', 'Rambla Candelaria Arellano', 6431, '2007-09-29', 'Sanatorio Francescoli', 680078.28),
(88619257, 'Isaac', 'Arellano', 'Acceso Cándida Armas', 2867, '2006-05-25', 'Hospital Italiano', 255768.49),
(40665010, 'Paz', 'Rius', 'Via Clímaco Pomares', 3175, '2020-01-03', 'Sanatorio Francescoli', 677537.86),
(94742496, 'Belén', 'Bueno', 'Cuesta de Manuelita Planas', 3235, '1988-06-23', 'Hospital Italiano', 433499.18),
(57862658, 'Manu', 'Cervantes', 'Glorieta Nico Múgica', 1497, '2019-10-14', 'Hospital Italiano', 524444.39),
(33976403, 'Noa', 'Bayona', 'Ronda de Elba Mendoza', 732, '1981-11-29', 'Sanatorio Francescoli', 355849.21),
(64497781, 'Nuria', 'Robles', 'Pasadizo de Jenaro Valenzuela', 1687, '2009-04-24', 'Hospital Italiano', 791535.15),
(12199053, 'Mohamed', 'Lorenzo', 'Cuesta de César Céspedes', 1669, '1997-10-10', 'Sanatorio Francescoli', 293978.39),
(25829375, 'Ámbar', 'Segovia', 'Cañada de Bernardino Ariño', 202, '1999-03-10', 'Hospital Italiano', 682148.0),
(48663409, 'Mario', 'Zabaleta', 'Pasaje Candelas Samper', 959, '1984-04-26', 'Sanatorio Francescoli', 697756.31),
(27314998, 'Rafa', 'Borrego', 'Cañada Felipa Gracia', 6976, '2012-10-08', 'Hospital Italiano', 705671.25),
(29528992, 'Natalia', 'Adán', 'Callejón de Eligio Almeida', 1752, '1987-01-01', 'Hospital Favaloro', 379528.79),
(31074600, 'Celestino', 'Carnero', 'Plaza Elena Melero', 3333, '2019-12-09', 'Sanatorio Francescoli', 846594.6),
(52152392, 'Aníbal', 'Lago', 'Avenida de Kike Poza', 7127, '1996-12-03', 'Hospital Favaloro', 184053.94),
(82496030, 'Rosario', 'Galvez', 'Pasaje Odalis Burgos', 6612, '2001-04-25', 'Sanatorio Francescoli', 302312.58),
(12024527, 'Gaspar', 'Vilalta', 'C. de Gertrudis Ferreras', 3725, '2017-05-31', 'Hospital Favaloro', 757010.76),
(48683441, 'Concepción', 'Escolano', 'Plaza Moisés Cortina', 3331, '1997-10-16', 'Sanatorio Francescoli', 139053.51),
(49728510, 'Isaura', 'Serna', 'Cañada Mariana Solé', 7750, '1993-09-29', 'Hospital Italiano', 999653.89),
(47511103, 'Luis', 'Suarez', 'Callejón Rosalía Cornejo', 5558, '1987-10-30', 'Sanatorio Francescoli', 787933.32),
(75240884, 'Wálter', 'Alcaraz', 'Via de Sabas Ríos', 6104, '1981-12-06', 'Hospital Italiano', 808583.47),
(51555428, 'Timoteo', 'Rozas', 'Urbanización de Pepita Canet', 6921, '1988-01-05', 'Hospital Favaloro', 657279.84),
(39150977, 'Nicodemo', 'Huertas', 'Paseo Joan Rodríguez', 6782, '2018-02-04', 'Sanatorio Francescoli', 447565.9),
(43479776, 'Tadeo', 'Cases', 'Cañada de Ernesto Guzmán', 2124, '2010-11-03', 'Hospital Italiano', 139849.28),
(58292017, 'Zacarías', 'Merino', 'Glorieta Emiliano Calatayud', 3206, '2014-02-08', 'Sanatorio Francescoli', 618660.26),
(67080764, 'Vinicio', 'Luna', 'Camino de Carina Perales', 4076, '2020-03-25', 'Hospital Italiano', 914057.67),
(74610377, 'Fernanda', 'Somoza', 'Paseo de Nayara Cañete', 6745, '1996-09-15', 'Hospital Italiano', 804374.15),
(81552389, 'Gertrudis', 'Arnal', 'Alameda de Manolo Navas', 3258, '2019-08-27', 'Sanatorio Francescoli', 609682.88),
(29970615, 'Ricardo', 'Llorente', 'Vial de Rufino Grau', 818, '1991-04-22', 'Hospital Favaloro', 796571.15);


--2.2. Otorgue un aumento del 10% a los sueldos del personal con un sueldo inferior a los $150.000 y del 5% a aquellos con un sueldo entre $150.000 y $200.000 inclusive
UPDATE personal SET sueldo = sueldo * 1.1 WHERE sueldo < 150000;

UPDATE personal SET sueldo = sueldo * 1.05 WHERE sueldo BETWEEN 150000 AND 200000;


-- Ejercicio 3: Sean las siguientes tablas de una base de datos de una inmobiliaria:
--  Inquilino(CUIT,Nombre,Apellido)
--  Alquiler(CUIT,Id_casa,Deuda)
--      Nota: Deuda >=0 (si es 0, no hay deuda)
--  Telefonos(CUIT,Fono)
--  Dueño(CUIT,Nombre,Apellido)
--  Casa(Id_casa,CUIT,Nro,Calle,Ciudad)

-- Cree una base de datos con las tablas correspondientes y escriba consultas sql que contesten las siguientes preguntas, cargando previamente algunos registros de manera tal que devuelvan resultados:
DROP DATABASE IF EXISTS alquileres;

CREATE DATABASE alquileres; 

USE alquileres;

-- Creamos los esquemas/tablas.
CREATE TABLE Persona (
	cuit INT(11),
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    PRIMARY KEY (cuit)
);

CREATE TABLE Inquilino (
	cuit INT(11),
    PRIMARY KEY (cuit),
    FOREIGN KEY (cuit) REFERENCES Persona(cuit) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Dueño (
	cuit INT(11),
    PRIMARY KEY (cuit),
    FOREIGN KEY (cuit) REFERENCES Persona(cuit) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Telefonos (
	cuit INT(11),
    fono INT,
	PRIMARY KEY (cuit),
    FOREIGN KEY (cuit) REFERENCES Persona(cuit)
);

CREATE TABLE Casa (
	id_casa INT AUTO_INCREMENT,
    cuit INT(11),
    nro SMALLINT UNSIGNED,
    calle VARCHAR(50),
    ciudad VARCHAR(50),
    PRIMARY KEY (id_casa),
    FOREIGN KEY (cuit) REFERENCES Dueño(cuit)
);

CREATE TABLE Alquiler (
	cuit INT(11),
    id_casa INT,
    deuda REAL,
    PRIMARY KEY (id_casa),
    FOREIGN KEY (id_casa) REFERENCES Casa(id_casa),
    FOREIGN KEY (cuit) REFERENCES Inquilino(cuit),
    CONSTRAINT chk_deuda CHECK (deuda >= 0)
);

-- Insertamos datos en las tablas
-- Insertar datos en la tabla Persona
INSERT INTO Persona (cuit, nombre, apellido) VALUES
(10000001, 'Juan', 'Pérez'),
(10000002, 'María', 'Pérez'),
(10000003, 'Carlos', 'López'),
(10000004, 'Ana', 'Martínez'),
(10000005, 'Luis', 'García'),
(10000006, 'Sofía', 'Rodríguez'),
(10000007, 'Miguel', 'Fernández'),
(10000008, 'Lucía', 'Sánchez'),
(10000009, 'Federico', 'Morales'),
(10000010, 'Elena', 'Navarro'),
(10000011, 'Sergio', 'Ramos'),
(10000012, 'Laura', 'Ortega'),
(10000013, 'Diego', 'Vega'),
(10000014, 'Patricia', 'Blanco'),
(10000015, 'Andrés', 'Castro'),
(10000016, 'Silvia', 'Suárez'),
(10000017, 'Jorge', 'Romero'),
(10000018, 'Carmen', 'Hernández'),
(10000019, 'Alberto', 'Delgado'),
(10000020, 'Isabel', 'Molina'),
(10000021, 'Roberto', 'Reyes'),
(10000022, 'Natalia', 'Ibáñez'),
(10000023, 'Ricardo', 'Gómez'),
(10000024, 'Sandra', 'Medina'),
(10000025, 'Pablo', 'Ruiz'),
(10000026, 'Marta', 'Campos'),
(10000027, 'Daniel', 'Santos'),
(10000028, 'Lucía', 'Vargas'),
(10000029, 'José', 'Nieto'),
(10000030, 'Beatriz', 'Flores'),
(10000031, 'Manuel', 'Cruz'),
(10000032, 'Rosa', 'Gallardo'),
(10000033, 'Francisco', 'Aguilar'),
(10000034, 'Eva', 'Pérez'),
(10000035, 'Antonio', 'Herrera'),
(10000036, 'Teresa', 'Jiménez'),
(10000037, 'Adrián', 'Méndez'),
(10000038, 'Ana', 'Lorenzo'),
(10000039, 'Luis', 'Santiago'),
(10000040, 'Carmen', 'Domínguez'),
(10000041, 'Miguel', 'Gil'),
(10000042, 'Gloria', 'Marín'),
(10000043, 'Javier', 'Soto'),
(10000044, 'Sofía', 'Benítez'),
(10000045, 'Raúl', 'Román'),
(10000046, 'Pilar', 'Fuentes'),
(10000047, 'Ángel', 'Campos'),
(10000048, 'María José', 'León'),
(10000049, 'Juan Manuel', 'Vidal'),
(10000050, 'Cristina', 'Durán'),
(10000051, 'Eduardo', 'Vicente'),
(10000052, 'Lorena', 'Carrasco'),
(10000053, 'Alfonso', 'Ferrer'),
(10000054, 'Alicia', 'Ramos'),
(10000055, 'Pedro', 'Soler'),
(10000056, 'Verónica', 'Cabrera'),
(10000057, 'Sebastián', 'Rey'),
(10000058, 'Rocío', 'Vega'),
(10000059, 'Óscar', 'Mora'),
(10000060, 'Inés', 'Moya'),
(10000061, 'Gabriel', 'Castillo'),
(10000062, 'Carolina', 'Peña'),
(10000063, 'Enrique', 'Ortega'),
(10000064, 'Paula', 'Silva'),
(10000065, 'Fernando', 'Lara'),
(10000066, 'Natalia', 'Ramos'),
(10000067, 'Gonzalo', 'Campos'),
(10000068, 'Alejandra', 'Núñez'),
(10000069, 'José Luis', 'Ibáñez'),
(10000070, 'Claudia', 'Santos'),
(10000071, 'Rubén', 'Vargas'),
(10000072, 'María', 'Méndez'),
(10000073, 'Iván', 'Sosa'),
(10000074, 'Patricia', 'Herrero'),
(10000075, 'Mario', 'Rojas'),
(10000076, 'Sara', 'Molina'),
(10000077, 'Agustín', 'Prieto'),
(10000078, 'Lorena', 'Cano'),
(10000079, 'Felipe', 'Benítez'),
(10000080, 'Esther', 'Pascual'),
(10000081, 'Víctor', 'López'),
(10000082, 'Alba', 'García'),
(10000083, 'Emilio', 'Sanz'),
(10000084, 'Ángela', 'Calvo'),
(10000085, 'Martín', 'Torres'),
(10000086, 'Nuria', 'Serrano'),
(10000087, 'Héctor', 'Ramos'),
(10000088, 'Elena', 'Mora'),
(10000089, 'Jorge', 'Vicente'),
(10000090, 'Ana María', 'Carmona'),
(10000091, 'Tomás', 'Gallardo'),
(10000092, 'Isabel', 'Rey'),
(10000093, 'Lucas', 'Marín'),
(10000094, 'Cristina', 'Vidal'),
(10000095, 'Andrés', 'Ortega'),
(10000096, 'Marta', 'Álvarez'),
(10000097, 'Jaime', 'Navarro'),
(10000098, 'Teresa', 'Rubio'),
(10000099, 'Alberto', 'Herrera'),
(10000100, 'Beatriz', 'Castro');

-- Insertar datos en la tabla Inquilino
INSERT INTO Inquilino (cuit) VALUES
(10000004),
(10000005),
(10000006),
(10000007),
(10000008),
(10000021),
(10000022),
(10000023),
(10000024),
(10000025),
(10000026),
(10000027),
(10000028),
(10000029),
(10000030),
(10000031),
(10000032),
(10000033),
(10000034),
(10000035),
(10000036),
(10000037),
(10000038),
(10000039),
(10000040),
(10000041),
(10000042),
(10000043),
(10000044),
(10000045),
(10000046),
(10000047),
(10000048),
(10000049),
(10000050),
(10000071),
(10000072),
(10000073),
(10000074),
(10000075),
(10000076),
(10000077),
(10000078),
(10000079),
(10000080),
(10000081),
(10000082),
(10000083),
(10000084),
(10000085),
(10000086),
(10000087),
(10000088),
(10000089),
(10000090),
(10000091),
(10000092),
(10000093),
(10000094),
(10000095),
(10000096),
(10000097),
(10000098),
(10000099),
(10000100);

-- Insertar más datos en la tabla Dueño
INSERT INTO Dueño (cuit) VALUES
(10000001),
(10000002),
(10000003),
(10000009),
(10000010),
(10000011),
(10000012),
(10000013),
(10000014),
(10000015),
(10000016),
(10000017),
(10000018),
(10000019),
(10000020),
(10000061),
(10000062),
(10000063),
(10000064),
(10000065),
(10000066),
(10000067),
(10000068),
(10000069),
(10000070);

-- Insertar datos en la tabla Telefonos
INSERT INTO Telefonos (cuit, fono) VALUES
(10000001, 111111111),
(10000002, 222222222),
(10000003, 333333333),
(10000004, 444444444),
(10000005, 555555555),
(10000006, 666666666),
(10000007, 777777777),
(10000008, 888888888),
(10000009, 999999053),
(10000010, 999999054),
(10000011, 999999055),
(10000012, 999999056),
(10000013, 999999057),
(10000014, 999999058),
(10000015, 999999059),
(10000016, 999999060),
(10000017, 999999061),
(10000018, 999999062),
(10000019, 999999063),
(10000020, 999999064),
(10000021, 999999065),
(10000022, 999999066),
(10000023, 999999067),
(10000024, 999999068),
(10000025, 999999069),
(10000026, 999999070),
(10000027, 999999071),
(10000028, 999999072),
(10000029, 999999073),
(10000030, 999999074),
(10000031, 999999075),
(10000032, 999999076),
(10000033, 999999077),
(10000034, 999999078),
(10000035, 999999079),
(10000036, 999999080),
(10000037, 999999081),
(10000038, 999999082),
(10000039, 999999083),
(10000040, 999999084),
(10000041, 999999085),
(10000042, 999999086),
(10000043, 999999087),
(10000044, 999999088),
(10000045, 999999089),
(10000046, 999999090),
(10000047, 999999091),
(10000048, 999999092),
(10000049, 999999093),
(10000050, 999999094),
(10000061, 999999095),
(10000062, 999999096),
(10000063, 999999097),
(10000064, 999999098),
(10000065, 999999099),
(10000066, 999999100),
(10000067, 999999101),
(10000068, 999999102),
(10000069, 999999103),
(10000070, 999999104),
(10000071, 999999105),
(10000072, 999999106),
(10000073, 999999107),
(10000074, 999999108),
(10000075, 999999109),
(10000076, 999999110),
(10000077, 999999111),
(10000078, 999999112),
(10000079, 999999113),
(10000080, 999999114),
(10000081, 999999115),
(10000082, 999999116),
(10000083, 999999117),
(10000084, 999999118),
(10000085, 999999119),
(10000086, 999999120),
(10000087, 999999121),
(10000088, 999999122),
(10000089, 999999123),
(10000090, 999999124),
(10000091, 999999125),
(10000092, 999999126),
(10000093, 999999127),
(10000094, 999999128),
(10000095, 999999129),
(10000096, 999999130),
(10000097, 999999131),
(10000098, 999999132),
(10000099, 999999133),
(10000100, 999999134);

-- Insertar datos en la tabla Casa
INSERT INTO Casa (cuit, nro, calle, ciudad) VALUES
(10000001, 123, 'Calle Principal', 'Ciudad A'),
(10000002, 1024, 'Carrera', 'Corrientes'),
(10000003, 789, 'Pasaje Tercero', 'Ciudad C'),
(10000009, 111, 'Avenida Central', 'Ciudad P'),
(10000010, 222, 'Boulevard Principal', 'Ciudad Q'),
(10000011, 333, 'Calle Secundaria', 'Ciudad R'),
(10000012, 444, 'Pasaje del Sol', 'Ciudad S'),
(10000013, 555, 'Camino Real', 'Ciudad T'),
(10000014, 666, 'Alameda del Sur', 'Ciudad U'),
(10000015, 777, 'Callejón Norte', 'Ciudad V'),
(10000016, 888, 'Paseo de las Flores', 'Ciudad W'),
(10000017, 999, 'Sendero de la Luna', 'Ciudad X'),
(10000018, 112, 'Glorieta del Este', 'Ciudad Y'),
(10000019, 223, 'Ronda del Oeste', 'Ciudad Z'),
(10000020, 334, 'Vía Láctea', 'Ciudad AA'),
(10000061, 445, 'Plaza Mayor', 'Ciudad BB'),
(10000062, 556, 'Calle de la Paz', 'Ciudad CC'),
(10000063, 667, 'Avenida Libertad', 'Ciudad DD'),
(10000064, 778, 'Bulevar del Río', 'Ciudad EE'),
(10000065, 889, 'Calle del Arte', 'Ciudad FF'),
(10000066, 990, 'Camino del Bosque', 'Ciudad GG'),
(10000067, 101, 'Pasaje de la Luz', 'Ciudad HH'),
(10000070, 202, 'Alameda Central', 'Ciudad II'),
(10000070, 303, 'Paseo del Parque', 'Ciudad JJ'),
(10000070, 404, 'Calle de los Poetas', 'Ciudad KK'),
(10000001, 24, 'Malibú Park', 'California');

-- Insertar más datos en la tabla Alquiler
INSERT INTO Alquiler (cuit, id_casa, deuda) VALUES
(10000021, 1, 0.00),
(10000022, 2, 120.00),
(10000023, 3, 0.00),
(10000024, 4, 80.50),
(10000025, 5, 0.00),
(10000026, 6, 60.00),
(10000027, 7, 0.00),
(10000028, 8, 90.75),
(10000029, 9, 0.00),
(10000030, 10, 110.00),
(10000031, 11, 0.00),
(10000032, 12, 70.00),
(10000033, 13, 0.00),
(10000034, 14, 130.00),
(10000035, 15, 0.00),
(10000036, 16, 0.00),
(10000037, 17, 95.00),
(10000038, 18, 0.00),
(10000039, 19, 0.00),
(10000040, 20, 50.00),
(10000041, 21, 0.00),
(10000042, 22, 85.00),
(10000043, 23, 0.00),
(10000044, 24, 0.00),
(10000100, 25, 115.00),
(10000100, 26, 500.00);

-- Ahora, hacemos las consultas. 

-- 3.1. Los arrendatarios que arriendan la casa ubicada en la calle Carrera nº 1024, Corrientes.
select *
from Persona p inner join Inquilino i on p.cuit = i.cuit inner join Alquiler a on p.cuit = a.cuit inner join Casa c on a.id_casa = c.id_casa
where c.calle like 'Carrera' and c.nro = 1024 and c.ciudad like 'Corrientes';

-- 3.2. ¿Cuánto le deben a María Pérez?
select sum(a.deuda) as DeudaTot
from Persona p inner join Dueño d on p.cuit = d.cuit inner join Casa c on d.cuit = c.cuit inner join Alquiler a on c.id_casa=a.id_casa 
where p.nombre like 'Maria' and p.apellido like 'Perez';

-- 3.3. ¿Cuál es la deuda total para cada dueño?
select distinct p.cuit,p.nombre,p.apellido, sum(a.deuda) DeudaTot
from Persona p inner join Dueño d on p.cuit = d.cuit inner join Casa c on d.cuit = c.cuit inner join Alquiler a on c.id_casa=a.id_casa
group by p.cuit;

-- 3.4. Liste todas las personas de la base de datos
select *
from Persona;

-- 3.5. Indique los dueños que poseen tres o más casas.
select p.cuit,p.nombre,p.apellido, count(c.id_casa) as casas
from Persona p inner join Dueño d on p.cuit = d.cuit inner join Casa c on d.cuit = c.cuit 
group by p.cuit,p.nombre,p.apellido
having count(c.id_casa) >= 3;

-- 3.6. Liste los dueños que tengan deudores en todas sus casas.
SELECT p.cuit, p.nombre, p.apellido
FROM Persona p INNER JOIN Dueño d ON p.cuit = d.cuit INNER JOIN Casa c ON d.cuit = c.cuit INNER JOIN Alquiler a ON c.id_casa = a.id_casa
GROUP BY p.cuit, p.nombre, p.apellido
HAVING COUNT(c.ID_Casa) = COUNT(CASE WHEN a.deuda > 0 THEN 1 END);

-- 3.7. Cree una vista (y luego compruebe su funcionamiento) que se llame “vw_estadisticas” que entregue estadísticas sobre los arrendatarios por casa. Liste:
-- 	* El promedio.
-- 	* La varianza.
-- 	* El máximo.
-- 	* El mínimo.

CREATE VIEW vw_estadísticas AS 
SELECT p.nombre, p.apellido,  a.cuit, MIN(deuda) AS deuda_mínima, MAX(deuda) AS deuda_máxima, VAR_POP(deuda) AS varianza, AVG(deuda) AS deuda_promedio 
FROM Alquiler AS a INNER JOIN Persona AS p ON a.cuit=p.cuit 
GROUP BY (cuit);


-- PARTE 2: Programación en bases de datos
-- EJERCICIO 1: Escenario de Alquiler de Películas
-- PROGRAMAS ALMACENADOS (en MySQL utilizar la rutina más adecuada según el caso: procedimiento o función)

-- 1. Crear un programa almacenado que tenga como parámetro de entrada un número entero (código de empleado: staff_id) y devuelva el monto total en pagos cobrados por ese empleado.
--
-- Como sólo tenemos que devolver un valor, consideramos que una función es la rutina más adecuada para la resolución de este punto.

DELIMITER $$

CREATE FUNCTION monto_total(p_staff_id TINYINT UNSIGNED)
RETURNS DECIMAL(10,2) 
NOT DETERMINISTIC -- La función es no determinística (NON-DETERMINISTIC) porque lo que devuelva depende de lo que haya en la tabla "payment".
BEGIN
	DECLARE monto_total DECIMAL(10,2);
	SET monto_total = (SELECT SUM(p.amount) FROM payment AS p WHERE p_staff_id = p.staff_id);
	
	IF monto_total IS NULL THEN
		SET monto_total = 0;
	END IF;
	
	RETURN (monto_total);
END $$

-- Volvemos a declarar el DELIMITER como ;
DELIMITER ;

SELECT monto_total(1);

-- 2. Crear un programa almacenado para ingresar nuevos actores, que tenga como parámetros de entrada los valores de first_name y last_name.
--
-- Como tenemos que modificar el estado de la base de datos (al insertar en ella más actores) la rutina adecuada es un procedimiento.

DELIMITER $$

CREATE PROCEDURE insertar_actor(IN p_first_name VARCHAR(45), IN p_last_name VARCHAR(45))
BEGIN
    INSERT INTO actor(first_name, last_name, last_update) VALUES (p_first_name, p_last_name, NOW());
END $$

DELIMITER ;

CALL insertar_actor ('Ricardo', 'Darín');

-- 3. Crear un programa almacenado que liste los nombres de los actores con apellidos que comiencen con una cadena de texto determinada por un parámetro de entrada (Valor predeterminado: comienza con A).

DELIMITER $$ 

CREATE PROCEDURE list_actor (IN cadena VARCHAR(5))
BEGIN
	-- Asignamos un valor por defecto si el parámetro es NULL o cadena vacía.
    IF cadena IS NULL OR cadena = '' THEN
        SET cadena = 'A';
    END IF;
	
	SELECT a.last_name AS Apellido, a.first_name AS Nombre 
	FROM actor AS a
	WHERE a.last_name LIKE CONCAT(cadena, '%');
END $$ 

DELIMITER ; 

CALL list_actor (NULL); -- De esta manera se "invoca" al valor por defecto.
CALL list_actor ('Pa');

-- 4. Crear un programa almacenado que realice una inserción de 26 actores en forma secuencial de la forma:
/*
	| Nom_Actor1 | Ape_Actor1 |
	| Nom_Actor2 | Ape_Actor2 |
	| Nom_Actor3 | Ape_Actor3 |

¡Atención! Hay un sentencia llamada "FOR EACH", pero su uso es exclusivo para los triggers. Veremos esta sentencia más adelante.

*/

-- Opción 1:
DELIMITER $$ 

CREATE PROCEDURE insert_actors26_v1 ()
BEGIN
    DECLARE i INT DEFAULT 1; -- Inicializar el contador

    WHILE i <= 26 DO
        -- Insertar el actor con nombre y apellido basados en el número secuencial
        INSERT INTO actor (first_name, last_name, last_update)
        VALUES (CONCAT('Nom_Actor', i), CONCAT('Ape_Actor', i), NOW());

        -- Incrementar el contador
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

CALL insert_actors26_v1();

-- Opción 2:
DELIMITER $$

CREATE PROCEDURE insert_actors26_v2()
BEGIN
    DECLARE i INT DEFAULT 1; -- Inicializar el contador

    REPEAT
        -- Insertar el actor con nombre y apellido basados en el número secuencial
        INSERT INTO actor (first_name, last_name, last_update)
        VALUES (CONCAT('Nom_Actor', i), CONCAT('Ape_Actor', i), NOW());

        -- Incrementar el contador
        SET i = i + 1;

    UNTIL i > 26 -- Condición de salida
    END REPEAT;

END $$

DELIMITER ;

CALL insert_actors26_v2();

-- 5. Crear un programa almacenado que inserte valores en la tabla de países (country) pero que además de estos parámetros requiera nombre de usuario y contraseña. Estos dos parámetros deben ser validados en la tabla staff con los campos username y password.

-- Esta es una forma de hacerlo (v1)
DELIMITER $$ 

CREATE PROCEDURE insert_country_v1 (IN par_username VARCHAR(16), IN par_password VARCHAR(40), IN par_country VARCHAR(50))
BEGIN
	DECLARE local_username VARCHAR(16) DEFAULT NULL;
    DECLARE local_password VARCHAR(40) DEFAULT NULL;
    SET local_username = (SELECT username FROM staff WHERE staff.username = par_username);
    SET local_password = (SELECT password FROM staff WHERE staff.password = par_password);
    
    IF local_username IS NOT NULL AND local_password IS NOT NULL THEN 
		INSERT INTO country(country, last_update) VALUES (par_country, NOW());
    ELSE
		SIGNAL SQLSTATE '45000'  -- Código de error genérico
		SET MESSAGE_TEXT = 'El usuario o la contraseña son incorrectos.';
    END IF;
    
END $$

DELIMITER ;

CALL insert_country_v1('Mike', '1234', 'Argentina'); -- No debería funcionar, la password es incorrecta.
CALL insert_country_v1('Mike', '8cb2237d0679ca88db6464eac60da96345513964', 'Argentina'); -- Usuario y contraseña correctas.

-- Otra forma alternativa de hacerlo (v2): 
DELIMITER $$

CREATE PROCEDURE insert_country_v2(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(50),
    IN p_country_name VARCHAR(50)
)
BEGIN
    DECLARE cuenta INT DEFAULT 0;

    -- Verificar si el usuario y la contraseña son válidos
    SELECT COUNT(*)
    INTO cuenta
    FROM staff
    WHERE username = p_username AND password = p_password;

    -- Si no se encuentra coincidencia, lanzar un error
    IF cuenta = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Usuario o contraseña incorrectos';
    ELSE
        -- Si las credenciales son correctas, insertar el país
        INSERT INTO country (country, last_update) VALUES (p_country_name, NOW());
    END IF;
END $$

DELIMITER ;

CALL insert_country_v2('Mike', '1234', 'Azerbaiyán'); -- No debería funcionar, la password es incorrecta.
CALL insert_country_v2('Mike', '8cb2237d0679ca88db6464eac60da96345513964', 'Azerbaiyán'); -- Usuario y contraseña correctas.

-- TRIGGERS
-- 6. Crear un trigger sobre la tabla category que en caso de que se borre una fila de ésta elimine las respectivas filas de la tabla film_category.
-- Notas: 
-- 		* `FOR EACH ROW` es una sentencia exclusiva de los TRIGGERS.
-- 		* Within the trigger body, the OLD and NEW keywords enable you to access columns in the rows affected by a trigger. OLD and NEW are MySQL extensions to triggers; they are not case-sensitive.  
DELIMITER $$

CREATE TRIGGER category_trigger1 BEFORE DELETE ON category FOR EACH ROW
BEGIN
    -- Eliminar las filas relacionadas en film_category
    DELETE FROM film_category WHERE film_category.category_id = OLD.category_id;
END $$

DELIMITER ;

-- Este trigger se dispará cuando hagamos, por ejemplo, una consulta como la siguiente: 
-- Antes de configurar el trigger, dicha sentencia no sería válida, ya que nos alertaría de que su ejecución no es posible por una restricción de clave foránea. 
DELETE FROM category WHERE category.category_id = 11;

-- 7. Crear un trigger que en caso de UPDATE del actor_id de la tabla actor, haga el correspondiente update en la tabla film_actor.

DELIMITER $$

CREATE TRIGGER actor_trigger1 AFTER UPDATE ON actor FOR EACH ROW 
BEGIN 

	UPDATE film_actor SET actor_id = NEW.actor_id WHERE actor_id = OLD.actor_id;

END $$ 

DELIMITER ;

UPDATE actor SET actor_id = 227 WHERE actor_id = 1; 

-- 8. Crear un trigger que en caso de inserción sobre la tabla city verifique la existencia del código de país correspondiente y en caso de no encontrarlo no realice el proceso.

DELIMITER $$ 

CREATE TRIGGER city_trigger1 BEFORE INSERT ON city FOR EACH ROW 
BEGIN 
	DECLARE user_country_id SMALLINT UNSIGNED DEFAULT NULL;
	SET user_country_id = (SELECT country_id FROM country WHERE country.country_id = NEW.country_id);
	
	IF user_country_id IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se encontró el código de país.';
	END IF;
END $$

DELIMITER ;

-- Probamos las consultas: 
INSERT INTO city(city, country_id, last_update) VALUES ('Resistencia', 3500, DEFAULT); -- No funciona. El 3500 no es un código de país válido y despliega el mensaje de error notificándonos.
INSERT INTO city(city, country_id, last_update) VALUES ('Resistencia', 112, DEFAULT); -- Funciona correctamente. En nuestra BD a la hora de ejecutar la sentencia el código 112 corresponde a Argentina.

-- 9. Crear un trigger en donde, si se insertan valores en la tabla payment, si el monto ingresado es mayor a 50, inserte en una tabla llamada AUDITORIA (previamente creada) los valores insertados.

-- Primero, creamos la tabla auditoría la cual será igual en su definición a la tabla "payment". 
CREATE TABLE auditoría LIKE payment; 

DELIMITER $$ 

-- NOTA: Para hacer que el valor de payment_id en la tabla auditoría coincida con el valor de payment_id en la tabla payment, el trigger debe ser un AFTER INSERT, ya que el valor de payment_id (que podría ser AUTO_INCREMENT) solo estará disponible después de que el registro haya sido insertado en la tabla payment.

CREATE TRIGGER payment_trigger1 AFTER INSERT ON payment FOR EACH ROW   
BEGIN 

	IF NEW.amount > 50 THEN 
		INSERT INTO auditoría(payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update) VALUES 
		(NEW.payment_id, NEW.customer_id, NEW.staff_id, NEW.rental_id, NEW.amount, NEW.payment_date, NEW.last_update);
	END IF;

END $$ 

DELIMITER ;

INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date, last_update) VALUES 
(1, 1, 1, 40, NOW(), DEFAULT); -- No impactará esta inserción en la tabla de auditorías.

INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date, last_update) VALUES 
(1, 1, 1, 60, NOW(), DEFAULT); -- Esta inserción se verá reflejada en la tabla de auditorías.

-- EJERCICIO 2: Bares y Cervezas
--
-- Dadas las siguientes relaciones
-- 	* CERVEZAS (nombre, fabricante)
-- 	* PRECIOS (Bar, Cerveza, Precio), Cerveza → CERVEZAS(nombre)


-- 1. Cree las tablas correspondientes.
-- Si existe previamente, borramos la base de datos "bares_y_cervezas". Luego, la creamos y la seleccionamos. Hicimos esto para que sea más sencillo probar el funcionamiento del script.

DROP DATABASE IF EXISTS bares_y_cervezas;
CREATE DATABASE bares_y_cervezas;
USE bares_y_cervezas;

CREATE TABLE cervezas (
    id_cerveza INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE COMMENT "Es necesaria la restricción de unicidad para este campo porque de otra manera no podría hacerse referencia a él desde la tabla 'precios'",
    fabricante VARCHAR(50)
);

CREATE TABLE precios (
	id_precio INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    bar VARCHAR(50),
    precio REAL,
    cerveza VARCHAR(50),
    CONSTRAINT fk_nombre_cerveza FOREIGN KEY (cerveza) REFERENCES cervezas (nombre),
    CONSTRAINT chk_precios CHECK (precio >= 0)
);


-- 2.
INSERT INTO cervezas (nombre, fabricante) VALUES 
('Sunday Morning',  'Nico'), 
("I'm Waiting For The Man", 'Nico'),
('Femme Fatale', 'Nico'),
('Venus In Furs', 'Nico'),
('Run Run Run', 'Nico'),
("All Tomorrow's Parties", 'Nico'),
('Heroin', 'Nico'),
('There She Goes Again', 'Nico'),
("I'll Be Your Mirror", 'Nico'),
("The Black Angel's Death Song", 'Nico'),
('European Son', 'Nico');

INSERT INTO precios (bar, precio, cerveza) VALUES
('The Velvet Underground', 15.00, 'Sunday Morning'),
('Johnny Cash', 19.00, 'Sunday Morning'),
('Nico', 24, "I'm waiting for the man"),
('The Animals', 23, 'Femme Fatale'),
('Frank Zappa', 45, 'Venus in Furs'),
('Cream', 23.00, 'Run run run'),
('Pink Floyd', 12, "All tomorrow's parties"),
('David Bowie', 115, 'Heroin'),
('Strange Brew', 14, 'There she goes again');


-- 3. Cree un disparador que asegure que cualquier cerveza añadida a la lista de precios figure ya en la lista de cervezas. Para ello, en caso de que la cerveza no aparezca, añadirá una nueva entrada a la lista dejando el fabricante a NULL.

DELIMITER $$

CREATE TRIGGER trigger_precios1 BEFORE INSERT ON precios FOR EACH ROW 
BEGIN

	DECLARE user_cerv VARCHAR(50) DEFAULT NULL;
	SET user_cerv = (SELECT nombre FROM cervezas WHERE NEW.cerveza = cervezas.nombre);
	
	IF user_cerv IS NULL THEN 
		INSERT INTO cervezas(nombre, fabricante) VALUES (NEW.cerveza, NULL);
	END IF;

END $$

DELIMITER ;

-- Probamos el trigger:
INSERT INTO precios (bar, precio, cerveza) VALUES ('Jamiroquai', 24.00, 'The Deftones');


-- 4. Suponga la siguiente relación: SUPER_PRECIOS (Bar, Cerveza, Precio, Fecha). Defina un disparador para guardar en la tabla correspondiente (SUPER_PRECIOS) una lista de aquellos bares que suban el precio de alguna de sus cervezas en un precio superior a $150, así como la marca de la cerveza, el nuevo precio asignado y la fecha en la que se realizó la actualización.

CREATE TABLE super_precios (
	bar VARCHAR(50),
	cerveza VARCHAR(50),
	precio REAL,
	fecha DATE
);

DELIMITER $$ 

CREATE TRIGGER trigger_precios2 BEFORE INSERT ON precios FOR EACH ROW 
BEGIN 
	IF NEW.precio > 150 THEN 
		INSERT INTO super_precios(bar, cerveza, precio, fecha) VALUES (NEW.bar, NEW.cerveza, NEW.precio, NOW());	
	END IF; 
END $$ 

DELIMITER ;

-- Probamos el trigger 
INSERT INTO precios (bar, precio, cerveza) VALUES ('Velvet Revolver', 240.00, 'Sweet Salami');


-- EJERCICIO 3: Histórico Socios del Videoclub
-- Dada la siguiente relación:
-- 	* SOCIO (num_soc, nombre, direccion, telefono)

-- 1. Cree la tabla correspondiente.

DROP DATABASE IF EXISTS videoclub;
CREATE DATABASE videoclub; 
USE videoclub;

CREATE TABLE socio (
	num_soc INT UNSIGNED,
	nombre VARCHAR(100),
	dirección VARCHAR(100),
	teléfono SMALLINT UNSIGNED
);

-- 2. Inserte algunos valores de prueba en la tabla recién creada.

INSERT INTO socio (num_soc, nombre, dirección, teléfono) VALUES
(1, 'Juan Perez', 'Calle 123', 3456),
(2, 'María López', 'Avenida Siempreviva 742', 7890),
(3, 'Carlos García', 'Pasaje Sin Nombre 4', 9876),
(4, 'Laura Gómez', 'Boulevard de los Sueños 200', 6543),
(5, 'Sofía Martínez', 'Calle de la Luna 50', 1234),
(6, 'Lucas Rodríguez', 'Avenida del Sol 300', 5678),
(7, 'Ana Fernández', 'Calle de las Estrellas 150', 4321),
(8, 'Pedro Sánchez', 'Pasaje del Tiempo 18', 8765),
(9, 'Gabriela Ramírez', 'Calle del Viento 120', 2345),
(10, 'Fernando Torres', 'Avenida del Mar 500', 5432),
(11, 'Martín Ortiz', 'Calle del Río 75', 6789),
(12, 'Daniela Castro', 'Calle de las Nubes 85', 8901),
(13, 'Sebastián Ruiz', 'Pasaje del Sol 2', 9870),
(14, 'Lucía Paredes', 'Avenida de la Libertad 400', 8760),
(15, 'Ignacio Espinoza', 'Boulevard del Amor 202', 7654),
(16, 'Valentina Gómez', 'Calle del Sueño 99', 4320),
(17, 'Emilia Vega', 'Avenida de la Paz 350', 3210),
(18, 'Mateo Navarro', 'Pasaje del Bosque 48', 6540),
(19, 'Paula Medina', 'Calle de los Ángeles 88', 9871),
(20, 'David Flores', 'Avenida de la Luz 60', 1235);

-- 3. Se desea mantener la información de los socios aunque estos se den de baja, para lo que se crea una tabla SOCIO_BAJA, que contiene los datos de socio y la fecha de baja, que se actualizará cada vez que se borre un socio, por tanto:

-- 3.1. Cree la tabla correspondiente a la relación SOCIO_BAJA --> SOCIO_BAJA (num_soc, nombre direccion, teléfono, fecha_baja).

CREATE TABLE socio_baja LIKE socio;
ALTER TABLE socio_baja ADD COLUMN fecha_baja DATE;

-- 3.2. Defina un disparador que se encargue de realizar la funcionalidad especificada. Documente los resultados con una copia de pantalla.

DELIMITER $$

CREATE TRIGGER trigger_socio1 BEFORE DELETE ON socio FOR EACH ROW
BEGIN 
	INSERT INTO socio_baja(num_soc, nombre, dirección, teléfono, fecha_baja) VALUES
	(OLD.num_soc, OLD.nombre, OLD.dirección, OLD.teléfono, NOW());
END $$

DELIMITER ;

-- 3.3. Elimine algunos datos de la tabla SOCIO con el fin de comprobar el correcto funcionamiento del disparador creado.

DELETE FROM socio WHERE num_soc = 1 LIMIT 1; -- Por seguridad, limitamos el borrado de los registros a uno solo por sentencia.

/* El resultado de esta consulta es el siguiente: 

mysql> select * from socio limit 5;
+---------+------------------+------------------------------+-----------+
| num_soc | nombre           | dirección                    | teléfono  |
+---------+------------------+------------------------------+-----------+
|       2 | María López      | Avenida Siempreviva 742      |      7890 |
|       3 | Carlos García    | Pasaje Sin Nombre 4          |      9876 |
|       4 | Laura Gómez      | Boulevard de los Sueños 200  |      6543 |
|       5 | Sofía Martínez   | Calle de la Luna 50          |      1234 |
|       6 | Lucas Rodríguez  | Avenida del Sol 300          |      5678 |
+---------+------------------+------------------------------+-----------+
5 rows in set (0,00 sec)


mysql> select * from socio_baja;
+---------+------------+------------+-----------+------------+
| num_soc | nombre     | dirección  | teléfono  | fecha_baja |
+---------+------------+------------+-----------+------------+
|       1 | Juan Perez | Calle 123  |      3456 | 2024-09-15 |
+---------+------------+------------+-----------+------------+
1 row in set (0,00 sec)

*/

-- EJERCICIO 4: Gestión de Almacenes
-- Dadas las siguientes relaciones:
-- PRODUCTO (cod_prod, descripción, proveedor, unid_vendidas)
-- ALMACEN (cod_prod_s, stock, stock_min, stock_max)

DROP DATABASE IF NOT EXISTS ALMACEN;
CREATE DATABASE ALMACEN;
USE ALMACEN; 

--  1. Cree las tablas correspondientes.

CREATE TABLE PRODUCTO (
    cod_prod INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(100),
    proveedor VARCHAR(100),
    unid_vendidas INT
    );

CREATE TABLE ALMACEN(
    cod_prod_s INT,
    stock INT,
    stock_min INT,
    stock_max INT,
    PRIMARY KEY (cod_prod_s),
    FOREIGN KEY (cod_prod_s) REFERENCES PRODUCTO(cod_prod_s)
    );

-- 2. Inserte algunos valores de prueba en la tabla ALMACEN

INSERT INTO PRODUCTO(descripcion,proveedor,unid_vendidas) 
VALUES 
    ("Baterias 9V","Energizer",40),
    ("Papel Higienico","Scott",74),
    ("Gaseosa Fanta 2.25L","Coca-Cola Company",150);

INSERT INTO ALMACEN
VALUES
    (1,50,1,500),
    (2,50,1,500),
    (3,50,1,5000);

--  3. Crear los disparadores necesarios para proporcionar la siguiente funcionalidad:
-- 3.1. Se desea mantener actualizado el stock del ALMACEN cada vez que se vendan unidades de un determinado producto.

DELIMITER $$

CREATE TRIGGER actualizar_stock
AFTER UPDATE ON PRODUCTO
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;
    DECLARE stock_min INT;
    DECLARE stock_max INT;
    DECLARE mensaje VARCHAR(255);

    UPDATE ALMACEN
    SET stock = stock - (NEW.unid_vendidas - OLD.unid_vendidas)
    WHERE cod_prod_s = NEW.cod_prod;

    SELECT stock, stock_min, stock_max INTO stock_actual, stock_min, stock_max
    FROM ALMACEN
    WHERE cod_prod_s = NEW.cod_prod;

    IF stock_actual < stock_min THEN
        SET mensaje = CONCAT('Stock bajo. Necesitas comprar ', stock_max - stock_actual, ' unidades.');
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = mensaje;
    END IF;
END$$

DELIMITER ;

-- RESULTADO
-- mysql> select * from ALMACEN;
-- +------------+-------+-----------+-----------+
-- | cod_prod_s | stock | stock_min | stock_max |
-- +------------+-------+-----------+-----------+
-- |          1 |     0 |         1 |       500 |
-- |          2 |    50 |         1 |       500 |
-- |          3 |    50 |         1 |      5000 |
-- +------------+-------+-----------+-----------+
-- 3 rows in set (0.00 sec)
--
-- mysql> UPDATE PRODUCTO SET unid_vendidas = (unid_vendidas + 5) where cod_prod = 2;
-- Query OK, 1 row affected (0.02 sec)
-- Rows matched: 1  Changed: 1  Warnings: 0

-- mysql> SELECT * FROM PRODUCTO;
-- +----------+---------------------+-------------------+---------------+
-- | cod_prod | descripcion         | proveedor         | unid_vendidas |
-- +----------+---------------------+-------------------+---------------+
-- |        1 | Baterias 9V         | Energizer         |            40 |
-- |        2 | Papel Higienico     | Scott             |            79 |
-- |        3 | Gaseosa Fanta 2.25L | Coca-Cola Company |           150 |
-- +----------+---------------------+-------------------+---------------+
-- 3 rows in set (0.00 sec)

-- mysql> SELECT * FROM ALMACEN;
-- +------------+-------+-----------+-----------+
-- | cod_prod_s | stock | stock_min | stock_max |
-- +------------+-------+-----------+-----------+
-- |          1 |     0 |         1 |       500 |
-- |          2 |    45 |         1 |       500 |
-- |          3 |    50 |         1 |      5000 |
-- +------------+-------+-----------+-----------+
-- 3 rows in set (0.00 sec)

-- 3.2. Cuando el stock esté por debajo del mínimo lanzar un mensaje de petición de compra. Se indicará el número de unidades a comprar, según el stock actual y el stock máximo

DELIMITER $$

CREATE TRIGGER verificar_stock_minimo
BEFORE UPDATE ON PRODUCTO
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;

    SELECT stock INTO stock_actual
    FROM ALMACEN
    WHERE cod_prod_s = NEW.cod_prod;

    IF stock_actual < (NEW.unid_vendidas - OLD.unid_vendidas) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para completar la venta.';
    END IF;
END$$

DELIMITER ;

-- 3.3 Si el stock es menor que el stock mínimo permitido, se debe impedir la venta.

DELIMITER $$

CREATE TRIGGER impedir_venta_sin_stock
BEFORE UPDATE ON PRODUCTO
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;

    SELECT stock INTO stock_actual
    FROM ALMACEN
    WHERE cod_prod_s = OLD.cod_prod;

    IF stock_actual < (NEW.unid_vendidas - OLD.unid_vendidas) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para completar la venta.';
    END IF;
END$$

DELIMITER ;

-- RESULTADO:
-- mysql> select * from PRODUCTO;
-- +----------+---------------------+-------------------+---------------+
-- | cod_prod | descripcion         | proveedor         | unid_vendidas |
-- +----------+---------------------+-------------------+---------------+
-- |        1 | Baterias 9V         | Energizer         |            40 |
-- |        2 | Papel Higienico     | Scott             |            74 |
-- |        3 | Gaseosa Fanta 2.25L | Coca-Cola Company |           150 |
-- +----------+---------------------+-------------------+---------------+
-- 3 rows in set (0.00 sec)

-- mysql> UPDATE PRODUCTO SET unid_vendidas = (unid_vendidas + 10) WHERE cod_prod = 1;
-- ERROR 1644 (45000): No hay suficiente stock para completar la venta.
-- mysql> select * from PRODUCTO;
-- +----------+---------------------+-------------------+---------------+
-- | cod_prod | descripcion         | proveedor         | unid_vendidas |
-- +----------+---------------------+-------------------+---------------+
-- |        1 | Baterias 9V         | Energizer         |            40 |
-- |        2 | Papel Higienico     | Scott             |            74 |
-- |        3 | Gaseosa Fanta 2.25L | Coca-Cola Company |           150 |
-- +----------+---------------------+-------------------+---------------+
-- 3 rows in set (0.00 sec)

-- 4. Inserte algunos datos de prueba en la tabla PRODUCTO que permitan comprobar el correcto funcionamiento de los disparadores anteriores. Documente los resultados con una copia de pantalla.
-- ¡Aclaración! Los resultados se pueden ver en los puntos anteriores, comentados debajo de la definición de los disparadores.


-- EJERCICIO 5: Base Multidimensional
-- Para la implementación de una base de datos que soporte análisis multidimensional se desea crear una tabla que almacene las diferentes características referidas a una fecha; esto es: día, día de la semana, mes, año, cuatrimestre… El esquema relacional de dicha tabla sería el siguiente:
-- TIEMPO (fecha, dia, dia_Semana, mes, cuatrimestre, anio)

CREATE DATABASE base_multidimensional;
USE base_multidimensional;

-- 1. Crear la tabla TIEMPO en la base de datos atendiendo al esquema relacional anterior; considerando el atributo fecha como clave primaria. El resto de los atributos no admiten valores nulos.
CREATE TABLE tiempo (
    fecha DATE PRIMARY KEY,       
    dia INT NOT NULL,             
    dia_semana VARCHAR(10) NOT NULL,  
    mes VARCHAR(15) NOT NULL,             
    cuatrimestre INT NOT NULL,    
    año INT NOT NULL            
);

-- 2. Crear un procedimiento almacenado que dado un entero obtenga en formato de texto el correspondiente mes. Por ejemplo:
-- call convertir_mes(1)
-- “Enero”
DELIMITER //
CREATE PROCEDURE convertir_mes(
IN numero INT,
OUT mes VARCHAR(15)
)
CASE numero
        WHEN 1 THEN SET mes = 'Enero';
        WHEN 2 THEN SET mes = 'Febrero';
        WHEN 3 THEN SET mes = 'Marzo';
        WHEN 4 THEN SET mes = 'Abril';
        WHEN 5 THEN SET mes = 'Mayo';
        WHEN 6 THEN SET mes = 'Junio';
        WHEN 7 THEN SET mes = 'Julio';
        WHEN 8 THEN SET mes = 'Agosto';
        WHEN 9 THEN SET mes = 'Septiembre';
        WHEN 10 THEN SET mes = 'Octubre';
        WHEN 11 THEN SET mes = 'Noviembre';
        WHEN 12 THEN SET mes = 'Diciembre';
        ELSE SET mes = 'Mes inválido';
    END CASE;
END //
DELIMITER ;

-- 3. Crear un procedimiento almacenado que recibiendo un rango de fechas introduzca en la tabla de TIEMPO una tupla por cada día comprendido entre ambas fechas. Por ejemplo:
-- call insertarTiempos(‘01/01/2012’,’10/01/2012’);
-- Después de la llamada al procedimiento “insertarTiempos” del ejemplo anterior, la tabla TIEMPOS debería contener la siguiente información:

-- Fecha dia Dia_Semana mes cuarto año
-- 01/01/2012 1 Jueves Enero Q1 2012
-- 02/01/2012 2 Viernes Enero Q1 2012
-- 03/01/2012 3 Sábado Enero Q1 2012
-- 04/01/2012 4 Domingo Enero Q1 2012
-- 05/01/2012 5 Lunes Enero Q1 2012
-- 06/01/2012 6 Martes Enero Q1 2012
-- 07/01/2012 7 Miércoles Enero Q1 2012
-- 08/01/2012 8 Jueves Enero Q1 2012
-- 09/01/2012 9 Viernes Enero Q1 2012
-- 10/01/2012 10 Sábado Enero Q1 2012

DELIMITER //
CREATE PROCEDURE insertarTiempos(
IN fecha_inicio DATE,
IN fecha_final DATE
)
BEGIN
DECLARE contador INT DEFAULT 1;
DECLARE fecha_contador DATE;
DECLARE dias_entre INT;

SET fecha_contador = fecha_inicio;
SET dias_entre = DATEDIFF(fecha_final, fecha_inicio) + 1;
	label1: LOOP
		IF contador <= dias_entre THEN
        CALL convertir_mes(MONTH(fecha_contador), @mes);
			INSERT INTO tiempo (fecha, dia, dia_semana, mes, cuatrimestre, año) 
            VALUES (fecha_contador, 
					DAY(fecha_contador),
                    DAYNAME(fecha_contador),
                    @mes,
                    QUARTER(fecha_contador),
                    YEAR(fecha_contador));
            SET fecha_contador = DATE_ADD(fecha_contador, INTERVAL 1 DAY);
            SET contador = contador+1;
		END IF;
		IF contador > dias_entre THEN
			LEAVE label1;
		END IF;
	END LOOP label1;
END //
DELIMITER ;
CALL insertarTiempos('2012-01-01', '2012-01-10');
SELECT * FROM tiempo;

-- 4. Ejecutar el procedimiento creado para que genere las tuplas correspondientes a los años 2011 y 2012.
CALL insertarTiempos('2011-01-01', '2012-12-31');
select * from tiempo;

-- La tabla TIEMPO creada anteriormente la utilizaremos para fechar las ventas realizadas por una empresa dedicada a la venta de materiales informáticos. Por tanto el esquema relacional de la base de datos quedaría de la siguiente forma.

-- TIEMPO (fecha, dia, dia_Semana, mes, cuatrimestre, anio)
-- VENTA (id_Venta,fecha, producto, unidades_vendidas, precio_unitario)

-- 5. Crear la tabla VENTA atendiendo al esquema relacional anterior; considerando el atributo id_venta como clave primaria. El resto de los atributos de la relación no pueden tomar valor nulo.
CREATE TABLE venta (
id_venta SMALLINT PRIMARY KEY AUTO_INCREMENT,
fecha DATE NOT NULL,
producto VARCHAR(75) NOT NULL,
precio_unitario FLOAT NOT NULL,
unidades_vendidas INT NOT NULL,
CONSTRAINT fk_venta_fecha FOREIGN KEY (fecha) REFERENCES tiempo(fecha)
);

-- 6. Crear un procedimiento/función almacenado llamado “registrar_venta” que recibiendo una fecha, un producto, el precio unitario del mismo y las unidades vendidas inserte los valores correspondientes en la tabla de ventas.
DELIMITER //
CREATE PROCEDURE registrar_venta (
IN f_recibida DATE,
IN n_producto VARCHAR(75),
IN p_unitario FLOAT,
IN u_vendidas INT
)
BEGIN
INSERT INTO venta (fecha, producto, precio_unitario, unidades_vendidas)
VALUES (
	f_recibida,
    n_producto,
    p_unitario,
    u_vendidas
);
END//
DELIMITER ;

-- 7. Utilizar el procedimiento almacenado creado anteriormente para realizar las siguientes ventas:

-- Fecha producto precio_unitario unidades_vendidas
-- 10/01/2011 Disco Duro 160 GB UDMA 100.00 4
-- 17/01/2011 Disco Duro 250 GB UDMA 125.00 2
-- 05/05/2011 Disco Duro 500 GB UDMA 150.00 10
-- 15/05/2011 Disco Duro 750 GB UDMA 175.00 1
-- 25/07/2011 Fuente Alimentación 1000W 55.20 4
-- 02/08/2011 Memoria 1GB DDR 400 10.98 40
-- 10/09/2011 Memoria 1GB DDR2 1066 22.65 2
-- 04/12/2011 Memoria 2GB DDR3 800 32.15 3
-- 05/12/2011 Memoria 1 GB Compact Flash 11.54 10
-- 10/02/2012 Memoria 2 GB Compact Flash 19.87 1
-- 11/05/2012 Memoria 8 GB Compact Flash 48.32 1
-- 12/06/2012 Memoria 1 GB Secure Digital 14.52 15
-- 14/08/2012 Memoria 2 GB Secure Digital 28.69 25
-- 21/08/2012 Antena Wifi Cisco Omnidireccional 67.12 2
-- 05/10/2012 Cable para antena 10 metros SMA 2.65 1
-- 24/10/2012 Adaptador de Bluetooth 200 metros
-- USB 2.0
-- 14.32 1
-- 26/11/2012 Adaptador de HomePlug Ethernet AV 23.16 10
-- 05/12/2012 Adaptador de Infrarojos USB 47.88 8
-- 19/12/2012 Hub 4 puertos USB 2.0 23.10 6

CALL registrar_venta('2011-01-10', 'Disco Duro 160 GB UDMA', 100.00, 4);
CALL registrar_venta('2011-01-17', 'Disco Duro 250 GB UDMA', 125.00, 2);
CALL registrar_venta('2011-05-05', 'Disco Duro 500 GB UDMA', 150.00, 10);
CALL registrar_venta('2011-05-15', 'Disco Duro 750 GB UDMA', 175.00, 1);
CALL registrar_venta('2011-07-25', 'Fuente Alimentación 1000W', 55.20, 4);
CALL registrar_venta('2011-08-02', 'Memoria 1GB DDR 400', 10.98, 40);
CALL registrar_venta('2011-09-10', 'Memoria 1GB DDR2 1066', 22.65, 2);
CALL registrar_venta('2011-12-04', 'Memoria 2GB DDR3 800', 32.15, 3);
CALL registrar_venta('2011-12-05', 'Memoria 1 GB Compact Flash', 11.54, 10);
CALL registrar_venta('2012-02-10', 'Memoria 2 GB Compact Flash', 19.87, 1);
CALL registrar_venta('2012-05-11', 'Memoria 8 GB Compact Flash', 48.32, 1);
CALL registrar_venta('2012-06-12', 'Memoria 1 GB Secure Digital', 14.52, 15);
CALL registrar_venta('2012-08-14', 'Memoria 2 GB Secure Digital', 28.69, 25);
CALL registrar_venta('2012-08-21', 'Antena Wifi Cisco Ominidireccional', 67.12, 2);
CALL registrar_venta('2012-10-05', 'Cable para antena 10 metros SMA', 2.65, 1);
CALL registrar_venta('2012-10-24', 'Adaptador de Bluetooth 200 metros USB 2.0', 14.32, 1);
CALL registrar_venta('2012-11-26', 'Adaptador de HomePlug Ethernet AV', 23.16, 10);
CALL registrar_venta('2012-12-05', 'Adaptador de Infrarojos USB', 47.88, 8);
CALL registrar_venta('2012-12-19', 'Hub 4 puertos USB 2.0', 23.10, 6);

-- 8. Crear un procedimiento “Mostrar_Estadísticas” que genere la siguiente información, considerando que la mayor venta se refiere a las ventas con mayor valor económico, no con mayor número de unidades vendidas:
    -- 1. Valor total de las ventas.
    -- 2. Valor total de las ventas en el año 2011.
    -- 3. Valor total de las ventas en 2012.
    -- 4. Listado ordenado de las ventas por día de la semana.
    -- 5. Listado ordenado de las ventas por mes del año.
    -- 6. Listado ordenado de la ventas por cuatrimestre del año.
DELIMITER //
CREATE PROCEDURE mostrar_estadisticas()
BEGIN
    SELECT 'Valor total de las ventas' AS titulo, SUM(precio_unitario * unidades_vendidas) AS valor_total_ventas
    FROM venta;

    SELECT 'Valor total de las ventas en 2011' AS titulo, SUM(precio_unitario * unidades_vendidas) AS valor_total_ventas_2011
    FROM venta JOIN tiempo ON venta.fecha = tiempo.fecha
    WHERE tiempo.año = 2011;

    SELECT 'Valor total de las ventas en 2012' AS titulo, SUM(precio_unitario * unidades_vendidas) AS valor_total_ventas_2012
    FROM venta JOIN tiempo ON venta.fecha = tiempo.fecha
    WHERE tiempo.año = 2012;

    SELECT 'Ventas por día de la semana' AS titulo, tiempo.dia_semana, SUM(precio_unitario * unidades_vendidas) AS valor_ventas
    FROM venta JOIN tiempo ON venta.fecha = tiempo.fecha
    GROUP BY tiempo.dia_semana
    ORDER BY FIELD(tiempo.dia_semana, 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo');

    SELECT 'Ventas por mes' AS titulo, tiempo.mes, SUM(precio_unitario * unidades_vendidas) AS valor_ventas
    FROM venta JOIN tiempo ON venta.fecha = tiempo.fecha
    GROUP BY tiempo.mes
    ORDER BY FIELD(tiempo.mes, 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre');

    SELECT 'Ventas por cuatrimestre' AS titulo, tiempo.cuatrimestre, SUM(precio_unitario * unidades_vendidas) AS valor_ventas
    FROM venta JOIN tiempo ON venta.fecha = tiempo.fecha
    GROUP BY tiempo.cuatrimestre
    ORDER BY tiempo.cuatrimestre;
    
END //

DELIMITER ;
CALL mostrar_estadisticas();

-- 9. Crear un evento programado para que diariamente, a las 0:00 horas, agregue un registro correspondiente a la fecha actual en la tabla TIEMPO.
DELIMITER //

CREATE EVENT insertar_fecha_diaria
ON SCHEDULE EVERY 1 DAY
STARTS CURDATE() 
DO
BEGIN
    DECLARE fecha_actual DATE;
    SET fecha_actual = CURDATE();
	CALL convertir_mes(MONTH(fecha_actual), @mes);
    INSERT INTO tiempo (fecha, dia, dia_semana, mes, cuatrimestre, año)
    VALUES (
        fecha_actual,               
        DAY(fecha_actual),            
        DAYNAME(fecha_actual),        
        @mes,      
        QUARTER(fecha_actual),      
        YEAR(fecha_actual)           
    );
END //
DELIMITER ;
SHOW events
