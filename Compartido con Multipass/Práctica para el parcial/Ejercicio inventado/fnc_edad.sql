
/* Esta función propone una solución para calcular la edad de un empleado. */
USE shoutdb;
DROP FUNCTION IF EXISTS fnc_calcular_edad;

DELIMITER $$

CREATE FUNCTION fnc_calcular_edad(fecha_nacimiento DATE)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE edad INT;

    SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
	
    RETURN edad;
END $$

DELIMITER ;