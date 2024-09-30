-- Ejercicio 5: Base Multidimensional
DROP DATABASE IF EXISTS base_multidimensional;
CREATE DATABASE base_multidimensional;
USE base_multidimensional;

-- 1
CREATE TABLE tiempo (
	fecha DATE,
	día TINYINT UNSIGNED NOT NULL,
	día_semana ENUM ('Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'),
	mes ENUM ('Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'),
	trimestre ENUM ('Q1', 'Q2', 'Q3', 'Q4'),
	año YEAR NOT NULL,
	PRIMARY KEY (fecha),
	CONSTRAINT chk_día_válido CHECK (día <= DAY(LAST_DAY(CONCAT(año, '-', 
		CASE mes
			WHEN 'Enero' THEN '01'
			WHEN 'Febrero' THEN '02'
			WHEN 'Marzo' THEN '03'
			WHEN 'Abril' THEN '04'
			WHEN 'Mayo' THEN '05'
			WHEN 'Junio' THEN '06'
			WHEN 'Julio' THEN '07'
			WHEN 'Agosto' THEN '08'
			WHEN 'Septiembre' THEN '09'
			WHEN 'Octubre' THEN '10'
			WHEN 'Noviembre' THEN '11'
			WHEN 'Diciembre' THEN '12'
		END, '-01'))))
);

-- 2
DELIMITER $$

CREATE PROCEDURE convertir_mes_v1 (IN número TINYINT UNSIGNED)
BEGIN

	DECLARE mes VARCHAR(10);
	
	CASE número 
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
		ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Número de mes inválido. El valor debe estar comprendido entre uno (1) y doce (12).';
	END CASE;
	
	SELECT mes; -- Devolvemos por pantalla el valor. 
END $$

CREATE PROCEDURE convertir_mes_v2 (IN numero INT, OUT mes VARCHAR(15))
BEGIN
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
END $$ 

DELIMITER ;

-- Personalmente creo que todo esto es una locura, y que no se justifica hacer este procedimiento con una variable de salida porque ello implica definir una variable global y tener que hacer una consulta para obtener la conversión.

-- 3
DELIMITER $$

CREATE PROCEDURE insertar_tiempos(IN fecha_inicio DATE, IN fecha_fin DATE)
BEGIN
    WHILE fecha_inicio <= fecha_fin DO
        -- Insertar una nueva fila en la tabla TIEMPO
        INSERT INTO tiempo (fecha, día, día_semana, mes, trimestre, año)
        VALUES (
            fecha_inicio, -- La fecha actual
            DAY(fecha_inicio), -- El día del mes
            CASE DAYOFWEEK(fecha_inicio) -- El nombre del día de la semana
                WHEN 1 THEN 'Domingo'
                WHEN 2 THEN 'Lunes'
                WHEN 3 THEN 'Martes'
                WHEN 4 THEN 'Miércoles'
                WHEN 5 THEN 'Jueves'
                WHEN 6 THEN 'Viernes'
                WHEN 7 THEN 'Sábado'
            END,
            CASE MONTH(fecha_inicio) -- El nombre del mes
                WHEN 1 THEN 'Enero'
                WHEN 2 THEN 'Febrero'
                WHEN 3 THEN 'Marzo'
                WHEN 4 THEN 'Abril'
                WHEN 5 THEN 'Mayo'
                WHEN 6 THEN 'Junio'
                WHEN 7 THEN 'Julio'
                WHEN 8 THEN 'Agosto'
                WHEN 9 THEN 'Septiembre'
                WHEN 10 THEN 'Octubre'
                WHEN 11 THEN 'Noviembre'
                WHEN 12 THEN 'Diciembre'
            END,
            CASE -- El cuarto del año
                WHEN MONTH(fecha_inicio) BETWEEN 1 AND 3 THEN 'Q1'
                WHEN MONTH(fecha_inicio) BETWEEN 4 AND 6 THEN 'Q2'
                WHEN MONTH(fecha_inicio) BETWEEN 7 AND 9 THEN 'Q3'
                WHEN MONTH(fecha_inicio) BETWEEN 10 AND 12 THEN 'Q4'
            END,
            YEAR(fecha_inicio) -- El año de la fecha
        );

        -- Avanzar al siguiente día
        SET fecha_inicio = DATE_ADD(fecha_inicio, INTERVAL 1 DAY);
    END WHILE;
END $$

DELIMITER ;

-- 4 
CALL insertar_tiempos ('2011-01-01', '2012-12-31');

-- 5 
CREATE TABLE ventas (
	id_venta INT UNSIGNED AUTO_INCREMENT,
	fecha DATE NOT NULL,
	producto VARCHAR(255) NOT NULL,
	unidades_vendidas INT UNSIGNED NOT NULL,
	precio_unitario DECIMAL(20,2) NOT NULL,
	PRIMARY KEY (id_venta),
	CONSTRAINT chk_precio_unitario CHECK (precio_unitario >= 0)
);

-- 6 
--	Como tengo que insertar datos en una tabla, lo correcto es usar un procedimiento para la resolución de esta consigna.
DELIMITER $$

