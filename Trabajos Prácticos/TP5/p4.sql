-- c) Utilizar las funciones XML disponibles en MySQL para:
-- i. Obtener fecha de alta y actores de la película Titanic.

-- Versión 1: 
SELECT fecha_alta, EXTRACTVALUE(catalogo, '/CatalogoPeliculas/Pelicula[Titulo="Titanic"]/Actores/Actor') AS 'Actores de la película "El Titanic"'
FROM nuevos_catalogos;

-- Versión 2: 
SELECT fecha_alta, ExtractValue(catalogo, '//Pelicula[Titulo="Titanic"] /Actores/Actor/text()') AS 'Actores de la película "El Titanic"' FROM nuevos_catalogos;

-- ii. Listar título de las películas en las que actúa Leonardo DiCaprio.

SELECT EXTRACTVALUE(catalogo, '/CatalogoPeliculas/Pelicula[Actores/Actor="Leonardo DiCaprio"]/Titulo') AS 'Películas de Leonardo DiCaprio'
FROM nuevos_catalogos\G

-- iii. Obtener la duración de las películas de género Thriller.

SELECT EXTRACTVALUE(catalogo, '/CatalogoPeliculas/Pelicula[Genero="Thriller"]/Duracion') AS 'Duración de las películas Thriller'
FROM nuevos_catalogos\G

-- iv. Actualizar las películas en formato “VHS” a “Blue-Ray”.

SELECT UPDATEXML(catalogo, '/CatalogoPeliculas/Pelicula[Formato="VHS"]/Formato', '<Formato>Blue-Ray</Formato>')
FROM nuevos_catalogos;
