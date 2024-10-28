DROP DATABASE IF EXISTS company_management;
CREATE DATABASE company_management;
USE company_management;

-- Creación de la tabla employees
CREATE TABLE employees (
    emp_no INT(11) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(14) NOT NULL,
    last_name VARCHAR(16) NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    hire_date DATE NOT NULL,
    PRIMARY KEY (emp_no)
);

-- Creación de la tabla salaries
CREATE TABLE salaries (
    emp_no INT(11) NOT NULL,
    salary INT(11) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL DEFAULT '9999-01-01',
    PRIMARY KEY (emp_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Creación de la tabla titles
CREATE TABLE titles (
    emp_no INT(11) NOT NULL,
    title VARCHAR(50) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL DEFAULT '9999-01-01',
    PRIMARY KEY (emp_no, title, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Creación de la tabla departments
CREATE TABLE departments (
    dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE (dept_name)
);

-- Creación de la tabla dept_emp (registro de empleados por departamento)
CREATE TABLE dept_emp (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL DEFAULT '9999-01-01',
    PRIMARY KEY (emp_no, dept_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- Creación de la tabla dept_manager (registro de gerentes de departamento)
CREATE TABLE dept_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL DEFAULT '9999-01-01',
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- Insertar empleados
INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
VALUES
(10001, '1950-01-01', 'John', 'Smith', 'M', '1980-06-01'),
(10002, '1960-02-15', 'Jane', 'Doe', 'F', '1985-07-12'),
(10003, '1952-03-10', 'Mark', 'Johnson', 'M', '1990-11-23'),
(10004, '1951-05-25', 'Emily', 'White', 'F', '1978-03-03'),
(10005, '1965-08-17', 'Oliver', 'Brown', 'M', '1995-09-15');

-- Insertar salarios
INSERT INTO salaries (emp_no, salary, from_date, to_date)
VALUES
(10001, 70000, '1980-06-01', '9999-01-01'),
(10002, 65000, '1985-07-12', '9999-01-01'),
(10003, 90000, '1990-11-23', '9999-01-01'),
(10004, 80000, '1978-03-03', '9999-01-01'),
(10005, 85000, '1995-09-15', '9999-01-01');

-- Insertar títulos
INSERT INTO titles (emp_no, title, from_date, to_date)
VALUES
(10001, 'Engineer', '1980-06-01', '9999-01-01'),
(10002, 'Senior Engineer', '1985-07-12', '9999-01-01'),
(10003, 'Manager', '1990-11-23', '9999-01-01'),
(10004, 'Technician', '1978-03-03', '9999-01-01'),
(10005, 'Engineer', '1995-09-15', '9999-01-01');

-- Insertar departamentos
INSERT INTO departments (dept_no, dept_name)
VALUES
('d001', 'I+D'),
('d002', 'Ventas'),
('d003', 'Marketing');

-- Insertar empleados en departamentos
INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
VALUES
(10001, 'd001', '1980-06-01', '9999-01-01'),
(10002, 'd002', '1985-07-12', '9999-01-01'),
(10003, 'd001', '1990-11-23', '9999-01-01'),
(10004, 'd003', '1978-03-03', '9999-01-01'),
(10005, 'd001', '1995-09-15', '9999-01-01');

-- Insertar gerentes de departamentos
INSERT INTO dept_manager (emp_no, dept_no, from_date, to_date)
VALUES
(10003, 'd001', '1990-11-23', '9999-01-01'),
(10002, 'd002', '1985-07-12', '9999-01-01'),
(10004, 'd003', '1978-03-03', '9999-01-01');
