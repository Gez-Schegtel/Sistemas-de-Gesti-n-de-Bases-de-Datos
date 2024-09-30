
CREATE DATABASE IF NOT EXISTS bda2024;

USE bda2024;

CREATE TABLE tabla1 (
	id INT UNSIGNED AUTO_INCREMENT COMMENT "Identificador único",
	atr1 VARCHAR(20) UNIQUE,
	atr2 VARCHAR(20) NOT NULL,
	atr3 DATE,
	CONSTRAINT pk_tabla1 PRIMARY KEY (id)
) ENGINE = InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Tabla para almacenar información de empleados.';