CREATE PROCEDURE registrar_venta (IN fecha DATE, IN producto VARCHAR(255), IN unidades_vendidas INT, precio_unitario DECIMAL(20,2))
BEGIN 
	INSERT INTO ventas (fecha, producto, unidades_vendidas, precio_unitario) VALUES (fecha, producto, unidades_vendidas, precio_unitario);
END $$ 

DELIMITER ;

-- 7
CALL registrar_venta('2011-01-10', 'Disco Duro 160 GB UDMA', 4, 100.00);
CALL registrar_venta('2011-01-17', 'Disco Duro 250 GB UDMA', 2, 125.00);
CALL registrar_venta('2011-05-05', 'Disco Duro 500 GB UDMA', 10, 150.00);
CALL registrar_venta('2011-05-15', 'Disco Duro 750 GB UDMA', 1, 175.00);
CALL registrar_venta('2011-07-25', 'Fuente Alimentación 1000W', 4, 55.20);
CALL registrar_venta('2011-08-02', 'Memoria 1GB DDR 400', 40, 10.98);
CALL registrar_venta('2011-09-10', 'Memoria 1GB DDR2 1066', 2, 22.65);
CALL registrar_venta('2011-12-04', 'Memoria 2GB DDR3 800', 3, 32.15);
CALL registrar_venta('2011-12-05', 'Memoria 1 GB Compact Flash', 10, 11.54);
CALL registrar_venta('2012-02-10', 'Memoria 2 GB Compact Flash', 1, 19.87);
CALL registrar_venta('2012-05-11', 'Memoria 8 GB Compact Flash', 1, 48.32);
CALL registrar_venta('2012-06-12', 'Memoria 1 GB Secure Digital', 15, 14.52);
CALL registrar_venta('2012-08-14', 'Memoria 2 GB Secure Digital', 25, 28.69);
CALL registrar_venta('2012-08-21', 'Antena Wifi Cisco Omnidireccional', 2, 67.12);
CALL registrar_venta('2012-10-05', 'Cable para antena 10 metros SMA', 1, 2.65);
CALL registrar_venta('2012-10-24', 'Adaptador de Bluetooth 200 metros USB 2.0', 1, 14.32);
CALL registrar_venta('2012-11-26', 'Adaptador de HomePlug Ethernet AV', 10, 23.16);
CALL registrar_venta('2012-12-05', 'Adaptador de Infrarrojos USB', 8, 47.88);
CALL registrar_venta('2012-12-19', 'Hub 4 puertos USB 2.0', 6, 23.10);

-- 8
DELIMITER $$

CREATE PROCEDURE mostrar_estadísticas ()
BEGIN 

	/* Atención: Este procedimiento necesita que la base de datos esté configurada con los nombres de los días y meses en español para poder ordenar los mismos adecuadamente.
	* Si te interesa setear la base de datos en español, ingresar en la terminal de MySQL el siguiente comando: SET lc_time_names = 'es_ES';
	* Si la base de datos está seteada en inglés, o en otro idioma, el procedimiento funcionará, pero no podrá ordenar adecuadamente los días.
	*/
	
	SELECT SUM(unidades_vendidas * precio_unitario) AS 'Valor total de las ventas' FROM ventas;
	SELECT SUM(unidades_vendidas * precio_unitario) AS 'Valor total de las ventas del 2011' FROM ventas WHERE YEAR(fecha) = '2011';
	SELECT SUM(unidades_vendidas * precio_unitario) AS 'Valor total de las ventas del 2012' FROM ventas WHERE YEAR(fecha) = '2012';

	SELECT DAYNAME(fecha) AS Día, COUNT(*) AS 'Número de ventas del día', SUM(unidades_vendidas * precio_unitario) AS 'Valor de las ventas'
	FROM ventas
	GROUP BY (Día)
	ORDER BY FIELD(Día, 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo');
	
	SELECT YEAR(fecha) AS Año, MONTHNAME(fecha) AS Mes, COUNT(*) AS 'Número de ventas del mes', SUM(unidades_vendidas * precio_unitario) AS 'Valor de las ventas'
	FROM ventas
	GROUP BY Año, Mes
	ORDER BY Año, FIELD(mes, 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre');

	SELECT YEAR(fecha) AS Año, QUARTER(fecha) AS Trimestre, COUNT(*) AS 'Número de ventas del cuatrimestro', SUM(unidades_vendidas * precio_unitario) AS 'Valor de las ventas'
	FROM ventas
	GROUP BY Año, Trimestre
	ORDER BY Año, Trimestre;

END $$

DELIMITER ;

-- 9
CREATE EVENT insertar_fecha_diaria
ON SCHEDULE EVERY 1 HOUR 
STARTS CURRENT_DATE + INTERVAL 1 DAY -- Comienza hoy a las 00:00
DO
    INSERT INTO tiempo (fecha, día, día_semana, mes, trimestre, año)
    VALUES (
        CURDATE(),                   -- Fecha actual
        DAY(CURDATE()),              -- Día del mes
        DAYNAME(CURDATE()),          -- Nombre del día de la semana (Lunes, Martes, etc.)
        MONTHNAME(CURDATE()),        -- Nombre del mes (Enero, Febrero, etc.)
        QUARTER(CURDATE()),          -- Trimestre
        YEAR(CURDATE())              -- Año actual
    );

