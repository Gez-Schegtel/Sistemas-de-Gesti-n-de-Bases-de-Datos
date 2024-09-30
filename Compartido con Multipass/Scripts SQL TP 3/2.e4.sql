
/*
* Esta versión es diferente a la que está en el trabajo, porque la hice yo (Juani). La del trabajo es de Fabri... Fabri's Version.
*/

-- EJERCICIO 4: Gestión de Almacenes
-- Dadas las siguientes relaciones:
-- 		PRODUCTO (cod_prod, descripción, proveedor, unid_vendidas)
-- 		ALMACEN (cod_prod_s, stock, stock_min, stock_max)

DROP DATABASE IF EXISTS almacen;
CREATE DATABASE almacen;
USE almacen;

-- 1. Cree las tablas correspondientes.

CREATE TABLE producto (
	cod_prod INT UNSIGNED,
	descripción TEXT,
	proveedor VARCHAR(60),
	unid_vendidas INT 
); 

CREATE TABLE almacen (
	cod_prod_s INT UNSIGNED,
	stock INT,
	stock_min INT,
	stock_max INT 
);

-- 2. Inserte algunos valores de prueba en la tabla ALMACEN.
INSERT INTO producto (cod_prod, descripción, proveedor, unid_vendidas)
VALUES (1, 'Televisor', 'Proveedor A', 19);

INSERT INTO almacen (cod_prod_s, stock, stock_min, stock_max)
VALUES (1, 15, 5, 100);

-- 3. Crear los disparadores necesarios para proporcionar la siguiente funcionalidad:
-- 		3.1. Se desea mantener actualizado el stock del ALMACEN cada vez que se vendan unidades de un determinado producto.

DELIMITER $$

CREATE TRIGGER actualizar_stock BEFORE UPDATE ON producto FOR EACH ROW
BEGIN
    -- Declarar variable para el stock actual
    DECLARE stock_actual INT;
    -- Obtener el stock actual del almacén
    SET stock_actual = (SELECT stock FROM almacen WHERE cod_prod_s = NEW.cod_prod);

    -- Verificar si hay suficiente stock para cubrir la venta
    IF stock_actual >= NEW.unid_vendidas THEN
        -- Actualizar el stock en el almacén restando las unidades vendidas
        UPDATE almacen SET stock = stock - NEW.unid_vendidas WHERE cod_prod_s = NEW.cod_prod;

        -- Acumular las unidades vendidas en la tabla producto
        SET NEW.unid_vendidas = OLD.unid_vendidas + NEW.unid_vendidas;
    ELSE
        -- Si no hay suficiente stock, lanzar un mensaje de error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock para realizar la venta.';
    END IF;
END $$

DELIMITER ;

-- 		3.2. Cuando el stock esté por debajo del mínimo lanzar un mensaje de petición de compra donde se indicará el número de unidades a comprar, según el stock actual y el stock máximo.

DELIMITER $$

CREATE TRIGGER peticion_compra AFTER UPDATE ON producto FOR EACH ROW
BEGIN
    -- Declarar variables para el stock actual y stock mínimo
    DECLARE stock_actual INT;
    DECLARE stock_minimo INT;
	DECLARE unidades_a_comprar INT;
    DECLARE mensaje VARCHAR(255);
    
    -- Obtener el stock actual y el stock mínimo desde la tabla almacen
    SET stock_actual = (SELECT stock FROM almacen WHERE cod_prod_s = NEW.cod_prod);
    SET stock_minimo = (SELECT stock_min FROM almacen WHERE cod_prod_s = NEW.cod_prod);

    -- Verificar si el stock está por debajo del mínimo permitido
    IF stock_actual < stock_minimo THEN
        -- Calcular cuántas unidades deben comprarse
        SET unidades_a_comprar = (SELECT stock_max - stock_actual FROM almacen WHERE cod_prod_s = NEW.cod_prod);

        -- Lanzar un mensaje sugiriendo la cantidad de unidades a comprar
        SET mensaje = CONCAT('El stock está por debajo del mínimo. Se deben comprar ', unidades_a_comprar, ' unidades para alcanzar el stock máximo.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje;
    END IF;
END $$

DELIMITER ;

-- 		3.3. Si el stock es menor que el stock mínimo permitido, se debe impedir la venta.

DELIMITER $$

CREATE TRIGGER impedir_venta_stock_bajo BEFORE UPDATE ON producto FOR EACH ROW
BEGIN
    -- Declarar variables para el stock actual y stock mínimo
    DECLARE stock_actual INT;
    DECLARE stock_minimo INT;

    -- Obtener el stock actual y el stock mínimo desde la tabla almacen
    SET stock_actual = (SELECT stock FROM almacen WHERE cod_prod_s = NEW.cod_prod);
    SET stock_minimo = (SELECT stock_min FROM almacen WHERE cod_prod_s = NEW.cod_prod);

    -- Impedir la venta si el stock actual es menor que el mínimo permitido
    IF stock_actual < stock_minimo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede realizar la venta: el stock actual es menor que el mínimo permitido.';
    END IF;
END $$

DELIMITER ;

-- 4. Inserte algunos datos de prueba en la tabla PRODUCTO que permitan comprobar el correcto funcionamiento de los disparadores anteriores. Documente los resultados con una copia de pantalla.

UPDATE producto SET unid_vendidas = 5 WHERE cod_prod = 1;
UPDATE producto SET unid_vendidas = 10 WHERE cod_prod = 1;
UPDATE producto SET unid_vendidas = 50 WHERE cod_prod = 1;
