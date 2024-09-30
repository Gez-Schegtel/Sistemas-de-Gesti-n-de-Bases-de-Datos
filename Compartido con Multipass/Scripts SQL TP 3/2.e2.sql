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

