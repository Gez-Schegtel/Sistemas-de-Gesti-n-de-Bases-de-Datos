use sakila;

CREATE USER 'George Harrison'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'George Harrison'@'%';
GRANT GRANT OPTION ON *.* TO 'George Harrison'@'%';
FLUSH PRIVILEGES;

-- Ejercicio 1

-- Punto a)
mysql -u George Harrison -p1234
CREATE USER jPerez@'%';
CREATE USER aFernandez@'%';


mysql -u jPerez; 
ALTER USER 'jPerez'@'%' identified by "contraseña_segura";
mysql -u aFernandez;
ALTER USER 'aFernandez'@'%' identified by "contraseña_muy_segura";


-- Punto b)
mysql -u 'George Harrison' -p1234 -e "GRANT INSER, UPDATE ON sakila.country YO 'jPerez'@'%','aFernandez'@'%' ";
mysql -u jPerez -pcontraseña_segura -e "SHOW GRANTS";
mysql -u aFernandez -pcontraseña_muy_segura -e "SHOW GRANTS";


-- Punto c)
mysql -u George Harrison -p1234;

DELIMITER $$
REVOKE UPDATE ON sakila.country FROM 'jPerez'@'%';
CREATE USER 'jPerez'@'localhost' IDENTIFIED BY 'contraseña_segura';
GRANT INSERT,UPDATE ON sakila.country TO 'jPerez'@'localhost';
SHOW GRANTS FOR 'jPerez'@'%';
SHOW GRANTS FOR 'jPerez'@'localhost';

REVOKE UPDATE ON sakila.country FROM 'aFernandez'@'%';
CREATE USER 'aFernandez'@'localhost' IDENTIFIED BY 'contraseña_muy_segura';
GRANT INSERT,UPDATE ON sakila.country TO 'aFernandez'@'localhost';
SHOW GRANTS FOR 'aFernandez'@'%';
SHOW GRANTS FOR 'aFernandez'@'localhost';

$$
DELIMITER;

-- Punto d)
mysql -u George Harrison -p1234 -e "GRANT CREATE ON sakila.* to 'jPerez'@'localhost','jPerez'@'%';SHOW GRANTS FOR 'jPerez'@'localhost';SHOW GRANTS FOR 'jPerez'@'%';";

-- Punto e)
mysql -u George Harrison -p1234 -e "GRANT CREATE ON sakila.addres to jPerez'@'localhost','jPerez'@'%';SHOW GRANTS FOR 'jPerez'@'localhost';SHOW GRANTS FOR 'jPerez'@'%';";

-- Punto f)
REVOKE SELECT ON sakila.addres from 'jPerez'@'%';
REVOKE SELECT ON sakila.addres from 'jPerez'@'localhost';

GRANT SELECT (address_id,address,address2,district,city_id,postal_code,phone) ON sakila.address TO 'jPerez'@'%';
GRANT SELECT (address_id,address,address2,district,city_id,postal_code,phone) ON sakila.address TO 'jPerez'@'localhost';

-- Punto g)
grant all on sakila.* to 'jPerez'@'%', 'aFernandez'@'%';
grant all on sakila.* to 'jPerez'@'localhost', 'aFernandez'@'localhost';

-- Punto h)
REVOKE LOCK TABLES, SELECT, RELOAD ON *.* FROM ‘aFernandez’@’%’;