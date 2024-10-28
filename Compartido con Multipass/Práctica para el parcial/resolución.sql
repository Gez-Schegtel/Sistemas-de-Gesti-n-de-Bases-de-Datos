
/* Punto 1. */

DELETE FROM employees AS e WHERE e.emp_no IN (
    SELECT e.emp_no 
    FROM employees AS e INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no INNER JOIN departments AS d ON de.dept_no = d.dept_no
    WHERE d.dept_name LIKE '%I+D%' AND e.birth_date < '1952-03-01' 
);

/* Punto 2. */

WITH cte_temp_count AS (
    SELECT dept_no, COUNT(emp_no) AS total_empleados 
    FROM dept_emp
    WHERE to_date = '9999-01-01'
    GROUP BY dept_no
), 
cte_temp_max AS (
    SELECT MAX(total_empleados) AS max_empleados 
    FROM cte_temp_count
)
SELECT e.first_name, e.last_name, d.dept_name, COUNT(de.emp_no) AS número_emp_a_cargo 
FROM dept_manager dm
JOIN employees e ON dm.emp_no = e.emp_no
JOIN departments d ON dm.dept_no = d.dept_no
JOIN dept_emp de ON de.dept_no = d.dept_no
WHERE dm.to_date = '9999-01-01'
AND de.to_date = '9999-01-01'
AND dm.dept_no IN (
    SELECT dept_no
    FROM cte_temp_count
    WHERE total_empleados = (SELECT max_empleados FROM cte_temp_max)
)
GROUP BY d.dept_no, e.first_name, e.last_name, d.dept_name;


/* Punto 3. */