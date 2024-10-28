
-- 5) Instale la base de datos de ejemplo “world_x” y realice las siguientes acciones:
-- a. Listar los nombres de las ciudades y su cantidad de habitantes.

SELECT Name AS Ciudad, JSON_EXTRACT(Info, '$.Population') AS Poblacion FROM city;

-- b. Encuentre las ciudades con una población superior a 1.000.000 de habitantes.

SELECT Name AS Ciudad, JSON_EXTRACT(Info, '$.Population') AS Poblacion FROM city WHERE JSON_EXTRACT(Info, '$.Population') > 1000000;

-- c. Mostrar un listado “entendible” de la información registrada de los 10 últimos países ordenados por código (campo Code).

SELECT 
	c.Capital AS ID_Capital, 
	JSON_EXTRACT(ci.doc, '$.Name') AS Nombre_País,
	JSON_EXTRACT(ci.doc, '$.geography.Region') AS Región,
	JSON_EXTRACT(ci.doc, '$.geography.Continent') AS Continente,
	JSON_EXTRACT(ci.doc, '$.government.HeadOfState') AS Jefe_de_Estado,
	JSON_EXTRACT(ci.doc, '$.government.GovernmentForm') AS Forma_de_Gobierno,
	JSON_EXTRACT(ci.doc, '$.demographics.Population') AS Población
FROM country AS c INNER JOIN countryinfo AS ci ON c.Code = JSON_EXTRACT(ci.doc, '$.Code')
ORDER BY c.Code DESC
LIMIT 10;

-- d. Obtener las claves del documento json (campo doc) que se registran en countryinfo.

SELECT
	JSON_KEYS(doc) AS Claves_Nivel_Superior,
	JSON_KEYS(JSON_EXTRACT(doc, '$.geography')) AS Claves_geography,
	JSON_KEYS(JSON_EXTRACT(doc, '$.government')) AS Claves_government,
	JSON_KEYS(JSON_EXTRACT(doc, '$.demographics')) AS Claves_demographics
FROM countryinfo LIMIT 1;

-- e. Analizar la estructura y contenidos del campo doc y agregar a la tabla countryinfo una restricción CHECK que permita validar los documentos de acuerdo a un esquema json. Comprobar el funcionamiento de la nueva restricción.

-- Sin la función JSON_UNQUOTE el largo de la cadena del código de los países sería 5, porque se contarían las comillas también.
ALTER TABLE countryinfo
ADD CONSTRAINT chk_valid_json CHECK (
    JSON_UNQUOTE(JSON_EXTRACT(doc, '$.Code')) IS NOT NULL 
    AND CHAR_LENGTH(JSON_UNQUOTE(JSON_EXTRACT(doc, '$.Code'))) = 3
    AND JSON_UNQUOTE(JSON_EXTRACT(doc, '$.Name')) IS NOT NULL 
);

-- Inserción de un registro no válido.
INSERT INTO countryinfo (doc) VALUES (
    '{
        "GNP": null,
        "_id": null,
        "Code": null,
        "Name": null,
        "IndepYear": null,
        "geography": {
            "Region": null,
            "Continent": null,
            "SurfaceArea": null
        },
        "government": {
            "HeadOfState": null,
            "GovernmentForm": null
        },
        "demographics": {
            "Population": null,
            "LifeExpectancy": null
        }
    }'
);

-- Inserción de un registro válido.
INSERT INTO countryinfo (doc) VALUES (
    '{
        "GNP": null,
        "_id": null,
        "Code": "WWW",
        "Name": "País de prueba",
        "IndepYear": null,
        "geography": {
            "Region": null,
            "Continent": null,
            "SurfaceArea": null
        },
        "government": {
            "HeadOfState": null,
            "GovernmentForm": null
        },
        "demographics": {
            "Population": null,
            "LifeExpectancy": null
        }
    }'
);

-- f. Listar los países que no tienen registrado año de declaración de la independencia.

SELECT JSON_PRETTY(doc) AS Info_País FROM countryinfo WHERE JSON_EXTRACT(doc, '$.IndepYear') LIKE '%null%'\G

-- g. Listar los datos demográficos y la población de su capital para los 10 países con menor superficie.

