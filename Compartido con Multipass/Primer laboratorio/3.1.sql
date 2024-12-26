
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no;

EXPLAIN 
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no; 

EXPLAIN ANALYZE
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no\G 

