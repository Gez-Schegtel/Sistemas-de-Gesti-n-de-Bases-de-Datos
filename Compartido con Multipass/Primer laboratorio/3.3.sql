
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
WHERE s.to_date = '9999-01-01' AND s.salary > 7000;

EXPLAIN
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
WHERE s.to_date = '9999-01-01' AND s.salary > 7000;

EXPLAIN ANALYZE
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
WHERE s.to_date = '9999-01-01' AND s.salary > 7000\G

