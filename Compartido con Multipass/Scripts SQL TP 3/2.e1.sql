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
