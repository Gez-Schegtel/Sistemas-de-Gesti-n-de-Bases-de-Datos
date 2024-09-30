CREATE DATABASE IF NOT EXISTS hospital;
USE hospital;

CREATE TABLE personal (
    dni INT,
    nombre VARCHAR(50),
    apellidos VARCHAR(50),
    direccion VARCHAR(50),
    telefono INT,
    fecha_ingreso DATE,
    CONSTRAINT pk_personal PRIMARY KEY (dni)
);

CREATE TABLE administrativo (
    dni INT,
    cargo VARCHAR(50),
    CONSTRAINT pk_administrativo PRIMARY KEY (dni),
    CONSTRAINT fk_administrativo FOREIGN KEY (dni) REFERENCES personal(dni) ON DELETE CASCADE
);

CREATE TABLE sanitario (
    dni INT,
    CONSTRAINT pk_sanitario PRIMARY KEY (dni),
    CONSTRAINT fk_sanitario FOREIGN KEY (dni) REFERENCES personal(dni) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE enfermeros (
    dni INT,
    antiguedad DATE,
    CONSTRAINT pk_enfermeros PRIMARY KEY (dni),
    CONSTRAINT fk_enfermeros FOREIGN KEY (dni) REFERENCES sanitario(dni) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE medicos (
    dni INT,
    especialidad VARCHAR(100),
    CONSTRAINT pk_medicos PRIMARY KEY (dni),
    CONSTRAINT fk_medicos FOREIGN KEY (dni) REFERENCES sanitario(dni) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tratamientos (
    id INT,
    descripcion TEXT,
    CONSTRAINT pk_tratamientos PRIMARY KEY (id)
);

CREATE TABLE resultados (
    id INT,
    fecha DATE,
    hora TIME,
    comentario TEXT,
    CONSTRAINT pk_resultado PRIMARY KEY (id, fecha, hora),
    CONSTRAINT fk_resultado FOREIGN KEY (id) REFERENCES tratamientos(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE enfermedades (
    nombre VARCHAR(50),
    CONSTRAINT pk_enfermedades PRIMARY KEY (nombre)
);

CREATE TABLE internaciones (
    id INT,
    CONSTRAINT pk_internaciones PRIMARY KEY (id)
);

CREATE TABLE hospitales (
    nombre VARCHAR(50),
    CONSTRAINT pk_hospitales PRIMARY KEY (nombre)
);

CREATE TABLE salas (
    nombre VARCHAR(50),
    numero INT,
    camas SMALLINT,
    CONSTRAINT pk_salas PRIMARY KEY (nombre, numero),
    CONSTRAINT fk_salas FOREIGN KEY (nombre) REFERENCES hospitales(nombre) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE pacientes (
    dni INT,
    nombre_apellido VARCHAR(50),
    fecha_nacimiento DATE,
    edad INT,
    CONSTRAINT pk_pacientes PRIMARY KEY (dni)
);

CREATE TABLE acuden_a (
    nombre VARCHAR(50),
    dni INT,
    CONSTRAINT pk_acuden_a PRIMARY KEY (nombre, dni),
    CONSTRAINT fk_acuden_a_hospitales FOREIGN KEY (nombre) REFERENCES hospitales(nombre),
    CONSTRAINT fk_acuden_a_pacientes FOREIGN KEY (dni) REFERENCES pacientes(dni)
);

CREATE TABLE obras_sociales (
    nombre VARCHAR(50),
    CONSTRAINT pk_obras_sociales PRIMARY KEY (nombre)
);

ALTER TABLE personal
ADD COLUMN nombre_hospital VARCHAR(50),
ADD CONSTRAINT fk_personal FOREIGN KEY (nombre_hospital) REFERENCES hospitales(nombre);

ALTER TABLE pacientes
ADD COLUMN nombre_obra_social VARCHAR(50),
ADD COLUMN numero INT NOT NULL,
ADD CONSTRAINT fk_paciente_obra_social FOREIGN KEY (nombre_obra_social) REFERENCES obras_sociales(nombre);

ALTER TABLE tratamientos
ADD COLUMN nombre_enfermedad VARCHAR(50) NOT NULL,
ADD CONSTRAINT fk_trat_enf FOREIGN KEY (nombre_enfermedad) REFERENCES enfermedades(nombre),
ADD COLUMN dni_med INT NOT NULL,
ADD CONSTRAINT fk_trat_dni FOREIGN KEY (dni_med) REFERENCES medicos(dni),
ADD COLUMN id_internacion INT NOT NULL,
ADD CONSTRAINT fk_trat_id FOREIGN KEY (id_internacion) REFERENCES internaciones(id);

ALTER TABLE internaciones
ADD COLUMN numero_sala INT NOT NULL,
ADD COLUMN nombre_sala VARCHAR(50) NOT NULL,
ADD COLUMN fecha DATE NOT NULL,
ADD COLUMN nombre_hospital VARCHAR(50) NOT NULL,
ADD CONSTRAINT fk_num_sala FOREIGN KEY (nombre_sala, numero_sala) REFERENCES salas(nombre, numero),
ADD CONSTRAINT fk_int_nomhosp FOREIGN KEY (nombre_hospital) REFERENCES hospitales(nombre),
ADD COLUMN dni_paciente INT NOT NULL,
ADD CONSTRAINT fk_int_dnipac FOREIGN KEY (dni_paciente) REFERENCES pacientes(dni);

