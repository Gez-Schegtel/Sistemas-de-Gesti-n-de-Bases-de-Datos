
/* Este código propone un procedimiento para calcular la edad de un empleado. */
USE shoutdb;
DROP PROCEDURE IF EXISTS prc_calcular_edad;

DELIMITER $$

CREATE PROCEDURE prc_calcular_edad (IN fecha_nacimiento DATE)
BEGIN 
    DECLARE edad INT;

    SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());

    SELECT edad;
END $$ 

DELIMITER ;