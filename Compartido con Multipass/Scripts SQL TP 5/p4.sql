-- 4) En la tienda de alquiler de películas se empezaron a recibir catálogos de manera más dinámica y de distintos proveedores, todos como documentos XML, lo que implica realizar algunas modificaciones a la base de datos. En la base de datos “sakila” realizar las siguientes acciones:

USE sakila;

-- a) Crear una nueva tabla con el siguiente esquema: 
-- nuevos_catalogos(id: entero, fecha_alta: fecha, catalogo: texto)

DROP TABLE IF EXISTS nuevos_catalogos;
CREATE TABLE nuevos_catalogos (id INT, fecha_alta DATE, catalogo TEXT);

-- b. Agregar un registro a la tabla creada de manera de dar de alta el siguiente catálogo:
-- ¡Atención! Para que este script funcione tiene que estar el archivo "p4.xml" (definido como se muestra debajo) bajo el directorio "/var/lib/mysql-files" y tener activada la función "secure_file_priv".

-- Contenido de "p4.xml".
-- <CatalogoPeliculas>
-- 	<Pelicula>
-- 		<Titulo>The Matrix</Titulo>
-- 		<Duracion>136</Duracion>
-- 		<Genero>Sci-Fi and Fantasy</Genero>
-- 		<Actores>
-- 			<Actor>Keanu Reeves</Actor>
-- 			<Actor>Laurence Fishburne</Actor>
-- 			<Actor>Carrie Ann Moss</Actor>
-- 		</Actores>
-- 		<Fecha>1999</Fecha>
-- 		<Director>Wachowski Brothers</Director>
-- 		<Formato>DVD</Formato>
-- 	</Pelicula>
-- 	<Pelicula>
-- 		<Titulo>Titanic</Titulo>
-- 		<Duracion>194</Duracion>
-- 		<Genero>Drama</Genero>
-- 		<Actores>
-- 			<Actor>Leonardo DiCaprio</Actor>
-- 			<Actor>Kate Winslet</Actor>
-- 		</Actores>
-- 		<Fecha>1999</Fecha>
-- 		<Director>James Cameron</Director>
-- 		<Formato>DVD</Formato>
-- 	</Pelicula>
-- 	<Pelicula>
-- 		<Titulo>The Sixth Sense</Titulo>
-- 		<Duracion>106</Duracion>
-- 		<Genero>Thriller</Genero>
-- 		<Actores>
-- 			<Actor>Bruce Willis</Actor>
-- 			<Actor>Haley Joel Osment</Actor>
-- 		</Actores>
-- 		<Fecha>1999</Fecha>
-- 		<Director>M. Night Shyamalan</Director>
-- 		<Formato>VHS</Formato>
-- 	</Pelicula>
-- </CatalogoPeliculas>

INSERT INTO nuevos_catalogos (id, fecha_alta, catalogo) VALUES (1, DATE(NOW()), LOAD_FILE('/var/lib/mysql-files/p4.xml'));

-- c) Utilizar las funciones XML disponibles en MySQL para:
-- i. Obtener fecha de alta y actores de la película Titanic.

-- Versión 1: 
SELECT fecha_alta, EXTRACTVALUE(catalogo, '/CatalogoPeliculas/Pelicula[Titulo="Titanic"]/Actores/Actor') AS 'Actores de la película "El Titanic"'
FROM nuevos_catalogos;

-- Versión 2: 
SELECT fecha_alta, ExtractValue(catalogo, '//Pelicula[Titulo="Titanic"] /Actores/Actor/text()') AS 'Actores de la película "El Titanic"' FROM nuevos_catalogos;

-- ii. Listar título de las películas en las que actúa Leonardo DiCaprio.

SELECT EXTRACTVALUE(catalogo, '/CatalogoPeliculas/Pelicula[Actores/Actor="Leonardo DiCaprio"]/Titulo') AS 'Películas de Leonardo DiCaprio'
FROM nuevos_catalogos;

-- iii. Obtener la duración de las películas de género Thriller.

SELECT EXTRACTVALUE(catalogo, '/CatalogoPeliculas/Pelicula[Genero="Thriller"]/Duracion') AS 'Duración de las películas Thriller'
FROM nuevos_catalogos;

-- iv. Actualizar las películas en formato “VHS” a “Blue-Ray”.

SELECT UPDATEXML(catalogo, '/CatalogoPeliculas/Pelicula[Formato="VHS"]/Formato', '<Formato>Blue-Ray</Formato>') AS 'Películas en Blue-Ray\n'
FROM nuevos_catalogos\G
