
/* Este script funciona para crear la base de datos "shoutdb".
* ¡Cuidado! Si la base de datos ya fue creada con anterioridad, este script la borra y la crea de nuevo.
*/

DROP DATABASE IF EXISTS shoutdb;
CREATE DATABASE shoutdb;
USE shoutdb;

CREATE TABLE empleados (
    id_empleado INT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(63) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
	edad INT UNSIGNED DEFAULT NULL COMMENT 'Este atributo derivado se calculará con un evento definido a posteriori.',
    CONSTRAINT pk_emp PRIMARY KEY (id_empleado),
    CONSTRAINT chk_fn CHECK (fecha_nacimiento BETWEEN '1900-01-01' AND '2010-01-01')
);

CREATE TABLE de_planta (
    id_empleado INT UNSIGNED AUTO_INCREMENT,
    fecha_planta DATE NOT NULL,
    CONSTRAINT pk_dp PRIMARY KEY (id_empleado),
    CONSTRAINT fk_dp FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE contratados (
    id_empleado INT UNSIGNED AUTO_INCREMENT,
    tipo_contrato ENUM ('A', 'B', 'C'),
    CONSTRAINT pk_con PRIMARY KEY (id_empleado),
    CONSTRAINT fk_con FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE pedidos (
    id_pedido INT UNSIGNED AUTO_INCREMENT,
    detalle TEXT,
    fecha_pedido DATE NOT NULL,
    id_empleado INT UNSIGNED NOT NULL,
    CONSTRAINT pk_pe PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pe FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado)
);

CREATE TABLE línea_de_pedidos (
    nro_línea INT UNSIGNED, 
    nombre_producto VARCHAR(63),
    cantidad SMALLINT UNSIGNED, 
    id_pedido INT UNSIGNED, 
    CONSTRAINT pk_lp PRIMARY KEY (id_pedido, nro_línea, nombre_producto),
    CONSTRAINT fk_lp FOREIGN KEY (id_pedido) REFERENCES pedidos (id_pedido) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE productos (
    id_producto INT UNSIGNED AUTO_INCREMENT,
    descripción TEXT,
    CONSTRAINT pk_prod PRIMARY KEY (id_producto)
);

CREATE TABLE posee (
    id_pedido INT UNSIGNED,
    id_producto INT UNSIGNED,
    CONSTRAINT pk_pos PRIMARY KEY (id_pedido, id_producto),
    CONSTRAINT fk_pos_pe FOREIGN KEY (id_pedido) REFERENCES pedidos (id_pedido),
    CONSTRAINT fk_pos_prod FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);
