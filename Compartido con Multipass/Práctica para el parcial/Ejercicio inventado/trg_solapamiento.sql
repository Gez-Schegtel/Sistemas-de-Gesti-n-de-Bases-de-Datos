
/* Este código se encarga de controlar la restricción de solapamiento dado por la jerarquía propuesta para la relación o tabla "empleado" */ 

USE shoutdb;
DROP TRIGGER IF EXISTS trg_contratados_insert;
DROP TRIGGER IF EXISTS trg_de_planta_insert;
DROP TRIGGER IF EXISTS trg_contratados_update; 
DROP TRIGGER IF EXISTS trg_de_planta_update; 

DELIMITER $$ 

CREATE TRIGGER trg_contratados_insert BEFORE INSERT ON contratados FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT 1 FROM de_planta WHERE de_planta.id_empleado = NEW.id_empleado) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado ya está registrado como un empleado de planta.';
	END IF;
END $$

CREATE TRIGGER trg_de_planta_insert BEFORE INSERT ON de_planta FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT 1 FROM contratados WHERE contratados.id_empleado = NEW.id_empleado) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado ya está registrado como un empleado de planta permanente.';
	END IF;
END $$

CREATE TRIGGER trg_contratados_update BEFORE UPDATE ON contratados FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM de_planta WHERE de_planta.id_empleado = NEW.id_empleado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado ya está registrado como un empleado de planta.';
    END IF;
END $$

CREATE TRIGGER trg_de_planta_update BEFORE UPDATE ON de_planta FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM contratados WHERE contratados.id_empleado = NEW.id_empleado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El empleado ya está registrado como un empleado contratados.';
    END IF;
END $$

DELIMITER ; 
