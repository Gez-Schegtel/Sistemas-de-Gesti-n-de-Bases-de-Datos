
WITH empleadosFiltrados AS (
	SELECT * 
	FROM employees AS e
	WHERE e.last_name LIKE 'GUT%' OR e.last_name = 'GONZALEZ'
)
SELECT *
FROM empleadosFiltrados AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
WHERE s.salary > 7000 AND s.to_date = '9999-01-01';

EXPLAIN 
WITH empleadosFiltrados AS (
	SELECT * 
	FROM employees AS e
	WHERE e.last_name LIKE 'GUT%' OR e.last_name = 'GONZALEZ'
)
SELECT *
FROM empleadosFiltrados AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
WHERE s.salary > 7000 AND s.to_date = '9999-01-01';

EXPLAIN ANALYZE 
WITH empleadosFiltrados AS (
	SELECT * 
	FROM employees AS e
	WHERE e.last_name LIKE 'GUT%' OR e.last_name = 'GONZALEZ'
)
SELECT *
FROM empleadosFiltrados AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
WHERE s.salary > 7000 AND s.to_date = '9999-01-01'\G
