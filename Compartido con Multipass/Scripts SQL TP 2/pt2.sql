DROP DATABASE IF EXISTS cursos;
CREATE DATABASE cursos;
USE cursos;

CREATE TABLE Curso (
    codigo_curso INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    duracion INT NOT NULL,
    coste DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Prerrequisito (
    curso_id INT,
    prerrequisito_id INT,
    obligatorio BOOLEAN,
    PRIMARY KEY (curso_id, prerrequisito_id),
    FOREIGN KEY (curso_id) REFERENCES Curso(codigo_curso) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (prerrequisito_id) REFERENCES Curso(codigo_curso) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Empleado (
    codigo_empleado INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    nif VARCHAR(20) UNIQUE,
    fecha_nacimiento DATE,
    nacionalidad VARCHAR(50),
    sexo CHAR(1),
    firma BLOB,
    salario DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Edicion (
    id_edicion INT PRIMARY KEY,
    curso_id INT,
    fecha_inicio DATE,
    lugar VARCHAR(255),
    horario VARCHAR(50),
    FOREIGN KEY (curso_id) REFERENCES Curso(codigo_curso) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Imparte (
    id_edicion INT,
    codigo_empleado INT,
    PRIMARY KEY (id_edicion, codigo_empleado),
    FOREIGN KEY (id_edicion) REFERENCES Edicion(id_edicion) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codigo_empleado) REFERENCES Empleado(codigo_empleado) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Recibe (
    id_edicion INT,
    codigo_empleado INT,
    PRIMARY KEY (id_edicion, codigo_empleado),
    FOREIGN KEY (id_edicion) REFERENCES Edicion(id_edicion) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codigo_empleado) REFERENCES Empleado(codigo_empleado) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Capacitado (
    codigo_empleado INT PRIMARY KEY,
    FOREIGN KEY (codigo_empleado) REFERENCES Empleado(codigo_empleado) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE No_Capacitado (
    codigo_empleado INT PRIMARY KEY,
    FOREIGN KEY (codigo_empleado) REFERENCES Empleado(codigo_empleado) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Trigger para asegurar que un empleado no pueda ser docente y alumno en la misma edición
DELIMITER $$
CREATE TRIGGER trg_no_docente_y_alumno BEFORE INSERT ON Recibe
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Imparte WHERE Imparte.id_edicion = NEW.id_edicion AND Imparte.codigo_empleado = NEW.codigo_empleado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un empleado no puede ser docente y alumno en la misma edición.';
    END IF;
END$$

CREATE TRIGGER trg_no_alumno_y_docente BEFORE INSERT ON Imparte
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Recibe WHERE Recibe.id_edicion = NEW.id_edicion AND Recibe.codigo_empleado = NEW.codigo_empleado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un empleado no puede ser alumno y docente en la misma edición.';
    END IF;
END$$
DELIMITER ;