-- Versión 1:
WITH `países_pequeños` AS (
	SELECT
	JSON_UNQUOTE(JSON_EXTRACT(doc, '$.Code')) AS CountryCode,
	JSON_UNQUOTE(JSON_EXTRACT(doc, '$.Name')) AS CountryName,
	JSON_EXTRACT(doc, '$.demographics.Population') AS CountryPopulation,
	JSON_EXTRACT(doc, '$.LifeExpectancy') AS CountryLifeExpectancy,
	CAST((JSON_EXTRACT(doc, '$.geography.SurfaceArea')) AS REAL) AS CountrySurfaceArea -- "Por las dudas", me aseguro que el tipo de dato sea un número real.
	FROM countryinfo INNER JOIN country ON JSON_EXTRACT(doc, '$.Code') = country.Code AND country.Capital IS NOT NULL -- Hay que asegurarse de tomar países cuya capital figure en la base de datos.
	ORDER BY CountrySurfaceArea ASC
	LIMIT 10
)
SELECT pq.CountryName, ci.Name AS CapitalCity, pq.CountryPopulation, pq. CountrySurfaceArea, pq.CountryLifeExpectancy, ci.Info AS CapitalPopulation 
FROM country AS co INNER JOIN city AS ci ON co.Capital = ci.ID INNER JOIN `países_pequeños` AS pq ON ci.CountryCode = pq.CountryCode
ORDER BY pq.CountrySurfaceArea ASC\G

-- Versión 2:
SELECT city.Name,
	JSON_UNQUOTE(JSON_EXTRACT(countryinfo.doc, '$.Name')) AS Nombre,
	JSON_UNQUOTE(JSON_EXTRACT(countryinfo.doc, '$.demographics.Population')) AS poblacion, 
	JSON_UNQUOTE(JSON_EXTRACT(countryinfo.doc, '$.demographics.LifeExpectancy')) AS esperanza_vida,
	JSON_UNQUOTE(JSON_EXTRACT(city.Info, '$.Population')) AS poblacion_capital,
	JSON_UNQUOTE(JSON_EXTRACT(countryinfo.doc, '$.geography.SurfaceArea')) AS area
	FROM countryinfo INNER JOIN country ON country.Name = JSON_UNQUOTE(JSON_EXTRACT(countryinfo.doc, '$.Name')) 
	INNER JOIN city ON country.Code = city.CountryCode AND country.Capital = city.ID
	ORDER BY CAST(JSON_UNQUOTE(JSON_EXTRACT(countryinfo.doc, '$.geography.SurfaceArea')) AS UNSIGNED) ASC LIMIT 10\G

-- h. Agregar una clave al campo Info de la tabla city para representar el código de área telefónico 362 de la ciudad de Resistencia.

-- Versión 1: Agremamos sólo para Resistencia una clave para almacenar el código de área. 
UPDATE city
SET Info = JSON_INSERT(Info, '$.Codigo_area', 362)
WHERE Name LIKE 'Resistencia';

-- Versión 2: Esta versión agrega para todas las ciudades la clave para almacenar el código de área. A la ciudad de Resistencia le agrega su respectivo código, y para las demás ciudades es "null".
UPDATE city SET Info = JSON_SET(Info, '$.PhoneCode', null);
UPDATE city SET Info = JSON_REPLACE(Info, '$.PhoneCode', 362) WHERE CountryCode LIKE '%ARG%' AND Name LIKE '%Resistencia%';

-- i. Listar la información de los países cuya forma de gobierno es república federal ("GovernmentForm": "Federal Republic").

SELECT JSON_PRETTY(doc) AS 'Información del País'
FROM countryinfo
WHERE JSON_EXTRACT(doc, '$.government.GovernmentForm') LIKE '%Federal%Republic%'\G

-- j. Actualizar la población de Argentina a 46.044.703 habitantes.

-- Versión 1: 
UPDATE countryinfo SET doc = JSON_SET(doc, '$.demographics.Population', 46044703) WHERE JSON_EXTRACT(doc, '$.Code') LIKE '%ARG%';

-- Versión 2: 
UPDATE countryinfo
SET doc = JSON_REPLACE(doc, '$.demographics.Population', 46044703)
WHERE JSON_EXTRACT(doc, '$.Name') LIKE '%Argentina%';
