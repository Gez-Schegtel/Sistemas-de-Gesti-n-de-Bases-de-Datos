
-- Insertar datos en la tabla discográficas
INSERT INTO discográficas (iddiscograf, nombre, dirección, email, teléfono) VALUES
(1, 'Sony Music', '123 Calle Principal, Ciudad', 'contacto@sonymusic.com', 123456789),
(2, 'Universal Music', '456 Avenida Secundaria, Ciudad', 'info@universalmusic.com', 987654321);

-- Insertar datos en la tabla bandas
INSERT INTO bandas (idbanda, nombre, nacionalidad, fecha_inicio, fecha_separación, género, iddiscograf) VALUES
(1, 'The Beatles', 'Reino Unido', '1960-01-01', '1970-04-10', 'Rock', 1),
(2, 'Queen', 'Reino Unido', '1970-01-01', NULL, 'Rock', 1),
(3, 'Black Sabbath', 'Reino Unido', '1968-01-01', NULL, 'Heavy Metal', 2);

-- Insertar datos en la tabla albums
INSERT INTO albums (idalbum, nombre, duración, genéro, estudio, nrocanciones, fecha_lanzamiento) VALUES
(1, 'Abbey Road', '00:47:23', 'Rock', 'EMI Studios', 17, '1969-09-26'),
(2, 'A Night at the Opera', '00:43:08', 'Rock', 'Sarm Studios', 12, '1975-11-21'),
(3, 'Sabbath Bloody Sabbath', '00:42:34', 'Heavy Metal', 'Morgan Studios', 8, '1973-12-01');

-- Insertar datos en la tabla canciones
INSERT INTO canciones (idcanción, nombre, duración) VALUES
(1, 'Come Together', '00:04:19'),
(2, 'Something', '00:03:03'),
(3, 'Bohemian Rhapsody', '00:05:55'),
(4, 'Love of My Life', '00:03:39'),
(5, 'Sabbath Bloody Sabbath', '00:05:45'),
(6, 'A National Acrobat', '00:06:15');

-- Insertar datos en la tabla graba (relaciona bandas y albums)
INSERT INTO graba (idbanda, idalbum) VALUES
(1, 1),  -- The Beatles grabaron Abbey Road
(2, 2),  -- Queen grabaron A Night at the Opera
(3, 3);  -- Black Sabbath grabaron Sabbath Bloody Sabbath

-- Insertar datos en la tabla pertenece (relaciona albums y canciones)
INSERT INTO pertenece (idalbum, idcanción) VALUES
(1, 1),  -- Abbey Road contiene Come Together
(1, 2),  -- Abbey Road contiene Something
(2, 3),  -- A Night at the Opera contiene Bohemian Rhapsody
(2, 4),  -- A Night at the Opera contiene Love of My Life
(3, 5),  -- Sabbath Bloody Sabbath contiene Sabbath Bloody Sabbath
(3, 6);  -- Sabbath Bloody Sabbath contiene A National Acrobat
