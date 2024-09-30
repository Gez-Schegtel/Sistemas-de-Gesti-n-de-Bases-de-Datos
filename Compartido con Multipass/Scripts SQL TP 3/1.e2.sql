
-- Este script funciona con la base de datos llamada "hospital"


USE hospital;

-- 1.1

ALTER TABLE personal
ADD COLUMN sueldo REAL,
ADD CONSTRAINT chk_sueldo CHECK(sueldo >= 0);

LOAD DATA LOCAL INFILE 'hospital.csv'
INTO TABLE hospitales
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Esta opción se pone si la primer fila del archivo .csv tiene el nombre de los campos de la tabla.

LOAD DATA LOCAL INFILE 'personal.csv'
INTO TABLE personal
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Esta opción se pone si la primer fila del archivo .csv tiene el nombre de los campos de la tabla.

-- El script SQL para cargar los datos es el siguiente: 
-- Cargamos primero los hospitales para no quebrantar la restricción de clave foránea con "personal":
INSERT INTO hospitales(nombre) 
VALUES 
('Sanatorio Francescoli'),
('Hospital Favaloro'),
('Hospital Italiano');

-- Inserción de datos para la tabla "personal": 
INSERT INTO personal (dni, nombre, apellidos, direccion, telefono, fecha_ingreso, nombre_hospital, sueldo)
VALUES
(84368452, 'Tiburcio', 'Riera', 'Acceso Calixto Alcolea', 6349, '2015-03-10', 'Sanatorio Francescoli', 801438.28),
(76564446, 'Juan Carlos', 'Guzman', 'Urbanización Xiomara Lopez', 8717, '2005-05-08', 'Hospital Italiano', 494997.94),
(22204531, 'Benito', 'Aramburu', 'Acceso de Silvia Echevarría', 8313, '2013-09-12', 'Hospital Favaloro', 281112.9),
(22740308, 'Sandra', 'Giralt', 'C. de Anastasio Querol', 5413, '1980-01-31', 'Hospital Italiano', 718070.5),
(62982559, 'Candela', 'Tejedor', 'Calle Hilario Torrens', 7569, '2023-03-26', 'Sanatorio Francescoli', 589961.82),
(77611813, 'Porfirio', 'Vilalta', 'Pasaje de África Rius', 5103, '2023-11-13', 'Sanatorio Francescoli', 506744.32),
(85606959, 'Cristina', 'Gracia', 'Ronda Angelina Ocaña', 7799, '1997-10-17', 'Hospital Favaloro', 643664.88),
(47803504, 'Amancio', 'Meléndez', 'Plaza de Atilio Izaguirre', 592, '1985-02-10', 'Hospital Italiano', 982777.39),
(41139736, 'Paz', 'Amores', 'Alameda Paola Campos', 6917, '2003-04-06', 'Hospital Italiano', 540794.11),
(80905981, 'Vasco', 'Rubio', 'C. Consuela Jordá', 4590, '2000-11-20', 'Hospital Italiano', 456943.3),
(94239433, 'Nazario', 'Córdoba', 'Pasadizo de Emiliana Torrent', 7797, '2008-12-21', 'Hospital Favaloro', 780481.87),
(16398961, 'Miguel Ángel', 'Belda', 'Cuesta de Manolo Falcón', 8227, '1994-07-03', 'Sanatorio Francescoli', 626586.19),
(62273490, 'Candela', 'Rosa', 'Ronda de Reyna López', 8924, '1984-09-03', 'Sanatorio Francescoli', 917611.64),
(14063505, 'Isabel', 'Escudero', 'Plaza de Antonio Baeza', 7929, '1994-05-12', 'Sanatorio Francescoli', 220473.3),
(16248971, 'Camila', 'Nogués', 'Urbanización Aurora Quevedo', 2255, '2006-12-02', 'Hospital Favaloro', 360035.64),
(92833825, 'Dolores', 'Paz', 'Rambla Obdulia Bosch', 3981, '2006-08-15', 'Hospital Italiano', 165780.43),
(97020656, 'Glauco', 'Piña', 'Rambla de Paula Español', 1450, '2018-02-07', 'Hospital Italiano', 206464.98),
(95860665, 'Caridad', 'Cuesta', 'Calle Aurelio Sancho', 4487, '2016-12-07', 'Sanatorio Francescoli', 752383.78),
(62315569, 'Adelaida', 'Bilbao', 'Pasadizo de Guillermo Trillo', 104, '2008-06-11', 'Sanatorio Francescoli', 817636.64),
(12863056, 'Fátima', 'Giralt', 'Pasaje Ruth Baños', 2513, '2002-03-16', 'Sanatorio Francescoli', 292114.4),
(15643481, 'Gracia', 'Ballesteros', 'Ronda Eva María Alemany', 8273, '1990-02-15', 'Sanatorio Francescoli', 534007.48),
(21239639, 'Cruz', 'Parejo', 'Callejón Cándida Falcón', 8954, '1983-07-09', 'Sanatorio Francescoli', 945100.61),
(90630943, 'Chuy', 'Gutierrez', 'Urbanización de Eleuterio Bernal', 5830, '2003-12-30', 'Hospital Favaloro', 422298.39),
(79948632, 'Soraya', 'Barral', 'Pasaje Visitación Ramis', 7150, '2003-12-23', 'Sanatorio Francescoli', 339666.14),
(20804584, 'Rafael', 'Rios', 'Pasadizo Maxi Daza', 9374, '1999-08-02', 'Hospital Favaloro', 413011.3),
(36721737, 'Óscar', 'Quintero', 'Calle de Ligia Romero', 1521, '2014-11-30', 'Sanatorio Francescoli', 852951.17),
(27718037, 'Sebastián', 'Carlos', 'Plaza de Rolando Miralles', 247, '1992-02-03', 'Hospital Italiano', 425499.22),
(71810801, 'Gisela', 'Solís', 'Cañada de Rodrigo Aragonés', 1785, '2004-10-20', 'Hospital Italiano', 389792.75),
(37643617, 'Isabel', 'Amador', 'Cañada de Esmeralda Tomé', 4867, '1989-10-22', 'Hospital Italiano', 154873.78),
(83260562, 'Constanza', 'Salamanca', 'C. de Sebastian Fuentes', 8422, '2002-07-24', 'Hospital Italiano', 302929.19),
(39833180, 'Luisina', 'Talavera', 'Pasaje Noa Alba', 2112, '2009-12-02', 'Sanatorio Francescoli', 567832.3),
(58366695, 'Fabiola', 'Alonso', 'Via Débora Carbó', 3517, '1999-04-09', 'Sanatorio Francescoli', 584828.36),
(67266756, 'Aroa', 'Millán', 'Paseo Herminia Aragón', 966, '1991-02-04', 'Hospital Italiano', 332403.44),
(83303561, 'Fito', 'Molins', 'Pasaje Haydée Salvà', 326, '1996-07-22', 'Hospital Italiano', 263113.37),
(73026026, 'Joaquín', 'Alberto', 'Cañada de Pascual Cabo', 5904, '1983-11-12', 'Hospital Favaloro', 885751.17),
(24100161, 'Elpidio', 'Barroso', 'Rambla de Cecilia Grau', 6767, '2006-05-12', 'Hospital Favaloro', 490209.67),
(44094593, 'Felicidad', 'Carbonell', 'Rambla Elpidio Machado', 1899, '2016-09-22', 'Sanatorio Francescoli', 785010.35),
(18072622, 'Benita', 'Cadenas', 'C. Blanca Dueñas', 8298, '1998-01-06', 'Sanatorio Francescoli', 766929.23),
(58087456, 'Charo', 'Mosquera', 'Rambla de Rosalinda Garay', 4800, '2012-11-08', 'Hospital Favaloro', 218183.49),
(51849758, 'Jennifer', 'Gual', 'Pasadizo de Dani Campoy', 7026, '1996-12-25', 'Sanatorio Francescoli', 557523.84),
(23042793, 'Bárbara', 'Tenorio', 'Cañada Manuela Falcó', 3811, '1987-12-30', 'Hospital Italiano', 651591.38),
(32970178, 'Fabio', 'Patiño', 'Alameda Azucena Azorin', 6309, '2006-09-10', 'Hospital Favaloro', 552326.69),
(32782662, 'Luis', 'Pérez', 'Urbanización Ramiro Tello', 5485, '2014-04-25', 'Hospital Italiano', 232963.82),
(60233553, 'Obdulia', 'Villegas', 'Pasaje de Saturnino Cobo', 5446, '2022-10-03', 'Sanatorio Francescoli', 685605.22),
(50015171, 'Natividad', 'Lledó', 'Cañada de Consuela Berenguer', 7005, '2020-02-03', 'Hospital Favaloro', 128125.73),
(13872558, 'Fausto', 'Viñas', 'Acceso Nereida Aroca', 7749, '1984-04-04', 'Hospital Favaloro', 291454.96),
(17474418, 'Casemiro', 'Bayo', 'Calle de Ruben Carmona', 8844, '1985-10-26', 'Hospital Favaloro', 150095.2),
(25798282, 'Chucho', 'Ropero', 'Rambla Ana Sofía Sierra', 8933, '1984-03-22', 'Hospital Italiano', 705446.84),
(17495266, 'América', 'Fábregas', 'Pasaje de Amarilis Álvaro', 9539, '2008-09-22', 'Sanatorio Francescoli', 207946.71),
(35896053, 'Maximiliano', 'Gutierrez', 'Glorieta Azahara Toro', 8366, '2006-04-08', 'Hospital Italiano', 598095.77),
(95845677, 'Bartolomé', 'Santiago', 'Via de Rebeca Verdú', 1759, '2023-09-21', 'Hospital Italiano', 286671.58),
(57581518, 'Isidora', 'Cerro', 'Vial de Dominga Catalán', 2214, '1985-06-25', 'Hospital Italiano', 848990.84),
(35556948, 'Encarnación', 'Borrell', 'Callejón de Arsenio Puerta', 9762, '1985-03-09', 'Hospital Italiano', 203194.93),
(49221656, 'Pili', 'Alberola', 'Vial Roxana Ocaña', 8513, '1994-04-03', 'Sanatorio Francescoli', 726291.5),
(90899022, 'Lucía', 'Ros', 'Calle de Ale Hernández', 3410, '1986-02-04', 'Hospital Favaloro', 920892.6),
(25618165, 'Lino', 'Borrego', 'Via de Maricela Moliner', 946, '2020-10-25', 'Hospital Italiano', 225235.32),
(15566135, 'Chelo', 'Crespi', 'Calle de Ana Castells', 7321, '2007-02-10', 'Hospital Favaloro', 535060.1),
(25451898, 'Natalio', 'Calderón', 'Rambla de Aitor Cisneros', 3433, '1985-03-06', 'Hospital Favaloro', 921492.59),
(33141446, 'Elpidio', 'Expósito', 'Pasaje de Guiomar Diez', 4394, '1994-12-23', 'Hospital Italiano', 747836.2),
(23720887, 'Emilio', 'Ángel', 'C. de Albano Pablo', 7069, '1988-06-02', 'Hospital Favaloro', 105532.92),
(32616703, 'Amado', 'Mendez', 'Camino de Melchor Quevedo', 8466, '2021-10-23', 'Sanatorio Francescoli', 608352.14),
(29563194, 'Eusebio', 'Goicoechea', 'Callejón de Marcelo Echeverría', 8181, '1988-12-21', 'Sanatorio Francescoli', 837824.1),
(81414578, 'José Manuel', 'Torrijos', 'Plaza de Eustaquio Rivero', 1216, '2013-03-26', 'Hospital Italiano', 779055.22),
(13801291, 'Jerónimo', 'Lobo', 'C. Régulo Viña', 4163, '2004-09-15', 'Sanatorio Francescoli', 550142.3),
(38763604, 'Elisabet', 'Quesada', 'Via Toño Hernández', 887, '2000-01-14', 'Sanatorio Francescoli', 996537.84),
(79611336, 'Silvio', 'Grande', 'Cuesta de Paco González', 125, '1999-03-19', 'Hospital Italiano', 900220.21),
(93743697, 'Marina', 'Escribano', 'Paseo Fernanda Arteaga', 531, '1982-01-03', 'Hospital Italiano', 543159.53),
(70186975, 'Javiera', 'Pallarès', 'Urbanización Víctor Mariño', 7442, '2000-10-28', 'Hospital Favaloro', 435107.49),
(50566619, 'Francisco Javier', 'Ojeda', 'Acceso Samanta Zabaleta', 5433, '1992-08-09', 'Sanatorio Francescoli', 761173.14),
(90890560, 'Mireia', 'Pol', 'Via Ascensión Santamaría', 6948, '2017-07-12', 'Hospital Favaloro', 397972.58),
(68057610, 'Javi', 'Armengol', 'Alameda Tiburcio Tapia', 228, '2008-11-07', 'Sanatorio Francescoli', 963268.56),
(42985116, 'Fidel', 'Cobos', 'Paseo Juan Francisco Romeu', 9340, '1995-11-15', 'Sanatorio Francescoli', 678279.46),
(20671253, 'Ariel', 'Coello', 'Rambla Candelaria Arellano', 6431, '2007-09-29', 'Sanatorio Francescoli', 680078.28),
(88619257, 'Isaac', 'Arellano', 'Acceso Cándida Armas', 2867, '2006-05-25', 'Hospital Italiano', 255768.49),
(40665010, 'Paz', 'Rius', 'Via Clímaco Pomares', 3175, '2020-01-03', 'Sanatorio Francescoli', 677537.86),
(94742496, 'Belén', 'Bueno', 'Cuesta de Manuelita Planas', 3235, '1988-06-23', 'Hospital Italiano', 433499.18),
(57862658, 'Manu', 'Cervantes', 'Glorieta Nico Múgica', 1497, '2019-10-14', 'Hospital Italiano', 524444.39),
(33976403, 'Noa', 'Bayona', 'Ronda de Elba Mendoza', 732, '1981-11-29', 'Sanatorio Francescoli', 355849.21),
(64497781, 'Nuria', 'Robles', 'Pasadizo de Jenaro Valenzuela', 1687, '2009-04-24', 'Hospital Italiano', 791535.15),
(12199053, 'Mohamed', 'Lorenzo', 'Cuesta de César Céspedes', 1669, '1997-10-10', 'Sanatorio Francescoli', 293978.39),
(25829375, 'Ámbar', 'Segovia', 'Cañada de Bernardino Ariño', 202, '1999-03-10', 'Hospital Italiano', 682148.0),
(48663409, 'Mario', 'Zabaleta', 'Pasaje Candelas Samper', 959, '1984-04-26', 'Sanatorio Francescoli', 697756.31),
(27314998, 'Rafa', 'Borrego', 'Cañada Felipa Gracia', 6976, '2012-10-08', 'Hospital Italiano', 705671.25),
(29528992, 'Natalia', 'Adán', 'Callejón de Eligio Almeida', 1752, '1987-01-01', 'Hospital Favaloro', 379528.79),
(31074600, 'Celestino', 'Carnero', 'Plaza Elena Melero', 3333, '2019-12-09', 'Sanatorio Francescoli', 846594.6),
(52152392, 'Aníbal', 'Lago', 'Avenida de Kike Poza', 7127, '1996-12-03', 'Hospital Favaloro', 184053.94),
(82496030, 'Rosario', 'Galvez', 'Pasaje Odalis Burgos', 6612, '2001-04-25', 'Sanatorio Francescoli', 302312.58),
(12024527, 'Gaspar', 'Vilalta', 'C. de Gertrudis Ferreras', 3725, '2017-05-31', 'Hospital Favaloro', 757010.76),
(48683441, 'Concepción', 'Escolano', 'Plaza Moisés Cortina', 3331, '1997-10-16', 'Sanatorio Francescoli', 139053.51),
(49728510, 'Isaura', 'Serna', 'Cañada Mariana Solé', 7750, '1993-09-29', 'Hospital Italiano', 999653.89),
(47511103, 'Luis', 'Suarez', 'Callejón Rosalía Cornejo', 5558, '1987-10-30', 'Sanatorio Francescoli', 787933.32),
(75240884, 'Wálter', 'Alcaraz', 'Via de Sabas Ríos', 6104, '1981-12-06', 'Hospital Italiano', 808583.47),
(51555428, 'Timoteo', 'Rozas', 'Urbanización de Pepita Canet', 6921, '1988-01-05', 'Hospital Favaloro', 657279.84),
(39150977, 'Nicodemo', 'Huertas', 'Paseo Joan Rodríguez', 6782, '2018-02-04', 'Sanatorio Francescoli', 447565.9),
(43479776, 'Tadeo', 'Cases', 'Cañada de Ernesto Guzmán', 2124, '2010-11-03', 'Hospital Italiano', 139849.28),
(58292017, 'Zacarías', 'Merino', 'Glorieta Emiliano Calatayud', 3206, '2014-02-08', 'Sanatorio Francescoli', 618660.26),
(67080764, 'Vinicio', 'Luna', 'Camino de Carina Perales', 4076, '2020-03-25', 'Hospital Italiano', 914057.67),
(74610377, 'Fernanda', 'Somoza', 'Paseo de Nayara Cañete', 6745, '1996-09-15', 'Hospital Italiano', 804374.15),
(81552389, 'Gertrudis', 'Arnal', 'Alameda de Manolo Navas', 3258, '2019-08-27', 'Sanatorio Francescoli', 609682.88),
(29970615, 'Ricardo', 'Llorente', 'Vial de Rufino Grau', 818, '1991-04-22', 'Hospital Favaloro', 796571.15);

-- 1.2
UPDATE personal SET sueldo = sueldo * 1.1 WHERE sueldo < 150000;

UPDATE personal SET sueldo = sueldo * 1.05 WHERE sueldo BETWEEN 150000 AND 200000;
