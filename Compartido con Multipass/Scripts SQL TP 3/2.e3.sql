
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

