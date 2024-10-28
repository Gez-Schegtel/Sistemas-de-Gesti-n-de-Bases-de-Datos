
/* Este código define un evento que se encarga de actualizar las edades de los empleados */

USE shoutdb;
DROP EVENT IF EXISTS evt_edad;

CREATE EVENT evt_edad ON SCHEDULE EVERY 1 YEAR STARTS CURRENT_TIMESTAMP + INTERVAL 5 MINUTE DO 
	UPDATE empleados SET edad = fnc_calcular_edad(fecha_nacimiento);

