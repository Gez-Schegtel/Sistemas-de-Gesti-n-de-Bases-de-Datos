
/* Este procedimiento está destinado a verificar el cumplimiento de la restricción de cobertura. */ 

USE shoutdb;
DROP PROCEDURE IF EXISTS prc_cobertura_v1;
DROP PROCEDURE IF EXISTS prc_cobertura_v2;
DROP TEMPORARY TABLE IF EXISTS temp_table;

DELIMITER $$ 

CREATE PROCEDURE prc_cobertura_v1 ()
BEGIN 
	IF EXISTS (
		SELECT 1 FROM (SELECT id_empleado FROM empleados EXCEPT (SELECT id_empleado FROM contratados UNION SELECT id_empleado FROM de_planta)) AS tabla_control
	) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡Atención! Hay empleados dados de alta en la base de datos que no figuran como contratados o como planta permanente.';
	END IF;
END $$

CREATE PROCEDURE prc_cobertura_v2 ()
BEGIN 
	CREATE TEMPORARY TABLE temp_table (
		id_empleado INT UNSIGNED
	);
	
	INSERT INTO temp_table (id_empleado) (SELECT id_empleado FROM empleados EXCEPT (SELECT id_empleado FROM contratados UNION SELECT id_empleado FROM de_planta));

	IF (SELECT COUNT(*) FROM temp_table) > 0 THEN
		SELECT * FROM temp_table;
		DROP TEMPORARY TABLE temp_table;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡Atención! Hay empleados dados de alta en la base de datos que no figuran como contratados o como planta permanente.';
	END IF;

END $$

DELIMITER ;
