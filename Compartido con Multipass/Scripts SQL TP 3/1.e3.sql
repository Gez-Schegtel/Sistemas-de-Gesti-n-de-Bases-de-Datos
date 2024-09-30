

DROP DATABASE IF EXISTS alquileres;

CREATE DATABASE alquileres; 

USE alquileres;

-- Creamos los esquemas/tablas.
CREATE TABLE Persona (
	cuit INT(11),
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    PRIMARY KEY (cuit)
);

CREATE TABLE Inquilino (
	cuit INT(11),
    PRIMARY KEY (cuit),
    FOREIGN KEY (cuit) REFERENCES Persona(cuit) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Dueño (
	cuit INT(11),
    PRIMARY KEY (cuit),
    FOREIGN KEY (cuit) REFERENCES Persona(cuit) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Telefonos (
	cuit INT(11),
    fono INT,
	PRIMARY KEY (cuit),
    FOREIGN KEY (cuit) REFERENCES Persona(cuit)
);

CREATE TABLE Casa (
	id_casa INT AUTO_INCREMENT,
    cuit INT(11),
    nro SMALLINT UNSIGNED,
    calle VARCHAR(50),
    ciudad VARCHAR(50),
    PRIMARY KEY (id_casa),
    FOREIGN KEY (cuit) REFERENCES Dueño(cuit)
);

CREATE TABLE Alquiler (
	cuit INT(11),
    id_casa INT,
    deuda REAL,
    PRIMARY KEY (id_casa),
    FOREIGN KEY (id_casa) REFERENCES Casa(id_casa),
    FOREIGN KEY (cuit) REFERENCES Inquilino(cuit),
    CONSTRAINT chk_deuda CHECK (deuda >= 0)
);

-- Insertamos datos en las tablas
-- Insertar datos en la tabla Persona
INSERT INTO Persona (cuit, nombre, apellido) VALUES
(10000001, 'Juan', 'Pérez'),
(10000002, 'María', 'Pérez'),
(10000003, 'Carlos', 'López'),
(10000004, 'Ana', 'Martínez'),
(10000005, 'Luis', 'García'),
(10000006, 'Sofía', 'Rodríguez'),
(10000007, 'Miguel', 'Fernández'),
(10000008, 'Lucía', 'Sánchez'),
(10000009, 'Federico', 'Morales'),
(10000010, 'Elena', 'Navarro'),
(10000011, 'Sergio', 'Ramos'),
(10000012, 'Laura', 'Ortega'),
(10000013, 'Diego', 'Vega'),
(10000014, 'Patricia', 'Blanco'),
(10000015, 'Andrés', 'Castro'),
(10000016, 'Silvia', 'Suárez'),
(10000017, 'Jorge', 'Romero'),
(10000018, 'Carmen', 'Hernández'),
(10000019, 'Alberto', 'Delgado'),
(10000020, 'Isabel', 'Molina'),
(10000021, 'Roberto', 'Reyes'),
(10000022, 'Natalia', 'Ibáñez'),
(10000023, 'Ricardo', 'Gómez'),
(10000024, 'Sandra', 'Medina'),
(10000025, 'Pablo', 'Ruiz'),
(10000026, 'Marta', 'Campos'),
(10000027, 'Daniel', 'Santos'),
(10000028, 'Lucía', 'Vargas'),
(10000029, 'José', 'Nieto'),
(10000030, 'Beatriz', 'Flores'),
(10000031, 'Manuel', 'Cruz'),
(10000032, 'Rosa', 'Gallardo'),
(10000033, 'Francisco', 'Aguilar'),
(10000034, 'Eva', 'Pérez'),
(10000035, 'Antonio', 'Herrera'),
(10000036, 'Teresa', 'Jiménez'),
(10000037, 'Adrián', 'Méndez'),
(10000038, 'Ana', 'Lorenzo'),
(10000039, 'Luis', 'Santiago'),
(10000040, 'Carmen', 'Domínguez'),
(10000041, 'Miguel', 'Gil'),
(10000042, 'Gloria', 'Marín'),
(10000043, 'Javier', 'Soto'),
(10000044, 'Sofía', 'Benítez'),
(10000045, 'Raúl', 'Román'),
(10000046, 'Pilar', 'Fuentes'),
(10000047, 'Ángel', 'Campos'),
(10000048, 'María José', 'León'),
(10000049, 'Juan Manuel', 'Vidal'),
(10000050, 'Cristina', 'Durán'),
(10000051, 'Eduardo', 'Vicente'),
(10000052, 'Lorena', 'Carrasco'),
(10000053, 'Alfonso', 'Ferrer'),
(10000054, 'Alicia', 'Ramos'),
(10000055, 'Pedro', 'Soler'),
(10000056, 'Verónica', 'Cabrera'),
(10000057, 'Sebastián', 'Rey'),
(10000058, 'Rocío', 'Vega'),
(10000059, 'Óscar', 'Mora'),
(10000060, 'Inés', 'Moya'),
(10000061, 'Gabriel', 'Castillo'),
(10000062, 'Carolina', 'Peña'),
(10000063, 'Enrique', 'Ortega'),
(10000064, 'Paula', 'Silva'),
(10000065, 'Fernando', 'Lara'),
(10000066, 'Natalia', 'Ramos'),
(10000067, 'Gonzalo', 'Campos'),
(10000068, 'Alejandra', 'Núñez'),
(10000069, 'José Luis', 'Ibáñez'),
(10000070, 'Claudia', 'Santos'),
(10000071, 'Rubén', 'Vargas'),
(10000072, 'María', 'Méndez'),
(10000073, 'Iván', 'Sosa'),
(10000074, 'Patricia', 'Herrero'),
(10000075, 'Mario', 'Rojas'),
(10000076, 'Sara', 'Molina'),
(10000077, 'Agustín', 'Prieto'),
(10000078, 'Lorena', 'Cano'),
(10000079, 'Felipe', 'Benítez'),
(10000080, 'Esther', 'Pascual'),
(10000081, 'Víctor', 'López'),
(10000082, 'Alba', 'García'),
(10000083, 'Emilio', 'Sanz'),
(10000084, 'Ángela', 'Calvo'),
(10000085, 'Martín', 'Torres'),
(10000086, 'Nuria', 'Serrano'),
(10000087, 'Héctor', 'Ramos'),
(10000088, 'Elena', 'Mora'),
(10000089, 'Jorge', 'Vicente'),
(10000090, 'Ana María', 'Carmona'),
(10000091, 'Tomás', 'Gallardo'),
(10000092, 'Isabel', 'Rey'),
(10000093, 'Lucas', 'Marín'),
(10000094, 'Cristina', 'Vidal'),
(10000095, 'Andrés', 'Ortega'),
(10000096, 'Marta', 'Álvarez'),
(10000097, 'Jaime', 'Navarro'),
(10000098, 'Teresa', 'Rubio'),
(10000099, 'Alberto', 'Herrera'),
(10000100, 'Beatriz', 'Castro');

-- Insertar datos en la tabla Inquilino
INSERT INTO Inquilino (cuit) VALUES
(10000004),
(10000005),
(10000006),
(10000007),
(10000008),
(10000021),
(10000022),
(10000023),
(10000024),
(10000025),
(10000026),
(10000027),
(10000028),
(10000029),
(10000030),
(10000031),
(10000032),
(10000033),
(10000034),
(10000035),
(10000036),
(10000037),
(10000038),
(10000039),
(10000040),
(10000041),
(10000042),
(10000043),
(10000044),
(10000045),
(10000046),
(10000047),
(10000048),
(10000049),
(10000050),
(10000071),
(10000072),
(10000073),
(10000074),
(10000075),
(10000076),
(10000077),
(10000078),
(10000079),
(10000080),
(10000081),
(10000082),
(10000083),
(10000084),
(10000085),
(10000086),
(10000087),
(10000088),
(10000089),
(10000090),
(10000091),
(10000092),
(10000093),
(10000094),
(10000095),
(10000096),
(10000097),
(10000098),
(10000099),
(10000100);

-- Insertar más datos en la tabla Dueño
INSERT INTO Dueño (cuit) VALUES
(10000001),
(10000002),
(10000003),
(10000009),
(10000010),
(10000011),
(10000012),
(10000013),
(10000014),
(10000015),
(10000016),
(10000017),
(10000018),
(10000019),
(10000020),
(10000061),
(10000062),
(10000063),
(10000064),
(10000065),
(10000066),
(10000067),
(10000068),
(10000069),
(10000070);

-- Insertar datos en la tabla Telefonos
INSERT INTO Telefonos (cuit, fono) VALUES
(10000001, 111111111),
(10000002, 222222222),
(10000003, 333333333),
(10000004, 444444444),
(10000005, 555555555),
(10000006, 666666666),
(10000007, 777777777),
(10000008, 888888888),
(10000009, 999999053),
(10000010, 999999054),
(10000011, 999999055),
(10000012, 999999056),
(10000013, 999999057),
(10000014, 999999058),
(10000015, 999999059),
(10000016, 999999060),
(10000017, 999999061),
(10000018, 999999062),
(10000019, 999999063),
(10000020, 999999064),
(10000021, 999999065),
(10000022, 999999066),
(10000023, 999999067),
(10000024, 999999068),
(10000025, 999999069),
(10000026, 999999070),
(10000027, 999999071),
(10000028, 999999072),
(10000029, 999999073),
(10000030, 999999074),
(10000031, 999999075),
(10000032, 999999076),
(10000033, 999999077),
(10000034, 999999078),
(10000035, 999999079),
(10000036, 999999080),
(10000037, 999999081),
(10000038, 999999082),
(10000039, 999999083),
(10000040, 999999084),
(10000041, 999999085),
(10000042, 999999086),
(10000043, 999999087),
(10000044, 999999088),
(10000045, 999999089),
(10000046, 999999090),
(10000047, 999999091),
(10000048, 999999092),
(10000049, 999999093),
(10000050, 999999094),
(10000061, 999999095),
(10000062, 999999096),
(10000063, 999999097),
(10000064, 999999098),
(10000065, 999999099),
(10000066, 999999100),
(10000067, 999999101),
(10000068, 999999102),
(10000069, 999999103),
(10000070, 999999104),
(10000071, 999999105),
(10000072, 999999106),
(10000073, 999999107),
(10000074, 999999108),
(10000075, 999999109),
(10000076, 999999110),
(10000077, 999999111),
(10000078, 999999112),
(10000079, 999999113),
(10000080, 999999114),
(10000081, 999999115),
(10000082, 999999116),
(10000083, 999999117),
(10000084, 999999118),
(10000085, 999999119),
(10000086, 999999120),
(10000087, 999999121),
(10000088, 999999122),
(10000089, 999999123),
(10000090, 999999124),
(10000091, 999999125),
(10000092, 999999126),
(10000093, 999999127),
(10000094, 999999128),
(10000095, 999999129),
(10000096, 999999130),
(10000097, 999999131),
(10000098, 999999132),
(10000099, 999999133),
(10000100, 999999134);

-- Insertar datos en la tabla Casa
INSERT INTO Casa (cuit, nro, calle, ciudad) VALUES
(10000001, 123, 'Calle Principal', 'Ciudad A'),
(10000002, 1024, 'Carrera', 'Corrientes'),
(10000003, 789, 'Pasaje Tercero', 'Ciudad C'),
(10000009, 111, 'Avenida Central', 'Ciudad P'),
(10000010, 222, 'Boulevard Principal', 'Ciudad Q'),
(10000011, 333, 'Calle Secundaria', 'Ciudad R'),
(10000012, 444, 'Pasaje del Sol', 'Ciudad S'),
(10000013, 555, 'Camino Real', 'Ciudad T'),
(10000014, 666, 'Alameda del Sur', 'Ciudad U'),
(10000015, 777, 'Callejón Norte', 'Ciudad V'),
(10000016, 888, 'Paseo de las Flores', 'Ciudad W'),
(10000017, 999, 'Sendero de la Luna', 'Ciudad X'),
(10000018, 112, 'Glorieta del Este', 'Ciudad Y'),
(10000019, 223, 'Ronda del Oeste', 'Ciudad Z'),
(10000020, 334, 'Vía Láctea', 'Ciudad AA'),
(10000061, 445, 'Plaza Mayor', 'Ciudad BB'),
(10000062, 556, 'Calle de la Paz', 'Ciudad CC'),
(10000063, 667, 'Avenida Libertad', 'Ciudad DD'),
(10000064, 778, 'Bulevar del Río', 'Ciudad EE'),
(10000065, 889, 'Calle del Arte', 'Ciudad FF'),
(10000066, 990, 'Camino del Bosque', 'Ciudad GG'),
(10000067, 101, 'Pasaje de la Luz', 'Ciudad HH'),
(10000070, 202, 'Alameda Central', 'Ciudad II'),
(10000070, 303, 'Paseo del Parque', 'Ciudad JJ'),
(10000070, 404, 'Calle de los Poetas', 'Ciudad KK'),
(10000001, 24, 'Malibú Park', 'California');

-- Insertar más datos en la tabla Alquiler
INSERT INTO Alquiler (cuit, id_casa, deuda) VALUES
(10000021, 1, 0.00),
(10000022, 2, 120.00),
(10000023, 3, 0.00),
(10000024, 4, 80.50),
(10000025, 5, 0.00),
(10000026, 6, 60.00),
(10000027, 7, 0.00),
(10000028, 8, 90.75),
(10000029, 9, 0.00),
(10000030, 10, 110.00),
(10000031, 11, 0.00),
(10000032, 12, 70.00),
(10000033, 13, 0.00),
(10000034, 14, 130.00),
(10000035, 15, 0.00),
(10000036, 16, 0.00),
(10000037, 17, 95.00),
(10000038, 18, 0.00),
(10000039, 19, 0.00),
(10000040, 20, 50.00),
(10000041, 21, 0.00),
(10000042, 22, 85.00),
(10000043, 23, 0.00),
(10000044, 24, 0.00),
(10000100, 25, 115.00),
(10000100, 26, 500.00);

-- Ahora, hacemos las consultas. 

-- 3.1. Los arrendatarios que arriendan la casa ubicada en la calle Carrera nº 1024, Corrientes.

-- 3.2. ¿Cuánto le deben a María Pérez?

-- 3.3. ¿Cuál es la deuda total para cada dueño?

-- 3.4. Liste todas las personas de la base de datos

-- 3.5. Indique los dueños que poseen tres o más casas.

-- 3.6. Liste los dueños que tengan deudores en todas sus casas.

-- 3.7. Cree una vista (y luego compruebe su funcionamiento) que se llame “vw_estadisticas” que entregue estadísticas sobre los arrendatarios por casa. Liste:
-- 	 El promedio.
-- 	 La varianza.
-- 	 El máximo.
-- 	 El mínimo.

CREATE VIEW vw_estadísticas AS 
SELECT p.nombre, p.apellido,  a.cuit, MIN(deuda) AS deuda_mínima, MAX(deuda) AS deuda_máxima, VAR_POP(deuda) AS varianza, AVG(deuda) AS deuda_promedio 
FROM Alquiler AS a INNER JOIN Persona AS p ON a.cuit=p.cuit 
GROUP BY (cuit);