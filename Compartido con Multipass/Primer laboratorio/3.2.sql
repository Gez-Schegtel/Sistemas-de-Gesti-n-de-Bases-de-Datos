
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
WHERE e.last_name LIKE 'GUT%' OR e.last_name = 'GONZÁLES' 
ORDER BY e.last_name;

EXPLAIN
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
WHERE e.last_name LIKE 'GUT%' OR e.last_name = 'GONZÁLES' 
ORDER BY e.last_name;

EXPLAIN ANALYZE
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
WHERE e.last_name LIKE 'GUT%' OR e.last_name = 'GONZÁLES' 
ORDER BY e.last_name\G

