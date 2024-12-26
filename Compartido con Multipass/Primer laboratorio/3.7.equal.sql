
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no INNER JOIN titles AS t ON e.emp_no = t.emp_no
WHERE t.title = 'Engineer' OR t.title = 'Senior Engineer' OR t.title = 'Assistant Engineer'
ORDER BY e.emp_no, t.from_date;

EXPLAIN 
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no INNER JOIN titles AS t ON e.emp_no = t.emp_no
WHERE t.title = 'Engineer' OR t.title = 'Senior Engineer' OR t.title = 'Assistant Engineer'
ORDER BY e.emp_no, t.from_date;

EXPLAIN ANALYZE
SELECT * 
FROM employees AS e INNER JOIN salaries AS s ON e.emp_no = s.emp_no INNER JOIN titles AS t ON e.emp_no = t.emp_no
WHERE t.title = 'Engineer' OR t.title = 'Senior Engineer' OR t.title = 'Assistant Engineer'
ORDER BY e.emp_no, t.from_date\G

